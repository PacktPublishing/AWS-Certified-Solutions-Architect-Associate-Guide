#bin/sh

#Stop the instance and wait until stopped
aws ec2 stop-instances --instance-id $CURRENT_INSTANCE --output json
aws ec2 wait instance-stopped --instance-ids $CURRENT_INSTANCE
echo "stopped."

#Start the instance and wait until running
aws ec2 start-instances --instance-id $CURRENT_INSTANCE --output json
aws ec2 wait instance-running --instance-ids $CURRENT_INSTANCE
echo "running.."
