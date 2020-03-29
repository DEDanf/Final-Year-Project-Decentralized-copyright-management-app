// Load the AWS SDK for Node.js
var AWS = require('aws-sdk');
// Set the region
AWS.config.update({region: 'us-east-1'});
var credentials = new AWS.SharedIniFileCredentials({profile: 'default'});
AWS.config.credentials = credentials;
// Create an SQS service object
var sqs = new AWS.SQS({apiVersion: '2012-11-05'});

var params = {
    QueueUrl: 'https://sqs.us-east-1.amazonaws.com/167132469921/fongd98gmailcom_9098c5af5ffd4737988883caaf5e205b.fifo', /* required */
    AttributeNames: [
      'All'
      /* more items */
    ]
  };
  sqs.getQueueAttributes(params, function(err, data) {
    if (err) console.log(err, err.stack); // an error occurred
    else     console.log(data);           // successful response
  });
