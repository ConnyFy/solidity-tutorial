// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract SimpleContract {
    function simpleTest() public payable returns (uint8) {
        console.log("simpleTest");
        return 1;
    }
}
contract ReceiveContract {
    receive() external payable {}

    function receiveTest() public payable returns (uint8) {
        console.log("receiveTest");
        return 2;
    }
}

contract AddressDemo {
    // constructor() payable {}

    function demo() public {
        // Contracts define their own type, lets define two contracts, one with a receive function and one without it.
        // We will cover the purpose of receive function later on, for now, in short,
        // it is a special function that runs when the contract receives ether. Moreover, it marks that contracts of this type can receive ether.
        // We can create a new contract with the `new` keyword.
        SimpleContract simpleContract = new SimpleContract(); // This one cannot receive eth
        ReceiveContract receiveContract = new ReceiveContract(); // This one can

        // You can call their public methods, Solidity provides type-safety.
        simpleContract.simpleTest();
        receiveContract.receiveTest();


        // address <- contract type
        // You can convert contract instances to address, and access the previously mentioned methods of an address.
        address simpleAddress = address(simpleContract);
        address receiveAddress = address(receiveContract);
        uint256 balance = receiveAddress.balance;

        // IMPORTANT: Even though `receiveContract` has a receive function, we still converted it to `address`, not `address payable`, so .transfer and .send does not exist
        // receiveAddress.transfer(10);

        // However, if the contract type has a receive or payable fallback function, we can explicitly convert it to and from `address payable`.
        address payable receiveAddressPayable = payable(receiveContract);
        receiveAddressPayable.transfer(10); // Now, we can call .transfer to send eth (if we have any)
        // address payable simpleAddressPayable = payable(simpleContract); // This is invalid, SimpleContract does not have a receive or a payable fallback function

        // IMPORTANT: As we have seen it earlier, converting address to address payable can be done with `payable(addr)`.
        // We can do this here too but this will bypass checks.
        address payable receiveAddressPayable2 = payable(receiveAddress); // This is perfectly valid
        address payable simpleAddressPayable2 = payable(simpleAddress); // This is also valid syntactically, however it will produce run-time error if we try to send Ether to it


        // contract type <- address
        // You will encounter converting addresses to a specific contract types fairly often when you use 3rd party contracts or oracles.
        // Usually, you import the interface of the contract, and look up the corresponding address of the deployed contract in the documentation.
        ReceiveContract receiveContract2 = ReceiveContract(receiveAddressPayable);
        // IMPORTANT: Nothing prevents to create a variable with an address of a different contract.
        SimpleContract simpleContract2 = SimpleContract(receiveAddressPayable);
        // simpleContract2.simpleTest(); // This would cause a run-time error
    }
}
