# launch this to create localhost:9432 tunnel to codebarn rds instance
# via codebarn ec2 instance, using codebarn_ohio.pem keys
# which must already be added via ssh-add -K codebarn_ohio.pem
ssh -NL 9432:codebarn.cwxe12hian6h.us-east-2.rds-preview.amazonaws.com:5432 ubuntu@ec2-18-222-124-92.us-east-2.compute.amazonaws.com -v
