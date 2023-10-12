// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract OperatorsDemo {

    function demo() public {
        // Operator assignment shorthand
        // Imagine the following, you have a variable, and you want to do an operation where one of the operand is the variable.
        // For example
        uint x = 1;
        x = x + 1;

        // You can shorten this with this rule:
        // x = x OP y -> x OP= y
        // x is variable, y is variable or literal
        // OP can be
        // Arithmetic: +, -, *, /, %
        // Bitwise: &, |, ^
        // Shift: <<, >>
        // No shorthand for power operator (no **=)
        x += 1;
        
        // Increment, decrement
        // If you want to increment or decrement by 1, you can shorten the expression even further:
        // x += 1 -> x++ or ++x
        // x -= 1 -> x-- or --x
        x++;
        ++x;

        // What's the difference between ++x and x++ (or --x and x--)
        // As stand-alone expressions, nothing. They both increase or decrease the variable value by 1.
        x = 1;
        x++; // a==2
        ++x; // a==3

        // On the other hand, if the expression is part of an assignment (variable assignment, function call, return from a function etc.):
        // Pre-increment
        uint a = 1;
        uint b = ++a;
        // 1. increment a: a==2
        // 2. assign a to b: b==2
        // In the end, both a and b will be equal to 2.

        // Post-increment
        uint c = 1;
        uint d = c++;
        // 1. assign c to d: d==1
        // 2. increment c: c==2
        // In the end, d will be equal to c's old value (1), c will be equal to 2.
    }
}
