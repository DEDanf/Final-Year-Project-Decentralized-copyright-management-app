pragma solidity >=0.4.22 <0.7.0;

contract EscrowContract {

    address sender;
    address receiver;
    uint amountDeposited;

    constructor(address _sender, address _receiver) public {

        sender = _sender;
        receiver = _receiver;
        amountDeposited = 0;

    }

    event depositMade(uint amount, uint timeStamp);

    function deposit() public payable {

        require(msg.sender == sender,"NOT_INTENDED_SENDER");
        amountDeposited += msg.value;
        emit depositMade(amountDeposited,now);

    }

    function withdraw(bytes32 h, bytes32 r, bytes32 s, uint v, uint value) public{

        require(msg.sender == receiver);

        //this will contain the logic to check whether the channel is digitally signed,
        //h is the hash, rsv are the signed of the hash and value is the amount to retrive.
        //Now we take value and we hash it with keccak256 along with the contract address
        //Next we plug that into ecrecover with the rsv and if the addr correspons with sender
        //then we withdraw that value to receiver





    }

}