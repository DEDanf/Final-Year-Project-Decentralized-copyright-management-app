//This function takes an operator account and the associated private key and creates a hedera client to connect to the testnet.

const hedera = require('@hashgraph/sdk');

async function main() {

    const smartContract = require("/Users/danielw.y.fong/Documents/College/FYP/Final-Year-Project/Contracts/RegistrationHandler.json");
    const smartContractByteCode = smartContract.contracts[ "RegistrationHandler.sol: RegistrationHandler" ].bin;

    console.log("contract bytecode size:", smartContractByteCode.length, "bytes");

    // First we must upload a file containing the byte code
    const byteCodeFileId = (await (await new FileCreateTransaction()
        .setMaxTransactionFee(new Hbar(3))
        .addKey(operatorPrivateKey.publicKey)
        .setContents(smartContractByteCode)
        .execute(hederaClient))
        .getReceipt(hederaClient))
        .getFileId();

    console.log("contract bytecode file:", byteCodeFileId.toString());

    // Next we instantiate the contract instance
    const record = await (await new ContractCreateTransaction()
        .setMaxTransactionFee(new Hbar(100))
        // Failing to set this to an adequate amount
        // INSUFFICIENT_GAS
        .setGas(2000) // ~1260
        // Failing to set parameters when parameters are required
        // CONTRACT_REVERT_EXECUTED
        .setConstructorParams(new ContractFunctionParams()
            .addString("hello from hedera"))
        .setBytecodeFileId(byteCodeFileId)
        .execute(hederaClient))
        .getRecord(hederaClient);

    const newContractId = record.receipt.getContractId();

    console.log("contract create gas used:", record.getContractCreateResult().gasUsed);
    console.log("contract create transaction fee:", record.transactionFee.asTinybar());
    console.log("contract:", newContractId.toString());
