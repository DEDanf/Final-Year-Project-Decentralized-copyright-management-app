pragma solidity >=0.4.22 <0.7.0;

contract EscrowContract {

    address payable sender;
    address payable receiver;
    uint amountDeposited;
    string connectionURL;

    constructor(address _sender, address _receiver, string memory _url) public {

        sender = _sender;
        receiver = _receiver;
        amountDeposited = 0;
        connectionURL = _url;

    }

    event depositMade(uint amount, uint timeStamp);

    function deposit() public payable returns(string memory) {

        require(msg.sender == sender,"NOT_INTENDED_SENDER");
        amountDeposited += msg.value;
        emit depositMade(amountDeposited,now);
        return connectionURL;

    }

    function withdraw(bytes32 r, bytes32 s, uint8 v, uint value) public{

        require(msg.sender == receiver,"NOT_RECEIVER");

        address signerAddress;
		bytes32 hashedVal;

        hashedVal = keccak256(abi.encodePacked(this,value));
		signerAddress = ecrecover(hashedVal, v, r, s);
		require(signerAddress == sender,"INVALID_SIGNATURE");

        receiver.transfer(value);
        selfdestruct(sender);

	}
}


