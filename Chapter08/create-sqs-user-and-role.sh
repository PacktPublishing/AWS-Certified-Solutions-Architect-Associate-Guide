#!/bin/bash

clear
echo "This script will create an IAM user and then assign the proper permissions following the Least Principle Model"
echo "Creating the SQS Admin User"
sleep 3 && clear

aws iam create-user --user-name sqs-user
credentials=$(aws iam create-access-key --user-name sqs-user \
   --query 'AccessKey.[AccessKeyId,SecretAccessKey]'  --output text)
access_key_id=$(echo $credentials | cut -d' ' -f 1)
secret_access_key=$(echo $credentials | cut -d' ' -f 2)
aws configure set profile.sqs-user.aws_access_key_id "$access_key_id"
aws configure set profile.sqs-user.aws_secret_access_key "$secret_access_key"

echo "SQS Admin User created"
sleep 3 && clear

echo "Attaching the AmazonSQSFullAccess IAM Policy"
aws iam attach-user-policy --user-name sqs-user --policy-arn arn:aws:iam::aws:policy/AmazonSQSFullAccess

echo "Policy Attached"

sleep 3 && clear

echo "Creating an EC2 service role"

EC2_READONLY_POLICY=arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess
SQS_FULLACCESS_POLICY=arn:aws:iam::aws:policy/AmazonSQSFullAccess
S3_READONLY_POLICY=arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

ROLE_NAME=SQSMessagingRole
INSTANCE_PROFILE_NAME="$ROLE_NAME-Profile"
aws iam create-role --role-name $ROLE_NAME --assume-role-policy-document file://trust-policy-for-ec2.json

ROLE_ARN=$(aws iam get-role --role-name $ROLE_NAME --query "Role.Arn" --output text)

sleep 3 && clear

echo "Attaching role policies..."

aws iam attach-role-policy --role-name $ROLE_NAME --policy-arn $EC2_READONLY_POLICY
aws iam attach-role-policy --role-name $ROLE_NAME --policy-arn $SQS_FULLACCESS_POLICY
aws iam attach-role-policy --role-name $ROLE_NAME --policy-arn $S3_READONLY_POLICY

sleep 3 && clear

echo "Creating an EC2 instance profile"

aws iam create-instance-profile --instance-profile-name $INSTANCE_PROFILE_NAME
aws iam add-role-to-instance-profile --instance-profile-name $INSTANCE_PROFILE_NAME --role-name $ROLE_NAME

sleep 3 && clear

echo "Done..."
