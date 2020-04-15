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

        bool found;
        uint index;
        (found,index) = isOwner(msg.sender);
        require(found,"NOT_OWNER");

        CommercialDistributionLicense createdContract = new CommercialDistributionLicense(fileHash,msg.sender);
        licenseContracts.push(createdContract);
        return createdContract;

    }
//Function checks whether an account is an owner and returns owner index
    function isOwner(address payable _sender) internal view returns(bool,uint) {

        bool found = false;
        uint i = 0;
        while(!found) {
            if(owners[i].account == _sender){
                found = true;
            }
            i++;
        }
        i--;
        return (found,i);

    }
//Function withdraws the corresponsing owners amount being held
    function withdraw() public {

        bool found;
        uint index;
        (found,index) = isOwner(msg.sender);
        require(found,"NOT_OWNER");
        require(owners[index].amount>0,"NO_FUNDS");
        msg.sender.transfer(owners[index].amount);
        owners[index].amount = 0;

    }
//Function returns the cost of a license
    function returnCost() public view returns(uint) {
        return licenseCost;
    }
//Function to purchase equity to an owner, this will make use of the Escrow contract.
    function purchaseEquity() public payable returns(EscrowContract) {
    }
//Function to return licenseContracts to owner
    function retrieveLicenses() public view returns(CommercialDistributionLicense[] memory) {
        bool found;
        uint index;
        (found,index) = isOwner(msg.sender);
        require(found,"NOT_OWNER");
        return licenseContracts;

    }
//Function to set license costs
    function setCost(uint cost) public {
        bool found;
        uint index;
        (found,index) = isOwner(msg.sender);
        require(found,"NOT_OWNER");
        licenseCost = cost;

    }
//Function to set license availability
    function setLicenseAvailability(bool a) public{
        bool found;
        uint index;
        (found,index) = isOwner(msg.sender);
        require(found, "NOT_OWNER");
        sellingLicenses = a;

    }

}