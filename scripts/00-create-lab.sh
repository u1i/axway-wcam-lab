if [ "$#" != "2" ]
then
	echo Usage: $0 lab_id text
	echo Example: $0 7189 "test lab"
	exit 1
fi

labid=$1
labinfo=$2

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

echo $token

curl -X PUT \
  $b9y_host/keys/lab:$labid \
  -H 'Accept: application/json' \
  -H "Authorization: Bearer $token" \
  -d '{"info": "'''$labinfo'''"}'
