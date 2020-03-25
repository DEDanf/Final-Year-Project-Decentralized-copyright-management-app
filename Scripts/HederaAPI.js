/*
API for Hedera Hashgraph functions
List of all functions:

-RetrieveCost
-RetrieveCostInfo
-SearchFileHash
-RetrieveLicenses
-SetIPAvailability
-SetIPCosts
-AddURL
-Withdraw
-CreateDistributionLicense
-CheckBalance
-PurchaseDistributionLicense
-Purchase
-DepositEscrow
-RegisterCopyright
-CreateClient

*/

var hedera = require('@hashgraph/sdk');

module.exports = {

//Function to retrieve the cost of a contract function
//To be used for PurchaseDistributionLicense.js and RegisterCopyright.js cost paramaters
    RetrieveCost: async function(contractID, client) {

        const callResult = await new hedera.ContractCallQuery()
            .setContractId(contractID)
            .setGas(7000)
            .setFunction('returnCost', null)
            .execute(client);

        return callResult.getString(0);
    },
//Function to retrieve the associated cost and cost information for a given I.P., returns connection cost, cost value and cost info 
//indicating the cost for a given timespan, returns connectionCost, cost, costIntervals (in seconds)
//To be used with Purchase.js
    RetrieveCostInfo: async function(contractID, client) {
        const callResult = await new hedera.ContractCallQuery()
            .setContractId(contractID)
            .setGas(7000)
            .setFunction('returnCostInfo', null)
            .execute(client);
    
        return (callResult.getString(0),callResult.getString(1),callResult.getString(2));
    },
//Function to search the registrationHandler contract for a file hash which returns the associated copyright contract
//To be used with RegistrationHandler.sol
    SearchFileHash: async function(contractID, client, fileHash) {
        var hash = new hedera.ContractFunctionParams().addString(fileHash);

        const callResult = await new hedera.ContractCallQuery()
            .setContractId(contractID)
            .setGas(20000)
            .setFunction('searchFileHash', hash)
            .execute(client);
    
        return callResult.getString(0);    
    },
//Function to retrieve licenses under a copyright contract, can only be used by the owner of that contract
//To be used with RegisteredCopyright.sol
    RetrieveLicenses: async function(contractID, client) {
        const callResult = await new hedera.ContractCallQuery()
            .setContractId(contractID)
            .setGas(7000)
            .setFunction('retrieveLicenses', null)
            .execute(client)

        return callResult.getString(0);
    },
//Function for license owner to set the availability of the IP
//To be used with CommercialDistributionLicense.sol    
    SetIPAvailability: async function(contractID, client, value) {
        var v = new hedera.ContractFunctionParams()
            .addBool(value);

        const callResult = await new hedera.ContractCallQuery()
            .setContractId(contractID)
            .setGas(7000)
            .setFunction('setAvailability', v)
            .execute(client);
    },
//Function for license owner to set the costs of his IP connection
//To be used with CommercialDistributionLicense.sol
    SetIPCosts: async function(contractID, client, connectionCost, cost, costTimeIntervalSeconds) {
        var info = new hedera.ContractFunctionParams()
            .addUint8(connectionCost)
            .addUint8(cost)
            .addUint8(costTimeIntervalSeconds);

        const callResult = await new hedera.ContractCallQuery()
            .setContractId(contractID)
            .setGas(7000)
            .setFunction('setCosts', info)
            .execute(client);
        
    },
//Function for license owner to add connection URL to the license contract, returns number of stored URLs.
//To be used with CommercialDistributionLicense.sol
    AddURL: async function(contractID, client, url, v) {
        var params = new hedera.ContractFunctionParams()
            .addString(url)
            .addBool(v)

        const callResult = await new hedera.ContractCallQuery()
            .setContractId(contractID)
            .setGas(7000)
            .setFunction('addURL', params)
            .execute(client);

        return callResult.getString(0);

    },
//Function to withdraw funds from a contract
//TO be used with RegistrationHandler, RegisteredCopyright and CommercialDistributionLicense
    Withdraw: async function(contractID, client) {
        const callResult = new hedera.ContractCallQuery()
            .setContractId(contractID)
            .setGas(7000)
            .setFunction('withdraw')
            .execute(client);
    },
//Function to create a distribution license only avaialbe to the copyright owner.
//To be used with RegisteredCopyright.sol
    CreateDistributionLicense: async function(contractID, client) {
        const callResult = await new ContractCallQuery()
            .setContractId(contractID)
            .setGas(7000)
            .setFunction('createDistributionLicense',null)
            .execute(client)
    
        return callResult.getString(0);
    },
//Function to check balance of a user
    CheckBalance: async function(client, account) {
    
        const balance = await new hedera.AccountBalanceQuery()       
            .setAccountId(account)        
            .execute(client);
        console.log(balance);
        return `${balance.asTinybar()}`
    },
//This function executes the purchase of a commercial distribution license and returns the created contracts address
//To be used for RegisteredCopyright.sol
    PurchaseDistributionLicense: async function(contractID, client, cost) {
        const getRecord = await (await new hedera.ContractExecuteTransaction()
            .setContractId(contractID)
            .setGas(7000) // ~6016
            .setPayableAmount(cost)
            .setFunction('purchaseDistributionLicense')
            .execute(client))
            .getRecord(client);
  
        return getRecord.getContractExecuteResult().getString(0)

    },
//This function executes the purchase of a file and returns the Escrow contract address.
//To be used for CommercialDistributionLicense.sol
    Purchase: async function(contractID, client, cost) {
        const getRecord = await (await new hedera.ContractExecuteTransaction()
            .setContractId(contractID)
            .setGas(7000) // ~6016
            .setPayableAmount(cost)
            .setFunction('purchase')
            .execute(client))
            .getRecord(client);
  
    return getRecord.getContractExecuteResult().getString(0)
    },
//Function to deposit funds into escrow returning the connection url
//To be used with EscrowContract.sol
    DepositEscrow: async function(contractId, client, deposit) {
          
    const getRecord = await (await new hedera.ContractExecuteTransaction()
        .setContractId(contractID)
        .setGas(7000) // ~6016
        .setPayableAmount(deposit)
        .setFunction('deposit')
        .execute(client))
        .getRecord(client);

    return getRecord.getContractExecuteResult().getString(0);
    },
//This function takes a Client and a file hash and creates a copyright contract on the testnet for that hash, returns its address.
//For use with RegistrationHandler.sol
    RegisterCopyright: async function(file_hash, client, contractID, cost) {
        var hash = new ContractFunctionParams().addString(file_hash);

        const getRecord = await (await new ContractExecuteTransaction()
            .setContractId(contractID)
            .setGas(7000) // ~6016
            .setPayableAmount(cost)
            .setFunction("registerCopyright", hash)
            .execute(client))
            .getRecord(client);
    
        return getRecord.getContractExecuteResult().getString(0);
    },
//This function takes an operator account and the associated private key and creates a hedera client to connect to the testnet.
    CreateClient: function(operatorAccount, operatorPrivateKey) {
        if (operatorPrivateKey == null || operatorAccount == null) {        
            throw new Error(
                "Both OPERATOR_KEY and OPERATOR_ID must be present"
            );  
        }
        
        const client = new hedera.Client({
            network: {"0.testnet.hedera.com:50211": "0.0.3"},
            operator: {
                account: operatorAccount,
                privateKey: operatorPrivateKey
            }
        });
        console.log(client);
        return client;
    }
}

