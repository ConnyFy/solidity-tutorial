// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


        // 
contract FixedDemo {
    function demo() public {
        // We have seen there are fractional number literals. Can we do these assignments and expect them to be truncated?
        // uint a = 1.5;
        // uint b = 6 / 4;

        // Unfortunately, fractional number variables are not implemented yet

       /*
            They plan to have the following syntax:
            fixedMxN, ufixedMxN, where M is 8, 16, ..., 256; and N is 0, 1, ..., 80
            M is the number of buts, N is the number of decimals
            fixed16x2 fixedVariable;
            fixed is an alias for fixed128x18
            ufixed is an alias for ufixed128x18
            Same comparison operators as at integers: <, <=, ==, !=, >=, >
            Same arithmetic operators, except, there is no power operator
        */

        // Then, how can we represent fractional numbers?
        // As of now, we can use integers and for each of them track their number of decimal places

        uint256 price = 25 * 10**18; // NOTE: 18 decimal places, so 25.000000000000000000
        uint256 amount = 4 * 10**10; // NOTE: 10 decimal places, so 4.0000000000
        
        uint256 totalAmount = price * amount; // NOTE: 28 decimal places.
        totalAmount = totalAmount / 10**10; // NOTE: 18 decimal places
    }
}
