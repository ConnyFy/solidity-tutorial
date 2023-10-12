// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";

/*
At first, let's cover value types.
Value type variables are those classic variables that copy on assignment.
You can say for example
int variable1 = 1;
int variable2 = variable1;
variable2 += 1;
And in the end, variable2 becomes 2, while variable 1 stays at one. This is because assignment copies the value to the variable on the left.

On the contrary, reference types are not copied, but are set to refer to the same space in memory.
For example:
uint8[3] memory array = [0,1,2];
uint8[3] memory array2 = array;
array2[0] = 4;
In the end, both array2[0] and array[0] will be equal to 4, since at the assignment, array is not copied but we just set array2 to point to the same memory space where array points to.
*/

contract BoolDemo {
    function demo() public {
        bool variable; // default value is false
        bool variableFalse = false;
        bool variableTrue = true;

        // Operators
        bool negate = !variableFalse; // true
        bool logicalAnd = variableFalse && variableTrue; // false
        bool logicalOr = variableFalse || variableTrue; // true

        bool equal = variableFalse == variableTrue; // false
        bool equal2 = variableTrue == variableTrue; // true
        bool notEqual = variableFalse != variableTrue; // true

        // Logical operators apply short-circuit rules,
        // so if the value of the operator is already determined
        // by the first operand, the second won't be evaluated.
        // falseFunction() returns false, trueFunction() returns true
        bool andCircuit1 = falseFunction() && trueFunction(); // Only falseFunction is evaluated
        bool andCircuit2 = trueFunction() && falseFunction(); // Both of them are evaluated
        
        bool orCircuit1 = falseFunction() || trueFunction(); // Both of them are evaluated
        bool orCircuit2 = trueFunction() || falseFunction(); // Only trueFunction is evaluated
    }

    function falseFunction() public returns (bool) {
        console.log("falseFunction called");
        return false;
    }

    function trueFunction() public returns (bool) {
        console.log("trueFunction called");
        return true;
    }
}
