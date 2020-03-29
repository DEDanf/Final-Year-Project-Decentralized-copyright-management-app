// Load dependencies
var AWS = require('aws-sdk');
var HederaAPI = require('./HederaAPI');
var keccak256 = require('keccak256');

// Set configurations
AWS.config.update({region: 'REGION'});
var credentials = new AWS.SharedIniFileCredentials({profile: 'default'});
AWS.config.credentials = credentials;

// Create an SQS service object, set URL and set parameters
var sqs = new AWS.SQS({apiVersion: '2012-11-05'});
var queueURLlink = "https://sqs.us-east-1.amazonaws.com/167132469921/fongd98gmailcom_f0ebe884a6984897887051e54f187f9f.fifo";

var params = {
    QueueUrl: queueURLlink,
    AttributeNames: [
        'All'
    ]
};

const { Consumer } = require('sqs-consumer');
 
const app = Consumer.create({

    queueUrl: queueURLlink,
    handleMessage: async (message) => {
        console.log(message.Body);
        var body = JSON.parse(message.Body);
        console.log(body.data[0].message.functionName);
        console.log('success');
        var buyerAddress = body.data[0].message.inputValues[0];
        var escrowContractAddress = body.data[0].message.inputValues[1];
        var urlCount = body.data[0].message.inputValues[2];
        console.log(buyerAddress);
        console.log(escrowContractAddress);
        console.log(urlCount);
        //if(urlCount < 5) {urlHandler -> generates URL + HederaAPI.addURL(generatedURL)}
  }
});
 
app.on('error', (err) => {
  console.error(err.message);
});
 
app.on('processing_error', (err) => {
  console.error(err.message);
});
 
app.start();

