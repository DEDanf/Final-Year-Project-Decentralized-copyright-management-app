//This function executes the purchase of a file and returns the Escrow contract address.
//To be used for CommercialDistributionLicense.sol

var hedera = require('@hashgraph/sdk');

async function Purchase(contractID, client, cost, functionName) {
  
    const getRecord = await (await new hedera.ContractExecuteTransaction()
        .setContractId(contractID)
        .setGas(7000) // ~6016
        .setPayableAmount(cost)
        .setFunction(functionName)
        .execute(client))
        .getRecord(client);
  
    return getRecord.getContractExecuteResult().getString(0)

  }