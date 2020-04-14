/*
API for Cryptographic Functions using tweetNacl library and making use of ED25519 as standard Hedera Hashgraph protocol.
*/

var hedera = require('@hashgraph/sdk');
var nacl = require('tweetnacl');
var stableLib = require('@stablelib/utf8');

module.exports = {

    EncryptMessage: function(msg, privKey) {

        var key = hedera.Ed25519PrivateKey.fromString(privKey)._keyData;
        var encodedMsg = stableLib.encode(msg);
        return nacl.sign(encodedMsg, key);

    },

    DecryptMessage: function(signedMsg, pubKey) {

        var key = hedera.Ed25519PublicKey.fromString(pub)._keyData;
        var decrypted = nacl.sign.open(signedMsg, pubKey);
        return stableLib.decode(decrypted);

    }

}