// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract ScopingDemo {

    function demo() public {
        // Scoping

        // {} creates a new block. We can imagine the structore of our code as a tree of blocks, where at the top we have the global variables, then contract-level (or state) variables, then function-level (or local) variables, then local variables inside a block etc.
        // Variables declared in a block are only visible inside that block and its child blocks, but not from its parent blocks.
        // The reason is, variable declarations are invalidated once the compiler steps out of the block the variable was declared in.

        uint outerVariable = 10;
        {
            outerVariable = 20; // It is visible inside
            uint innerVariable = 20;
        }
        outerVariable = 30;
        // innerVariable = 30; // Undeclared identifier, innerVariable got invalidated

        // Scoping allows us to declare variables with the same name, even if the types are different
        {
            uint64 innerVariable = 40;
        }
        {
            bool innerVariable = true;
        }
    }

    function demo2() public {
        // Why am I teaching such a trivial thing?
        // A little background: The EVM is a stack machine. It means, it operates on a stack not on registers.
        // If you check the bytecode of a contract you will see intructions like these:
        // DUP1, DUP2, ..., DUP16, SWAP1, SWAP2, ..., SWAP16
        // First of all, the EVM has a stack limit of 1024. Not too small but not too big, it should be enough if you write your program correctly.
        // Second, as you can see from the instructions above, EVM can only reach the top 16 elements of the stack. If you want to reach something below, you need to discard values from the top of the stack.
        // This eventually means, that you can use the last 16 local variables (not including reference variables that live in the memory).
        // Here's a little example:

        uint variable1;
        uint variable2;
        uint variable3;
        uint variable4;
        uint variable5;
        uint variable6;
        uint variable7;
        uint variable8;
        uint variable9;
        uint variable10;
        uint variable11;
        uint variable12;
        uint variable13;
        uint variable14;
        uint variable15;
        // uint variable16;
        // Stack too deep. result would be our 17th variable on the stack, meaning we cannot access outerVariable anymore.
        // After removing one variable declaration, we can reach variable1
        uint result = variable1;
    }

    function addNumbers(
        uint a,
        uint b,
        uint c,
        uint d,
        uint e,
        uint f,
        uint g,
        uint h
    ) public returns(uint) {
        // return a + b + c + d + e + f + g + h + h; // Operands are copied to the top of the stack

        return a + b + c + d + e + f + g + h;
    }

    // How to solve "Stack too deep" error?

    // 1. Use less variables
    /*
        It sounds trivial but you can try to minimize the amount of variables you use if it is possible
        uint a = 10;
        uint b = a * 2;
        uint c = b + 30;
        uint d = c * 3;
        ---
        uint d = (10 * 2 + 30) * 3;
    */

    // 2. Utilize blocks
    function addNumbers2(
        uint a,
        uint b,
        uint c,
        uint d,
        uint e,
        uint f,
        uint g,
        uint h
    ) public returns(uint result) {
        // return a + b + c + d + e + f + g + h + h;

        result = 0;
        {
            result = a + b + c + d + e;
        }
        {
            result = result + f + g + h + h;
        }
    }

    // 3. Internal functions
    function addNumbers3(
        uint a,
        uint b,
        uint c,
        uint d,
        uint e,
        uint f,
        uint g,
        uint h
    ) public returns(uint) {
        // return a + b + c + d + e + f + g + h + h;

        return _addThreeNumbers(a, b, c) + _addThreeNumbers(d, e, f) + _addThreeNumbers(g, h, h);
    }
    function _addThreeNumbers(uint x, uint y, uint z) private returns(uint) {
        return x + y + z;
    }

    // 4. Pass structs
    struct Data {
        uint a;
        uint b;
        uint c;
        uint d;
        uint e;
        uint f;
        uint g;
        uint h;
    }
    function addNumbers4(
        Data memory data
    ) public returns(uint) {
        // return a + b + c + d + e + f + g + h + h;

        return data.a + data.b + data.c + data.d + data.e + data.f + data.g + data.h + data.h;
    }

    // 5. Optimize code
    function addNumbers5(
        uint a,
        uint b,
        uint c,
        uint d,
        uint e,
        uint f,
        uint g,
        uint h
    ) public returns(uint) {
        // return a + b + c + d + e + f + g + h + h;

        return h + h + g + f + e + d + c + b + a;
    }
}