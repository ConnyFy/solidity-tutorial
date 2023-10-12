// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract AddressDemo {

    function demo() public {
        // 20 bytes, needs to pass checksum
        address alice = 0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF;
        // address wrongAddress = 0x11113a6d3569DF655070DEd06cb7A1b2Ccd1D3AF; // Does not pass checksum

        // address payable exists to distinguish accounts where you supposed to and not supposed to send Ether.
        address payable alicePayable = payable(0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF);
        
        // address <- address payable: implicitly convertible
        address alice2 = alicePayable;
        // address payable <- address: needs explicit conversion
        address payable alicePayble2 = payable(alice);

        // Since 0.6, you also need explicit conversion to bytes20 and uint160
        // bytes20 bytes_var = 0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF;
        bytes20 bytesAddress = bytes20(0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF);
        // uint160 int_var = 0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF;
        uint160 uintAddress = uint160(0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF);


        // Operators
        // ==, != works the same way as at ingeres and bytes
        // <, <=, >=, > also exist but they are not really used


        // Members
        // Get balance
        uint256 aliceBalance = alice.balance;
        uint256 alicePayableBalance = alicePayable.balance;

        // Send ether, amount is in wei
        // 1 gwei = 10^9 wei
        // 1 ether = 10^9 gwei = 10^18 wei
        // alice.transfer(10); // Invalid as `alice` is not payable
        alicePayable.transfer(10);
        bool sendSuccessful = alicePayable.send(10);
        // The difference between transfer and send is transfer reverts on errors, send just returns `false`
        // There is also a 3rd way of sending eth, we will see it soon
    }
}
