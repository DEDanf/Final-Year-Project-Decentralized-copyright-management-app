pragma solidity >=0.4.22 <0.7.0;

import "./EscrowContract.sol";

contract CommercialDistributionLicense {

    address payable owner;
    uint amount;
    string fileHash;
    string[] connectionURLs;
    bool available;
    uint connectionCost;
    uint cost;
    uint costTimeIntervalInSeconds;
//Events
    event purchaseMade(address buyer, EscrowContract contractCreated);
    event urlsDepleted(uint timeStamp);
//Constructor taking in file hash and the owner
    constructor(string memory _file_hash, address payable _owner) public {

        owner = _owner;
        fileHash = _file_hash;
        amount = 0;
        available = false;
    }
//Function to purchase IP initializing Escrow Contract
    function purchase() public payable returns(EscrowContract) {

        require(available,"CONTENT_NOT_AVAILABLE");
        require(msg.value == connectionCost,"WRONG_PAYMENT");

        string memory url = connectionURLs[connectionURLs.length-1];
        delete connectionURLs[connectionURLs.length-1];
        if(connectionURLs.length == 0) {
            emit urlsDepleted(now);
            available = false;
        }

        EscrowContract contractCreated = new EscrowContract(msg.sender, owner, url);
        emit purchaseMade(msg.sender, contractCreated);
        return contractCreated;

    }
//Function to set distribution availability
    function setAvailability(bool v) public {
        require(msg.sender == owner,"NOT_OWNER");
        available = v;
    }
//Function to set costs
    function setCosts(uint _connection_cost, uint _cost, uint _cost_time_interval_in_seconds) public {
        require(msg.sender == owner, "NOT_OWNER");

        connectionCost = _connection_cost;
        cost = _cost;
        costTimeIntervalInSeconds = _cost_time_interval_in_seconds;
    }
//Function to add a URL
    function addURL(string memory _url, bool v) public returns(uint256) {

        require(msg.sender == owner,"NOT_OWNER");
        connectionURLs.push(_url);
        available = v;
        return connectionURLs.length;

    }
//Function to withdraw funds
    function withdraw() public {

        require(msg.sender == owner,"NOT_OWNER");
        owner.transfer(amount);
    }
//Function to return cost info
    function returnCostInfo() public view returns(uint, uint, uint) {

        return (connectionCost, cost, costTimeIntervalInSeconds);
    }
}