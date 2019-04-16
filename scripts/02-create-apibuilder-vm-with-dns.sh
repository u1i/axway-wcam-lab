# Needs aws cli setup with the files $HOME/.aws/credentials and $HOME/.aws/config (optional)
# Values are good for AWS region = ap-southeast-1

# expects a file apikey.conf with GoDaddy API Key, content "key:secret"
# API Builder on Ubuntu 16.04 LTS
ami=ami-0fb1fcdc19ce3261c

# Subnet
subnet=subnet-8c9e55e9

# Instance Type
itype=t2.micro

# SSH Key
sshkey=uh-2017-06

# Security Group
sec=sg-1a2ee67f

tmpfile=/tmp/awsrun.tmp.$$

aws ec2 run-instances --image-id $ami --count 1 --instance-type $itype --key-name $sshkey --security-group-ids $sec --subnet-id $subnet --associate-public-ip-address --tag-specifications 'ResourceType=instance,Tags=[{Key=apibuilder,Value=test}]' > $tmpfile
sleep 3
instance=$(cat $tmpfile | jq ".Instances[0].InstanceId" | tr -d '"')
public_ip=$(aws ec2 describe-instances --instance $instance | jq ".Reservations[].Instances[0].PublicIpAddress" | tr -d '"')
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

echo "Instance: $instance"
echo "Public IP: $public_ip"
echo "DNS: ${hostname}".xwaay.net
