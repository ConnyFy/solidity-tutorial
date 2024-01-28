// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

import "hardhat/console.sol";

/*
In Solidity, null and undefined do not exist. It is not possible to declare or pass around these values.
When you declare a new variable inside a function (either regular variable or return variable), it is assigned to a default value.
Value types - that live in the Stack - by default assigned to their zero-ish value.
But what about reference type variables in Memory? We know that they are just references for an address in Memory, how can they have a default value?

In other languages - where you have a more direct access to pointers -, pointers are assigned to 0x00 by default.
In Soldiity, 0x00 is part of the reserved space, more specially, part of the Scratch space.
It cannot act as a default value for uint[3] memory, uint[] memory, string memory etc. at the same time.

To prevent invalid or dangling references, the EVM sets every Memory variable to point to an address that can authentically act as their default value.
For fixed sized memory variables (fixed size arrays, structs), the EVM allocates a new space in the Memory, the size of which is exactly the same as the the variable would use.
For variable sized memory variables (dynamic arrays, string, bytes), the EVM utilizes the Zero slot.
*/

/*
In Solidity, you can threat return variables as regular variables. By default, they have a default value assigned to them.
You can overwrite the values with usual variable assignments, and at the end of the function the current values are returned.
Of course, you can return earlier, using the `return` statement.
*/

contract MemoryDefaultValues {

    // First, let's cover fixed variables.
    function a_methodFixed() public view returns (
        uint[3] memory result,
        uint ptrVariable, uint ptrResult, uint FMP
    ) {
        uint[2] memory variable;

        assembly {
            ptrVariable := variable
            ptrResult := result
            FMP := mload(0x40)
        }
    }
    /*
        ptrVariable == 224 (0xE0)
        ptrResult == 128 (0x80)
        FMP == 288 (0x120)
        -------------------------
        What have happened here?

        There first 4 slots are reserved as usual.
        0x00 -> Scratch space
        0x20 -> Scratch space
        0x40 -> FMP
        0x60 -> Zero slot

        Then, the EVM handles the default values of return memory variables.
        Right now, we have one return memory variable, uint[3] memory result, which is a fixed size variable.
        Since it is a fixed size variable, the EVM allocates a space the variable would need.
        uint[3] requires 3 slots, so the EVM allocates the next 3 slots.

        0x00 -> Scratch space
        0x20 -> Scratch space
        0x40 -> FMP
        0x60 -> Zero slot
        0x80 -> 0   <- result points here
        0xA0 -> 0
        0xC0 -> 0

        Then, EVM allocates space for uint[2] memory variable. It is also a fixed size variable, that needs 2 slots.
        
        0x00 -> Scratch space
        0x20 -> Scratch space
        0x40 -> FMP
        0x60 -> Zero slot
        0x80 -> 0   <- result points here
        0xA0 -> 0
        0xC0 -> 0
        0xE0 -> 0   <- variable points here
        0x100 -> 0
        0x120       <- FMP

        And there it is. Both memory variables (result and variable) points to a space that can act as their default values.

        Note that, we haven't included memory parameters. The reason is that parameters are not allocated by the function itself.
        They come from somewhere "outside". It can come from another function or from transaction data.
        Anyway, the parameter cannot be declared uninitialized. A memory parameter will already point to the address where the passed data is.

        In case of structs, the exact same thing happenes. If the struct has a dynamic field, that field is handled like dynamic variables.
    */

    // So let's talk about dynamic variables.
    function b_methodDynamic() public view returns (
        uint[] memory result,
        uint ptrVariable, uint ptrResult, uint FMP
    ) {
        uint[] memory variable;

        assembly {
            ptrVariable := variable
            ptrResult := result
            FMP := mload(0x40)
        }
    }
    /*
        ptrVariable == 96 (0x60)
        ptrResult == 96 (0x60)
        FMP == 128 (0x80)
        -------------------------
        There first 4 slots are reserved again.
        0x00 -> Scratch space
        0x20 -> Scratch space
        0x40 -> FMP
        0x60 -> Zero slot

        Then, handle the result variable. Now, it has a dynamic size (uint[] memory result).
        
        What value could act as a default value for a dynamic array, for a string or for a bytes variable?
        These variables have no exact size, so let's say a zero-length area. But how can you create and point to a zero-length area?
        Remember back, that the first slot of these variables always store the length of the data, then comes the actual data.
        So a zero-length area is actually a single slot with zero inside.

        In case of dynamic variables, the EVM optimizes memory allocation. Instead of allocating these single slots with zeroes,
        it sets dynamic size memory variables to point to the Zero slot by default.
        Do you remember the definition of the Zero slot?
        According to the docs, it contains zeroes, should not be overwritten and is used as the initial value for empty dynamic memory arrays.

        So the EVM just sets result to point at 0x60 (the address of the Zero slot). The same thing happens with variable.

        0x00 -> Scratch space
        0x20 -> Scratch space
        0x40 -> FMP
        0x60 -> Zero slot   <- resut and variable point here
        0x80                <- FMP

        bytes and string variables are handled the exact same way.
    */

    /*
        When you create a variable and also initialize it, this mechanism is not triggered.
        E.g.
        uint[3] memory variable = [uint(1), 2, 3];
        uint[] memory variable = new uint[](3);
        string memory variable = "apple pie";
        
        First, the EVM allocates space for the data on the right side, then sets the pointer there.
    */
}
