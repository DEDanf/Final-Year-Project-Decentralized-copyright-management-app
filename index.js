const HederaAPI = require('./Scripts/HederaAPI');

async function main() {
    var c = HederaAPI.CreateClient("0.0.153386",
    "302e020100300506032b6570042204203513c3d59352f69749025bc7bc7d8ff10386bc61a11f756eec7b61e34e4b35d2")
    var a = await HederaAPI.CheckBalance(c, "0.0.153386" );
    console.log(a);
}   

main();