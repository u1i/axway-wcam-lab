if [ "$#" != "1" ]
then
	echo Usage: $0 labid
	exit 1
fi

labid=$1

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


curl -s $b9y_host/keys -H "Authorization: Bearer $token" | jq "." | grep "lab:$labid:" | tr '"' "\n" | grep lab
