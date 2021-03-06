pragma solidity >=0.4.22 <0.7.0;
import "./RegisteredCopyright.sol";

contract RegistrationHandler {

    address payable manager;
    uint registrationCost;
    uint amount;
    registeredCopyright[] copyrightDB;

//Constructor takes in registration cost and makes the sender the owner
    constructor(uint _registration_cost) public {

        manager = msg.sender;
        amount = 0;
        registrationCost = _registration_cost;

    }
//Data structure to store a Registered Copyright and associated contract
    struct registeredCopyright {

        string fileHash;
        address contractOwner;
        RegisteredCopyright copyrightContract;

    }
//Function to register a copyright
    function registerCopyright(string memory _file_hash) public payable returns(RegisteredCopyright){

        require(msg.value == registrationCost, "WRONG_PAYMENT");

        bool found;
        uint i = 0;
        while(!found){
            if(compareStrings(copyrightDB[i].fileHash,_file_hash)){
                found = true;
            }
        }
        require(!found,"FILE_HASH_DUPLICATE");

        amount += msg.value;

        RegisteredCopyright createdContract = new RegisteredCopyright(_file_hash, msg.sender);
        copyrightDB.push(registeredCopyright(_file_hash, msg.sender, createdContract));
        return createdContract;

    }
//Function to search copyrightDB with fileHash returning associated contract
    function searchFileHash(string memory _file_hash) public view returns(RegisteredCopyright) {

        bool found = false;
        uint i = 0;
        while(!found) {

            if(compareStrings(_file_hash,copyrightDB[i].fileHash)) {
                found = true;
            }
            i++;
        }
        require(found,"FILE_NOT_FOUND");
        i--;
        return copyrightDB[i].copyrightContract;
    }
//Internal function to compare 2 strings and return a bool if they are the same
    function compareStrings (string memory a, string memory b) internal pure returns (bool) {
            return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))) );
       }

//Function to withdraw funds
    function withdraw() public{
        require(msg.sender == manager, "NOT_OWNER");
        manager.transfer(amount);
    }
//Function to return cost of registration
    function returnCost() public view returns(uint) {
        return registrationCost;

    }

}