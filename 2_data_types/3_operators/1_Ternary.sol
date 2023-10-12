// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract OperatorsDemo {

    function demo() public {
        // Ternary
        // guardExpression ? trueExpression : falseExpression

        bool guard = true;
        uint8 height = guard ? 180 : 150;

        // type of trueExpression and falseExpression need to match 
        // uint8 favoriteThing = guard ? 42 : "red";
        // uint8 favoriteNumber = guard ? 256 : 1;
    }
}
