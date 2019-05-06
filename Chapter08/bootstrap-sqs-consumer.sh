#!/bin/bash

cat <<EOT >> ~/.bash_profile
export EC2_HOME=/opt/aws/apitools/ec2
export PATH=$PATH:$EC2_HOME/bin
export JAVA_HOME=/usr/
EOT
source ~/.bash_profile

idDocument=http://169.254.169.254/latest/dynamic/instance-identity/document
export REGION=$(curl -s $idDocument | grep region | cut -d \" -f4)
export RESOURCE_ID=$(curl -s $idDocument | grep instanceId | cut -d \" -f4)
export QUEUE_NAME=$(/opt/aws/bin/ec2-describe-tags --region $REGION --filter "resource-type=instance" --filter "resource-id=$RESOURCE_ID" --filter "key=QueueName" | cut -f5)

curl http://d1d49dy4wvnn4f.cloudfront.net/chapter08/sqs-batch-consumer.py -o sqs-batch-consumer.py -s

pip install boto3
echo "*/1 * * * * python /sqs-batch-consumer.py $QUEUE_NAME $REGION >> /home/ec2-user/sqsjob.log 2>&1" >> /var/spool/cron/root

#EC2 Instance Role
