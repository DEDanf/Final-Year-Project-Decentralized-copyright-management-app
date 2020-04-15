pragma solidity >=0.4.22 <0.7.0;

contract IpPurchase{

    string url;
    uint amount;
    address owner;

    uint cost;
    bool available;

    constructor(string memory _url) public {

        url = _url;
        owner = msg.sender;
        amount = 0;
        available = false;

    }

    event sale(bytes32 token);

    function setCost(uint _cost) public {
        require(msg.sender == owner, "NOT OWNER");
        cost = _cost;
    }

    function setAvailability(bool v) public {
        require(msg.sender == owner, "NOT OWNER");
        available = v;
    }

    function getCost() public view returns(uint) {
        return cost;
    }

    function purchase() public payable returns(bytes32) {
        require(available, "CONTENT NOT AVAILABLE");
        require(msg.value == cost,"WRONG PAYMENT");
        amount += msg.value;
        bytes32 token = keccak256(abi.encodePacked(msg.sender,now));
        emit sale(token);
        return token;
    }


}