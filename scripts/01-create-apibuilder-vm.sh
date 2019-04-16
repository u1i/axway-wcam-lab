# Needs aws cli setup with the files $HOME/.aws/credentials and $HOME/.aws/config (optional)
# Values are good for AWS region = ap-southeast-1

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
public_ip=$(aws ec2 describe-instances --instance $instance | jq ".Reservations[].Instances[0].PublicIpAddress")
echo "Instance $instance"
echo "IP $public_ip"
