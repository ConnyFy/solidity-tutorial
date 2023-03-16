// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract ArrayDemo {
    uint8[5] static_storage = [0,1,2,3,4];

    function static_array_demo() public {
        // Two types: static sized, and dynamic sized
        uint8[5] memory static_size;
        uint8[] memory dynamic_size;

        // Static sized
        // Initialization
        uint8[5] memory array = [0,1,2,3,4];
        // uint256[5] memory array2 = [0,1,2,3,4]; // Error, the base type of the array literal is the type of the first element
        uint256[5] memory array2 = [uint256(0),1,2,3,4];

        // Changing value
        array[0] = 99;
        uint256 length = array.length; // 5
        // array[5] = 5; // We cant extend the array as it is static sized
        // array.push(5);
        // array[-1] = 5; // Cannot use Python-like negative indexing
        uint8 last_element = array[length-1]; // 4

        // Static arrays can also live in storage
        static_storage[0] = 100;

        // NOTE: This does not actualy an array but a pointer to a uint[5] variable stored in storage.
        uint8[5] storage static_storage_pointer;
        // static_storage_pointer = [0,1,2,3,4];
        // static_storage_pointer = array;
        static_storage_pointer = static_storage;
    }


    uint8[] dynamic_storage;

    function dynamic_array_demo() public {
        // uint8[] memory array = [0,1,2,3,4]; // Error, cannot initialize dynamic arrays with literals
        uint8[] memory array = new uint8[](5);
        array[0] = 0;
        array[1] = 1;
        array[2] = 2;
        array[3] = 3;
        array[4] = 4;
        uint256 length = array.length; // 5

        // array.push(5); // Not possible for dynamic arrays in memory.
        // array[5] = 5; // IMPORTANT: This causes a runtime-error!!!
        // array[-1] = 5; // Cannot use Python-like negative indexing
        uint8 last_element = array[length-1]; // 4
        // Technically memory "dynamic" arrays are just dynamically allocated static sized arrays
        // The difference is that I can create an array with arbitrary length not just that was defined by the type. 
        // Real dynamic arrays live in storage

        console.log(dynamic_storage.length); // Outputs 0
        dynamic_storage.push();
        console.log(dynamic_storage.length); // Outputs 1
        dynamic_storage.push(1);
        console.log(dynamic_storage.length); // Outputs 2
        dynamic_storage.pop();
        console.log(dynamic_storage.length); // Outputs 1

        // push() returns a reference
        dynamic_storage.push() = 10;
        (dynamic_storage.push(), dynamic_storage.push()) = dynamic_fc();
        // Be careful! If the variable exceeds 32 bytes it can change from short-layout to long-layout
        console.log(dynamic_storage.length); // Outputs 4

    }
    function dynamic_fc() private pure returns (uint8, uint8) {
        return (1, 2);
    }

    
    function calldata_array_demo(uint8[] calldata param) public view {
        // As of now, array slices only works on calldata arrays. This is planned to change in the future.
        uint8[] memory slice = param[0:3];
        console.log(param.length);
        console.log(slice.length);
    }
}
