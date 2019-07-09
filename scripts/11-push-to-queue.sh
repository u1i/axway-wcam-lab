source b9y.conf

if [ "$#" != "2" ]
then
	echo Usage: $0 lab_id data
	echo Example: $0 3721 \"hello world\"
	exit 1
fi

lab_id=$1

# Get b9y token

token=$(curl -s -X POST \
  "$b9y_host/auth/token?raw" \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \
  -d '{
  "username": "'''$b9y_user'''",
  "password": "'''$b9y_password'''"
}')


curl -X POST -d "$1" $b9y_host/lists/q_$lab_id -H "Authorization: Bearer $token" 
