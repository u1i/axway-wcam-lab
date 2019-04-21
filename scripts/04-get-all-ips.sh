aws ec2 describe-instances --filters "Name=tag-key,Values=apibuilder" | jq ".Reservations[].Instances[0].PublicIpAddress" | sort -u | grep -v null
