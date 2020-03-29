const HederaAPI = require('./Scripts/HederaAPI');
const keccak256 = require('keccak256');

async function main() {
    /*
    var c = HederaAPI.CreateClient("0.0.153386",
    "302e020100300506032b6570042204203513c3d59352f69749025bc7bc7d8ff10386bc61a11f756eec7b61e34e4b35d2");

    var url = await HederaAPI.DepositEscrow("0.0.209432", c, 10);
    console.log(url);
    var a = await HederaAPI.CheckDeposit(c,"0.0.209432");
    console.log(a);
    */

    console.log(keccak256('hi').toString('hex'));


}   

main();