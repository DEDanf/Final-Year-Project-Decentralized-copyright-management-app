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
    string costInfo;
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
    function setAvailability(uint v) public {
        require(msg.sender == owner,"NOT_OWNER");
        if(v == 1) {
            require(connectionURLs.length > 0, "NO_URLS_AVAILABLE");
            available = true;
        }
        if(v == 0) {
            available = false;
        }
    }
//Function to set costs
    function setCosts(uint _connection_cost, uint _cost, string memory _cost_info) public {
        require(msg.sender == owner, "NOT_OWNER");

        connectionCost = _connection_cost;
        cost = _cost;
        costInfo = _cost_info;
    }
//Function to add a URL
    function addURL(string memory _url, uint v) public {

        require(msg.sender == owner,"NOT_OWNER");
        connectionURLs.push(_url);
        if(v == 1) {
            available = true;
        }

    }
//Function to add multiple URLs
    function addURLs(string[] memory _url_list, uint v) public {
        require(msg.sender == owner,"NOT_OWNER");
        for(uint i = 0; i < _url_list.length; i++) {
            connectionURLs.push(_url_list[i]);
        }
        if(v == 1) {
            available = true;
        }
    }
//Function to withdraw funds
    function withdraw() public {

        require(msg.sender == owner,"NOT_OWNER");
        owner.transfer(amount);
    }
//Function to return cost info
    function returnCostInfo() public view returns(uint, uint, string memory) {

        return (connectionCost, cost, costInfo);
    }
}