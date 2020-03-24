//This function executes the purchase of a commercial distribution license and returns the created contracts address
//To be used for RegisteredCopyright.sol

var hedera = require('@hashgraph/sdk');

async function PurchaseDistributionLicense(contractID, client, cost, functionName) {
  
    const getRecord = await (await new hedera.ContractExecuteTransaction()
        .setContractId(contractID)
        .setGas(7000) // ~6016
        .setPayableAmount(cost)
        .setFunction(functionName)
        .execute(client))
        .getRecord(client);
  
    return getRecord.getContractExecuteResult().getString(0)

  }