// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";

// For PUBLIC state variables, solidity implicitly generates getter functions

contract GettersDemo {
    uint public uintVar;

    // Identifier already declared
    // function uintVar() view external returns (uint) {
    //     return uintVar;
    // }
    // For value types, this kind of functions are generated.

    
    // For arrays (both for static-sized and dynamic-sized):
    bool[] public arrayVar;
    // function arrayVar(uint index) view external returns (bool) {
    //     return arrayVar[index];
    // }

    bool[][] public arrayMultiVar;
    // function arrayMultiVar(uint index0, uint index1) view external returns (bool) {
    //     return arrayMultiVar[index0][index1];
    // }

    // For bytes and strings:
    bytes public bytesVar;
    // function bytesVar() view external returns (bytes memory) {
    //     return bytesVar;
    // }

    // For mappings:
    mapping(uint8 => bool) public mappingVar;
    // function mappingVar(uint8 key) view external returns (bool) {
    //     return mappingVar[key];
    // }

    mapping(address => mapping(bool => uint)) public nestedMappingVar;
    // function nestedMappingVar(address key0, bool key1) view external returns (uint256) {
    //     return nestedMappingVar[key0][key1];
    // }
    
    struct Person {
        uint16 height;
        uint16 weight;
        address account;
        uint[] favoriteNumbers;
        uint[2] neighbourHouseNumbers;
        mapping(address => uint) moneyOwed;
        bytes secret;
    }
    Person public structVar;
    // function structVar() view external returns (uint16, uint16, address, bytes memory) {
    //     return (structVar.height, structVar.weight, structVar.account, structVar.secret);
    // }
    /*
        Mappings and arrays (with the exception of byte arrays) in a struct are omitted because there is no good way to select individual struct members or provide a key for the mapping
    */
    
    mapping(uint64 => mapping(bool => Person[])) public mixedVar;
    // function mixedVar(uint64 index0, bool index1, uint256 index2) view external returns (uint16,uint16,address) {
    //     Person storage data = mixedVar[index0][index1][index2];
    //     return (data.height, data.weight, data.account);
    // }
    
}

contract OtherContract {
    function demo() public {
        GettersDemo gettersDemo = new GettersDemo();
        gettersDemo.uintVar;
        gettersDemo.uintVar(); // Automatically generated getter
        // gettersDemo.uintVar = 1; // Can read, but cannot assign
        // gettersDemo.uintVar(1); // Not even as function call, mismatching parameter number
    }
}

contract DerivedContract is GettersDemo {
    function demo() public {
        uintVar;
        // uintVar(); // Getter functions has 'external' visibility, they cannot be called internally
        uintVar = 1;

        // this.uintVar; // this.uintVar is a function reference, not the value itself (the real value is shadowed by the getter function)
        this.uintVar();
        // this.uintVar = 2; // It is still just a getter, not a setter
        // thus.uintVar(2);

        // this.arrayVar[0];
        this.arrayVar(0);
    }
}
