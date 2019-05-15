source aws.conf

aws ec2 associate-address --region=$region --instance-id i-XX --allocation-id eipalloc-XXX
