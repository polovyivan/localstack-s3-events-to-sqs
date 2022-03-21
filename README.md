
<p align="center">
  <img width="460" height="300" src="image-url.png">
</p>

<h1 align="center"><a href="blog-url">blog-name
</a></h1>


Commands:

```sh
#Command to upload file to a bucket
echo aws --endpoint-url=http://localhost:4566 s3api put-object --bucket tutorial-bucket --key <key> --body <file-name>

#Command to receive upload event message
echo aws --endpoint-url=http://localhost:4566 sqs receive-message --queue-url=http://localhost:4566/000000000000/upload-file-event-sqs

#Command to delete file from a bucket
echo aws --endpoint-url=http://localhost:4566 s3api delete-object --bucket tutorial-bucket --key <key>

#Command to receive delete event message
echo aws --endpoint-url=http://localhost:4566 sqs receive-message --queue-url=http://localhost:4566/000000000000/delete-file-event-sqs
```