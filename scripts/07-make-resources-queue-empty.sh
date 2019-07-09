if [ "$#" != "1" ]
then
        echo Usage: $0 lab_id
        echo Example: $0 7189
        exit 1
fi

lab_id=$1

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


for x in $(seq 200)
do
	curl $b9y_host/lists/q_$lab_id -H "Authorization: Bearer $token" 
done
