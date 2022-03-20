#!/bin/bash
echo "########### Setting up localstack profile ###########"
aws configure set aws_access_key_id access_key --profile=localstack
aws configure set aws_secret_access_key secret_key --profile=localstack
aws configure set region sa-east-1 --profile=localstack

echo "########### Setting default profile ###########"
export AWS_DEFAULT_PROFILE=localstack

echo "########### Setting SQS and S3 names as env variables ###########"
export UPLOAD_FILE_EVENT_SQS=upload-file-event-sqs
export DELETE_FILE_EVENT_SQS=delete-file-event-sqs
export BUCKET_NAME=tutorial-bucket

echo "########### Creating upload file event SQS ###########"
aws --endpoint-url=http://localstack:4566 sqs create-queue --queue-name $UPLOAD_FILE_EVENT_SQS

echo "########### ARN for upload file event SQS ###########"
UPLOAD_FILE_EVENT_SQS_ARN=$(aws --endpoint-url=http://localstack:4566 sqs get-queue-attributes\
                  --attribute-name QueueArn --queue-url=http://localhost:4566/000000000000/"$UPLOAD_FILE_EVENT_SQS"\
                  |  sed 's/"QueueArn"/\n"QueueArn"/g' | grep '"QueueArn"' | awk -F '"QueueArn":' '{print $2}' | tr -d '"' | xargs)


echo "########### Creating delete file event SQS ###########"
aws --endpoint-url=http://localstack:4566 sqs create-queue --queue-name $DELETE_FILE_EVENT_SQS

echo "########### ARN for delete file event SQS ###########"
DELETE_FILE_EVENT_SQS_ARN=$(aws --endpoint-url=http://localstack:4566 sqs get-queue-attributes\
                  --attribute-name QueueArn --queue-url=http://localhost:4566/000000000000/"$DELETE_FILE_EVENT_SQS"\
                  |  sed 's/"QueueArn"/\n"QueueArn"/g' | grep '"QueueArn"' | awk -F '"QueueArn":' '{print $2}' | tr -d '"' | xargs)


echo "########### Listing queues ###########"
aws --endpoint-url=http://localhost:4566 sqs list-queues

echo "########### Create S3 bucket ###########"
aws --endpoint-url=http://localhost:4566 s3api create-bucket\
    --bucket $BUCKET_NAME

echo "########### List S3 bucket ###########"
aws --endpoint-url=http://localhost:4566 s3api list-buckets

aws --endpoint-url=http://localhost:4566 s3api put-bucket-notification-configuration\
    --bucket $BUCKET_NAME\
    --notification-configuration  '{
                                      "QueueConfigurations": [
                                         {
                                           "QueueArn": "'"$UPLOAD_FILE_EVENT_SQS_ARN"'",
                                           "Events": ["s3:ObjectCreated:*"]
                                         },
                                         {
                                            "QueueArn": "'"$DELETE_FILE_EVENT_SQS_ARN"'",
                                            "Events": ["s3:ObjectRemoved:*"]
                                          }
                                       ]
                                     }'


aws --endpoint-url=http://localhost:4566 s3api get-bucket-notification-configuration\
    --bucket $BUCKET_NAME



echo "########### Command to upload file to a bucket ###########"
echo "aws --endpoint-url=http://localhost:4566 s3api put-object --bucket tutorial-bucket --key README.md --body README.md"

echo "########### Command to receive upload event message ###########"
echo "aws --endpoint-url=http://localhost:4566 sqs receive-message --queue-url=http://localhost:4566/000000000000/upload-file-event-sqs"

echo "########### Command to delete file from a bucket ###########"
echo "aws --endpoint-url=http://localhost:4566 s3api delete-object --bucket tutorial-bucket --key README.md"

echo "########### Command to receive delete event message ###########"
echo "aws --endpoint-url=http://localhost:4566 sqs receive-message --queue-url=http://localhost:4566/000000000000/delete-file-event-sqs"

