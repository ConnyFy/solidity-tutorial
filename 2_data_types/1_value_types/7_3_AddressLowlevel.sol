// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";

contract SimpleContract {
    function simpleTest() public payable returns (uint8) {
        return 1;
    }
}
contract ReceiveContract {
    receive() external payable {}

    function receiveTest() public payable returns (uint8) {
        return 2;
    }
}

contract AddressDemo {
    constructor() payable {}
    
    function demo() public {
        SimpleContract simpleContract = new SimpleContract();
        ReceiveContract receiveContract = new ReceiveContract();

        address simpleAddress = address(simpleContract);
        address receivableAddress = address(receiveContract);

        // Low-level functions: call, delegatecall, staticcall
        // The purpose of these functions is to call a function of a contract at a given address
        // We will cover the difference between these three, but to properly understand it,
        // we need to cover the fundamentals of storage layout.
        uint8 result1 = simpleContract.simpleTest();
        console.log("result1:", result1); // Outputs: 1
        
        // We can call any function, but pay attantion, because this bypass type-safety.
        // We could write anything instead of simpleTest() even if it does not exist in the contract at `simpleAddress`.
        (bool callSuccess, bytes memory returnBytes) = simpleAddress.call(abi.encodeWithSignature("simpleTest()")); 
        uint8 result2 = abi.decode(returnBytes, (uint8));
        console.log("result2:", result2); // Outputs: 1

        // The 3rd way of sending ether
        // We will talk about gas later on the course, for now you can simply consider it as the "fuel" for smart contract computation.
        // More gas means the transaction can execute more complex tasks.
        console.log("Old balance:", receivableAddress.balance); // Outputs: 0
        (bool transferSuccess, bytes memory returnBytesTransfer) = receivableAddress.call{value: 10, gas: 2300}("");
        console.log("New balance:", receivableAddress.balance); // Outputs: 10

        // A quick comparison between .send, .transfer and .call
        /*
                    Purpose                 What happens on error       Forwarded gas
        ------------------------------------------------------------------------------------
        .transfer:  Send ETH                Reverts with error          2300
        ------------------------------------------------------------------------------------
        .send:      Send ETH                Returns false               2300
        ------------------------------------------------------------------------------------
        .call:      Call any function,      Returns false               Can be set
                    receive() is called
                    if calldata is empty
        */ 
    }
}
