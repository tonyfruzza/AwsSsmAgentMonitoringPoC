#!/bin/sh
REGION=us-west-2
aws --region $REGION cloudformation deploy --stack-name managed-asg --template-file ssm-managed-server.yml --capabilities CAPABILITY_IAM --parameter-overrides \
 CustomerName=best \
 ApplicationName=SsmMonPoc \
 RoleName=SingleServer \
 SshKey=pod-x \
 ImageId=ami-0cf6f5c8a62fa5da6 \
 Subnets=subnet-077b1285df6190f16,subnet-00256b52529523e02 \
 AvailabilityZones=us-west-2a,us-west-2b \
 AssociatePublicIpAddress=true \
 VpcId=vpc-04061bd919668f2b1

sls deploy --stage common --region $REGION
