# Needs aws cli setup with the files $HOME/.aws/credentials and $HOME/.aws/config (optional)

tmpfile=/tmp/awsrun.tmp.$$

source aws.conf

aws ec2 run-instances --region=$region --image-id $ami --count 1 --instance-type $itype --key-name $sshkey --security-group-ids $sec --subnet-id $subnet --associate-public-ip-address --tag-specifications 'ResourceType=instance,Tags=[{Key=apibuilder,Value=test}]' > $tmpfile

if [ "$?" != "0" ]
then
	echo "error during provisioning. Limit exceeded?"
	exit 1
fi

sleep 3
instance=$(cat $tmpfile | jq ".Instances[0].InstanceId" | tr -d '"')
public_ip=$(aws ec2 describe-instances --region=$region --instance $instance | jq ".Reservations[].Instances[0].PublicIpAddress" | tr -d '"')
hostname=$(uuidgen  | tr '[:upper:]' '[:lower:]' | sed "s/-.*//;").lab

apikey=$(cat apikey.conf | tr -d "\n")
curl -X PATCH \
  https://api.godaddy.com/v1/domains/xwaay.net/records \
  -H "Authorization: sso-key $apikey" \
  -H 'Content-Type: application/json' \
  -H 'cache-control: no-cache' \
  -d '[
  {
    "data": "'''$public_ip'''",
    "name": "'''$hostname'''",
    "port": 1,
    "priority": 0,
    "protocol": "string",
    "service": "string",
    "ttl": 600,
    "type": "A",
    "weight": 10
  }
]'

source b9y.conf

# Get b9y token

token=$(curl -s -X POST \
  "$b9y_host/auth/token?raw" \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \
  -d '{
  "username": "'''$b9y_user'''",
  "password": "'''$b9y_password'''"
}')


curl -X POST \
  $b9y_host/lists/stuff \
  -H 'Accept: application/json' \
  -H "Authorization: Bearer $token" \
  -H 'Content-Type: text/plain' \
  -d "${hostname}.xwaay.net"

echo -e "\n-----------------------"
echo "Instance: $instance"
echo "Public IP: $public_ip"
echo "DNS: ${hostname}".xwaay.net
echo "WebSSH: http://axway:Axway123@${hostname}.xwaay.net:8022/ssh/host/${hostname}.xwaay.net"

