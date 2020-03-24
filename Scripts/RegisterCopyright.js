//This function takes a Client and a file hash and creates a copyright contract on the testnet for that hash, returns its address.

var hedera = require('@hashgraph/sdk');

async function RegisterCopyright(file_hash, client, contractID, cost) {

    var hash = new ContractFunctionParams().addString(file_hash);

    const getRecord = await (await new ContractExecuteTransaction()
        .setContractId(contractID)
        .setGas(7000) // ~6016
        .setPayableAmount(cost)
        .setFunction("registerCopyright", hash)
        .execute(client))
        .getRecord(client);


    return getRecord.getContractExecuteResult().getString(0);

}