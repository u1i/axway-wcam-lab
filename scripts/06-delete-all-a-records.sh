apikey=$(cat apikey.conf | tr -d "\n")

# Reset A records

curl -s -X PUT \
  https://api.godaddy.com/v1/domains/xwaay.net/records/A \
  -H "Authorization: sso-key $apikey " \
  -H 'Content-Type: application/json' \
  -H 'cache-control: no-cache' \
  -d '[
    {
        "data": "185.199.108.153",
        "name": "@",
        "ttl": 600,
        "type": "A"
    },
    {
        "data": "185.199.109.153",
        "name": "@",
        "ttl": 600,
        "type": "A"
    },
    {
        "data": "185.199.110.153",
        "name": "@",
        "ttl": 600,
        "type": "A"
    },
    {
        "data": "185.199.111.153",
        "name": "@",
        "ttl": 600,
        "type": "A"
    }
    ]'
