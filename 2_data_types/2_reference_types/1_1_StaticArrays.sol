// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract ArrayDemo {
    // There are two types of arrays: Static or fixed sized, and dynamic sized
    uint8[5] staticArray;
    uint8[] dynamicArray;

    
    function demo() public {
        // Static sized arrays
        // They are simpler, you define the size of the array in its type.
        uint8[5] memory array; // Initialized with the default value of the base type
        uint8[5] memory array2 = [0,1,2,3,4];
        // The type of the array literal is the type of the first element.
        // uint256[5] memory array3 = [0,1,2,3,4]; // Error, the type of the right side is uint8[5]
        // Unfortunatelly, while uint8 is convertible to uint256, uint8[5] is not compatible with uint256[5]
        uint256[5] memory array3 = [uint256(0),1,2,3,4]; // We change the type of the right side to uint256[5]

        // Changing value, getting length
        array2[0] = 99;
        uint256 length = array2.length; // 5

        // We cannot extend the array as its size is fixed
        // array2.push(5);
        // array2[5] = 5;

        // array2[-1] = 5; // Cannot use Python-like negative indexing
        uint8 lastElement = array2[length-1]; // 4

        // Static arrays in storage act the same way
        staticArray[0] = 100;
        uint256 storageLength = staticArray.length;
    }
}
