import sys
import boto3

MAX_NUMBER_OF_MESSAGES=10

def get_aproximate_number_of_messages(queue):
    queue_attributes = queue.attributes
    return int(queue_attributes.get("ApproximateNumberOfMessages"))

if len(sys.argv) > 2:
    sqs = boto3.resource('sqs', region_name=sys.argv[2])
    queue = sqs.get_queue_by_name(QueueName=sys.argv[1])
    remaining_messages = get_aproximate_number_of_messages(queue)

    if remaining_messages > 0:
        for message in queue.receive_messages(AttributeNames=['All'],MaxNumberOfMessages=MAX_NUMBER_OF_MESSAGES):
            print("\nDeleting message:" + str(message))
            message.delete()

        queue_attributes = queue.attributes
        available_messages = int(queue_attributes.get("ApproximateNumberOfMessages") )
        print("\nMessages left on Queue: " + str(get_aproximate_number_of_messages(queue) ) )
    else:
        print("\nNo messages to proccess...")
