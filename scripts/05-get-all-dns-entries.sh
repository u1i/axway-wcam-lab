apikey=$(cat apikey.conf | tr -d "\n")

curl -s  -X GET \
  https://api.godaddy.com/v1/domains/xwaay.net/records/A \
  -H "Authorization: sso-key $apikey " \
  -H 'cache-control: no-cache' | jq . | grep lab | tr '"' "\n" | grep lab
