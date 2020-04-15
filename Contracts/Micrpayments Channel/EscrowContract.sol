pragma solidity >=0.4.22 <0.7.0;

contract EscrowContract {

    address payable sender;
    address payable receiver;
    uint amountDeposited;
    string connectionURL;
//Constructor taking in the sender and receiver of the payment channel along with the connection URL
    constructor(address payable _sender, address payable _receiver, string memory _url) public {

        sender = _sender;
        receiver = _receiver;
        amountDeposited = 0;
        connectionURL = _url;

    }
//Events
    event depositMade(uint amount, uint timeStamp);
//Function for the sender to deposit his funds in escrow returning the connection URL
    function deposit() public payable returns(string memory) {

        require(msg.sender == sender,"NOT_INTENDED_SENDER");
        amountDeposited += msg.value;
        return connectionURL;

    }

    function checkDeposit() public view returns(string memory, uint) {
        require(msg.sender == receiver, "NOT_INTENDED_RECEIVER");
        return (connectionURL, amountDeposited);
    }
//Function for the receiver to withdraw his due funds
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


