// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract GettersDemo {
    uint public x_public;

    // Identifier already declared
    // function x_public() view external returns (uint) {
    //     return x_public;
    // }

    
    // For arrays (both for static-sized and dynamic-sized):
    bool[] public x_array;
    // function x_array(uint index) view external returns (bool) {
    //     return x_array[index];
    // }
    bool[][] public x_array2;
    // function x_array2(uint index0, uint index1) view external returns (bool) {
    //     return x_array2[index0][index1];
    // }

    // For bytes and strings:
    bytes public x_bytes;
    // function x_bytes() view external returns (bytes memory) {
    //     return x_bytes;
    // }

    // For mappings:
    mapping(uint8 => bool) public x_mapping;
    // function x_mapping(uint8 key) view external returns (bool) {
    //     return x_mapping[key];
    // }
    mapping(address => mapping(bool => uint)) public x_mapping2;
    // function x_mapping2(address key0, bool key1) view external returns (uint256) {
    //     return x_mapping2[key0][key1];
    // }
    
    struct Person {
        uint16 height;
        uint16 weight;
        address account;
        uint[] favoriteNumbers;
        uint[2] neighbourHouseNumbers;
        mapping(address => uint) moneyOwed;
    }
    Person public x_struct;
    // function x_struct() view external returns (uint16,uint16,address) {
    //     return (x_struct.height, x_struct.weight, x_struct.account);
    // }
    
    mapping(uint64 => mapping(bool => Person[])) public x_nested;
    // function x_nested(uint64 index0, bool index1, uint256 index2) view external returns (uint16,uint16,address) {
    //     Person storage data = x_nested[index0][index1][index2];
    //     return (data.height, data.weight, data.account);
    // }
    
}

contract OtherContract {
    function demo() public {
        GettersDemo gettersDemo = new GettersDemo();
        gettersDemo.x_public;
        gettersDemo.x_public(); // Automatically generated getter
        // gettersDemo.x_public = 1; // Can read, but cannot assign
        //gettersDemo.x_public(1); // Not even as function call, mismatching parameter number
    }
}

contract DerivedContract is GettersDemo {
    function demo() public {
        x_public;
        // x_public();
        x_public = 1;

        this.x_public;
        this.x_public();
        // this.x_public = 2;
    }
}