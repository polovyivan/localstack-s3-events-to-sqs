
<p align="center">
  <img width="460" height="300" src="https://miro.medium.com/max/700/1*5OyvJ_ObXznA2H9JNfnVCA.png">
</p>

<h1 align="center"><a href="https://faun.pub/enable-aws-s3-bucket-events-notification-publishing-to-sqs-locally-using-localstack-45f369f74399">Enable AWS S3 bucket events notification publishing to SQS locally using Localstack
</a></h1>


Commands:

```sh
#Command to upload file to a bucket
 aws --endpoint-url=http://localhost:4566 s3api put-object --bucket tutorial-bucket --key <key> --body <file-name>

#Command to receive upload event message
 aws --endpoint-url=http://localhost:4566 sqs receive-message --queue-url=http://localhost:4566/000000000000/upload-file-event-sqs

#Command to delete file from a bucket
 aws --endpoint-url=http://localhost:4566 s3api delete-object --bucket tutorial-bucket --key <key>

#Command to receive delete event message
 aws --endpoint-url=http://localhost:4566 sqs receive-message --queue-url=http://localhost:4566/000000000000/delete-file-event-sqs
```