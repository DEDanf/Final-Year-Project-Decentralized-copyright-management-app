pragma solidity >=0.4.22 <0.7.0;

contract CommercialDistributionLicense {

    address payable owner;
    uint amount;
    string fileHash;
    string[] connectionURLs;
    bool available;
    uint cost;
    string costInfo;

    constructor(string memory _file_hash, address payable _owner) public {

        owner = _owner;
        fileHash = _file_hash;
        amount = 0;
        available = false;

    } 

    function 




    
}