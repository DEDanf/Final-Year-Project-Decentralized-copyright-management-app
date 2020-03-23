pragma solidity >=0.4.22 <0.7.0;

import "./CommercialDistributionLicense.sol";

contract RegisteredCopyright {

    owner[] owners;
    CommercialDistributionLicense[] licenseContracts;
    string fileHash;
    uint timeStamp;
    bool sellingLicenses;
    uint licenseCost;

//Data structure for owner including his address and equity of contract
    struct owner {

        address payable account;
        uint equity;
        uint amount;

    }
//Constructor for contract taking in file hash and the address of the registerer
    constructor(string memory file_hash, address payable registerer) public {

        timeStamp = now;
        fileHash = file_hash;
        owners.push(owner(registerer,1,0));
        sellingLicenses = false;

    }
//Function to purchase a distribution license contract at a cost
    function purchaseDistributionLicense() public payable returns(CommercialDistributionLicense) {

        require(sellingLicenses,"LICENSES_NOT_FOR_SALE");
        require(msg.value == licenseCost,"INCORRECT_PAYMENT");

        for(uint i = 0; i < owners.length; i++) {

            owners[i].amount += (msg.value * owners[i].equity);
        }

        CommercialDistributionLicense createdContract = new CommercialDistributionLicense(fileHash,msg.sender);
        licenseContracts.push(createdContract);
        return createdContract;

    }
//Function to create a distribution license contract only available to an owner
    function createDistributionLicense() public returns(CommercialDistributionLicense) {

        require(isOwner(msg.sender),"NOT_OWNER");

        CommercialDistributionLicense createdContract = new CommercialDistributionLicense(fileHash,msg.sender);
        licenseContracts.push(createdContract);
        return createdContract;

    }
//Function checks whether an account is an owner
    function isOwner(address payable _sender) public view returns(bool) {

        bool found = false;
        uint i = 0;
        while(!found) {
            if(owners[i].account==_sender){
                found = true;
            }
            i++;
        }
        return found;

    }

    function withdraw() public {
        require(isOwner(msg.sender),"NOT_OWNER");

        bool done = false;
        uint i = 0;
        while(!done) {
            if(owners[i].account == msg.sender){
                msg.sender.transfer(owners[i].amount);
            }
        }


    }

}