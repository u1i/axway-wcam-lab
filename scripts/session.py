from bottle import default_app, route, view, request, response, template, redirect, auth_basic
from b9y import B9y
import random, string, uuid, json

def pwcheck(user, pw):
    if pw == "XXXXXXXXXX":
        return True
    else:
        return False

@route('/')
@view('form')
def hello_world():
    return dict(message="")

@route('/session')
def do_login():
    b9y = B9y('http://b9y.redis.sg:8050', 'admin', 'XXXXXXXXX')
    pin = request.query['pin']
    # cp = request.query['g-recaptcha-response']
    lab_data=b9y.get("lab:"+str(pin))

    #if cp == None or cp == "":
    #    return template('form', message="Are you a robot?")

    if lab_data == None:
        return template('form', message="Invalid PIN. Please try again!")

    try:
        lab = json.loads(lab_data)
        info = lab["info"]
        session = request.get_cookie("session")
    except:
        return template('msg', msg="Something wrent horribly wrong.")

    if session == None:
        session = str(uuid.uuid4()).replace("-","")
        response.set_cookie("session", str(session), expires=1666908083)

    session_data_key = "lab:" + str(pin) + ":" + session

    sessioninfo=b9y.get(session_data_key)

    # get a resource if session info is empty
    if sessioninfo == None or sessioninfo == "None":
        sessioninfo = b9y.pop("stuff")
        b9y.set(session_data_key, sessioninfo)

    # if still empty we ran out of resources
    if sessioninfo == None or sessioninfo == "None":
        return template('msg', msg="This lab has no more available resources. Sorry! <a href='/logout'> (logout)</a>")

    return template('session', labid=pin, labsession=session, labinfo=info, sessioninfo=sessioninfo)

@route('/logout')
def do_logout():
    response.set_cookie("session", "", expires=0)
    redirect("/")

@route('/admin/<id:int>')
@auth_basic(pwcheck)
@view('admin')
def adm(id):

    b9y = B9y('http://b9y.redis.sg:8050', 'admin', 'XXXXX')
    sessions = b9y.keys("lab:" + str(id) + ":")
    s2={}

    for s in sessions:
        sd = b9y.get(s)
        s2[s] = sd

    return dict(labid=str(id), list=sessions, grid=s2)

application = default_app()
