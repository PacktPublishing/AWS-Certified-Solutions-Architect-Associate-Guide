#!/bin/bash

clear

echo "Creating Administration IAM Group"

aws iam create-group --group-name "Administration"

sleep 3 && clear

echo "Creating DatabaseAdministrator IAM Group"

aws iam create-group --group-name "DatabaseAdministrator"

sleep 3 && clear

echo "Creating NetworkAdministrator IAM Group"

aws iam create-group --group-name "NetworkAdministrator"

sleep 3 && clear

echo "Creating Development IAM Group"

aws iam create-group --group-name "Development"

sleep 3 && clear

echo "Creating Auditors IAM Group"

aws iam create-group --group-name "Auditors"

sleep 3 && clear

echo "Creating administrator IAM User"

aws iam create-user --user-name "administrator"
aws iam create-login-profile --user-name administrator --password administrator

echo "Adding administrator to Administration"
aws iam add-user-to-group --group-name "Administration" --user-name "administrator"

sleep 3 && clear

echo "Creating Alan IAM User"

aws iam create-user --user-name "Alan"
aws iam create-login-profile --user-name Alan --password Alan

echo "Adding Alan to DatabaseAdministrator"
aws iam add-user-to-group --group-name "DatabaseAdministrator" --user-name "Alan"

echo "Adding Alan to NetworkAdministrator"
aws iam add-user-to-group --group-name "NetworkAdministrator" --user-name "Alan"

sleep 3 && clear

echo "Creating Ada IAM User"

aws iam create-user --user-name "Ada"
aws iam create-login-profile --user-name Ada --password Ada

echo "Adding Ada to NetworkAdministrator"
aws iam add-user-to-group --group-name "NetworkAdministrator" --user-name "Ada"

sleep 3 && clear

echo "Creating Dennis IAM User"

aws iam create-user --user-name "Dennis"
aws iam create-login-profile --user-name Dennis --password Dennis

sleep 3 && clear

echo "Attaching AmazonEC2FullAccess IAM Policy for Dennis"

aws iam attach-user-policy --user-name "Dennis" --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess

echo "Adding Dennis to Development"
aws iam add-user-to-group --group-name "Development" --user-name "Dennis"

sleep 3 && clear

echo "Creating RoleCreatorPolicy"

POLICY_ARN=$(aws iam create-policy --policy-name "RoleCreatorPolicy-$RANDOM" --policy-document file://RoleCreatorPolicy.json --query "Policy.Arn" --output text)

echo "Creating IAM Service Role EC2ToS3InstanceRole"

aws iam create-role --role-name "EC2ToS3InstanceRole" --assume-role-policy-document file://Trust-Policy.json

echo "Attaching AWS Managed Policy S3 Access to Role"

aws iam attach-role-policy --role-name EC2ToS3InstanceRole --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess

sleep 3 && clear

echo "Attaching RoleCreatorPolicy to Development Group"
aws iam attach-group-policy --group-name "Development" --policy-arn $POLICY_ARN



echo "/********************************/"
echo "     User      |    Password      "
echo " administrator |    administrator "
echo "     Alan      |    Alan          "
echo "     Ada       |    Ada           "
echo "/********************************/"
echo "¡¡ Change passwords inmediately !!"
