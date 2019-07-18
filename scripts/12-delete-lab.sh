if [ "$#" != "1" ]
then
	echo Usage: $0 lab_id
	echo Example: $0 7189
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

echo $token

echo Deleting lab $labid
# Delete Lab
curl -X DELETE $b9y_host/keys/lab:$labid \
  -H 'Accept: application/json' \
  -H "Authorization: Bearer $token" 

# Find all Sessions and delete those
sessions=$(curl -s $b9y_host/keys -H 'Accept: application/json' -H "Authorization: Bearer $token" | grep "session:$labid" | tr '"' "\n" | grep "session:$labid")

for s in $sessions
do
	echo Deleting session $s

	curl -X DELETE $b9y_host/keys/$s -H 'Accept: application/json' -H "Authorization: Bearer $token" 
done
