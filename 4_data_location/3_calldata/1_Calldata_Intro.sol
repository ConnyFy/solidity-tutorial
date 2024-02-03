// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

import "hardhat/console.sol";

/*
- Calldata is a special data location where function parameters live.
- It is very similar to Memory, many people confuse them.

- Unlike Memory, it is a read-only area. it means you cannot declare or assign to calldata variables.

- Accessing calldata variables is even cheaper than Memory variables.

- Calldata can also be represented by a big array or more precisely by an immutable bytes variable.
- Just like in case of Memory, data is not tight-packed (apart from bytes and string), everything occupies a full 32-byte space.
- However, there is a slight change in the boundaries of slots. The first 4 bytes are special in calldata, function parameters come after that.
- Pointers also work differently. The value of a calldata pointer depends on if it is on the stack (we declared) or in calldata (a calldata slot that points to another slot).

- It is not located in the EVM memory nor on the blockchain. It is actually a static part of the transaction's data.
*/

contract CalldataIntroduction {
    struct Person {
        uint256 age;
    }

    function a_demo(
        uint256 one, // For value types, you cannot set calldata as data location
        bool[2] calldata answers,
        uint[] calldata numbers,
        bytes calldata secret,
        string calldata keyword,
        Person calldata person
        // mapping(address => uint256) memory owe // Just in case of Memory, you cannot have mappings
    ) public {
        console.log("answers:", answers[0], answers[1]);
        console.log("numbers last element:", numbers[numbers.length-1]);
        console.log("keyword:", keyword);
        console.log("person.age:", person.age);
    }

    /*
    Pointers/References
    - Technically, Calldata pointers work the same way as Memory pointers, but since Calldata is immutable, you cannot really do much with pointers.
    */
    
    function b_pointerDemo(
        uint[] calldata numbers,
        bytes calldata secret,
        string calldata keyword
    ) public {
        // uint[3] calldata numbers2 = [1,2,3]; // You cannot create new values
        // numbers[0] = 1; // You cannot modify values
        // delete numbers; // You cannot delete values
        uint[] calldata numbers2 = numbers; // All you can do is to create pointers to other calldata variables (parameters)

        // It was mentioned earlier, there is an extra feature for calldata dynamic reference types.
        // You can create slices from them, extracting only a certain interval of the original data.
        uint[] calldata numbers3 = numbers2[0:3];
        bytes calldata secret2 = secret[0:3];
        string calldata keyword2 = keyword[0:3];
        
        console.log("numbers3 last element:", numbers3[numbers3.length-1]);
        console.log("keyword2:", keyword2);

        // Be careful, however. If you try to get a slice that is out of bounds, the transaction will fail.
    }

    /*
    Return value:
    - Return variables of reference types are usually have memory data location.
    - You can define calldata return variables too, but in that case, you are limited to return something that is already part of the calldata.
    - You need to assign a value to return variables, cannot left them uninitialized. Unlike Memory return variables, no default value is provided for Calldata return variables.
    */

    // function c_returnDemo(uint[] calldata calldataNumbers) public view returns (uint[] calldata slice) {
        // This variable is of calldata pointer type and can be returned without prior assignment, which would lead to undefined behaviour.
    // }

    function c_returnDemo(uint[] calldata calldataNumbers) public view returns (uint[] calldata slice) {
        uint[] memory memoryNumbers = new uint[](3);
        memoryNumbers[0] = 1;
        memoryNumbers[1] = 2;
        memoryNumbers[2] = 3;

        // slice = memoryNumbers[0:2]; // Two problems: 1) Slice is only supported for dynamic calldata arrays, 2) It wants to assign data located in Memory to a Calldata variable.
        slice = calldataNumbers[0:2];
    }
}
