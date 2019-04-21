for ip in $(aws ec2 describe-instances --filters "Name=tag-key,Values=apibuilder" | jq ".Reservations[].Instances[0].PublicIpAddress" | sort -u | grep -iv null | tr -d '"')
do
	echo IP: $ip

	ssh -o ConnectTimeout=5 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /home/uli/.ssh/uh-2017-06.pem ubuntu@$ip 'hostname;sudo docker ps'
done
