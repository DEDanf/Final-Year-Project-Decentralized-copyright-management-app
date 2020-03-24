//This function takes an operator account and the associated private key and creates a hedera client to connect to the testnet.

var hedera = require('@hashgraph/sdk');

async function createClient(operatorAccount, operatorPrivateKey) {

    if (operatorPrivateKey == null || operatorAccount == null) {        
        throw new Error(
            "environment variables OPERATOR_KEY and OPERATOR_ID must be present"
        );  
    }
    
    const client = new hedera.Client({
        network: {"0.testnet.hedera.com:50211": "0.0.3"},
        operator: {
            account: operatorAccount,
            privateKey: operatorPrivateKey
        }
    });

    return client;

}