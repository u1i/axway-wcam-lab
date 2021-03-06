if [ "$#" != "2" ]
then
	echo Usage: $0 lab_id text
	echo Example: $0 7189 "test lab"
	exit 1
fi

labid=$1
labinfo=$2

re='^[0-9]+$'
if ! [[ $labid =~ $re ]] || [ "$(expr length $labid)" != "4" ]
then
	echo "New PIN must be a 4 digit number"
	exit 1
fi

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

echo '{"info": "'''$labinfo'''"}' | curl -X PUT \
  $b9y_host/keys/lab:$labid \
  -H 'Accept: application/json' \
  -H "Authorization: Bearer $token" \
  -d @-
  #-d '{"info": "'''$labinfo'''"}'
