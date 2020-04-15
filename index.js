const HederaAPI = require('./Scripts/HederaAPI');
const keccak256 = require('keccak256');
const file = require('./Vehicles.json')
var hedera = require('@hashgraph/sdk');
var nacl = require('tweetnacl');
var stableLib = require('@stablelib/utf8');
var crypto = require('./Scripts/Crypto');

async function main() {

    var key = '302e020100300506032b6570042204203513c3d59352f69749025bc7bc7d8ff10386bc61a11f756eec7b61e34e4b35d2';
    var pub = '302a300506032b6570032100711a126517b25c01f94be8100a09769748c3b3d2442a552a27c5d69114d449f0';
    var encrypted = crypto.EncryptMessage('hi', key);
    console.log(encrypted);
    var decrypted = crypto.DecryptMessage(encrypted, pub);
    console.log(decrypted);



    //const b = hedera.Ed25519PublicKey.caller.fromString('302a300506032b6570032100711a126517b25c01f94be8100a09769748c3b3d2442a552a27c5d69114d449f0');
/*
    console.log(file.Vehicles[0].Name);
    var obj = {
        Name: file.Vehicles[0].Name,
        Engine: file.Vehicles[0].Engine[0].Details[0],
        Color: file.Vehicles[0].Colors[2],
        AdditionalFeatures: [
            file.Vehicles[0].AdditionalFeatures[0],
            file.Vehicles[0].AdditionalFeatures[1]
        ]
    }
    var cost = file.Vehicles[0].Engine[0].Details[0].Cost +     
                file.Vehicles[0].AdditionalFeatures[0].EnableNavigation +
                file.Vehicles[0].AdditionalFeatures[1].CruiseControl;
    console.log(file.Vehicles[0].Engine[0].Details[0].Cost);
    console.log(file.Vehicles[0].AdditionalFeatures[0].EnableNavigation);
    console.log(file.Vehicles[0].AdditionalFeatures[1].CruiseControl);
    console.log(cost);
    var objString = obj.toString();

    var hash = keccak256(objString).toString('hex');
    console.log(hash)
*/
}   

main();