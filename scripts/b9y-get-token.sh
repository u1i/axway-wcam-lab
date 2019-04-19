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

curl -X POST \
  $b9y_host/lists/stuff \
  -H 'Accept: application/json' \
  -H "Authorization: Bearer $token" \
  -H 'Content-Type: text/plain' \
  -d "$RANDOM"
