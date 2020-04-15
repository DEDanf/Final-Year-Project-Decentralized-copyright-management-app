/**************************************** 

Logic for the Smart contracts to handle the Micropayments channel.

Main Contract has the information relating to the cost of the service
per 10 seconds, where the user must be sending digitally signed receipts 
through AJAX polling to the server in order to access the data stream.
User may purchase the service, creating an escrow contract where the user may
deposit the limit of funds to use for the service.
The connection identifying token will be a hash of the timestamp of purchase
derived from the now function along with the escrow contract ID and the purchase contract ID.

User will then access the service and upon completion the server will withdraw from the escrow
contract using the signed receipts.

*****************************************/

pragma solidity >=0.4.22 <0.7.0;

contract Microservice {

    address payable owner;
    uint amount;
    string serviceURL;

    uint purchaseCost;
    uint connectionCost;
    bool available;

    constructor(string memory _url) public {
        owner = msg.sender;
        amount = 0;
        serviceURL = _url;
        available = false;
    }

    event sale(address payable buyer, EscrowContract createdContract, uint timeStamp);

    function viewCosts() public view returns(uint _purchaseCost, uint _connectionCost) {

        require(available,"NOT AVAILABLE");
        return(purchaseCost, connectionCost);
    }

    function purchase() public payable returns(EscrowContract createdContract) {

        require(msg.value == purchaseCost,"WRONG PAYMENT");
        uint timeStamp = now;
        EscrowContract created = new EscrowContract(msg.sender, owner, serviceURL, timeStamp);
        emit sale(msg.sender, created, timeStamp);
        return(created);

    }

    function setCosts(uint _purchaseCost, uint _connectionCost) public {
        require(msg.sender == owner, "NOT OWNER");
        purchaseCost = _purchaseCost;
        connectionCost = _connectionCost;
        available = true;
    }

    function setAvailability(bool v) public {
        require(msg.sender == owner, "NOT OWNER");
        available = v;
    }


}

contract EscrowContract {

    address payable sender;
    address payable receiver;
    uint amountDeposited;
    string connectionURL;
    uint timeStamp;
//Constructor taking in the sender and receiver of the payment channel along with the connection URL
    constructor(address payable _sender, address payable _receiver, string memory _url, uint _timeStamp) public {

        sender = _sender;
        receiver = _receiver;
        amountDeposited = 0;
        connectionURL = _url;
        timeStamp = _timeStamp;

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
