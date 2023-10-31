// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";

/*
- As mentioned, storage can be imagined as a key-value store that maps 256-bit keys to 256-bit (32-byte) value
- An element in this mapping (a 256-bit value) is called a slot.
*/

contract StorageLayout {
    /*
    - Variables with fixed sizes (e.g. value types, fixed sized arrays or structs that only contain these types) are allocated sequentially in the storage, starting with key 0.
    */
    
    uint256 a;
    uint256[2] b;

    struct Entry {
        uint256 id;
        uint256 value;
    }
    Entry c;
    /*
    In this code:
    a is stored at slot 0.
    b is stored at slots 1, and 2 (one for each element of the array).
    c starts at slot 3 and consumes two slots, because the Entry struct stores two 32-byte values.
    */

    // With inline assembly, we can get the value of a storage slot. (We will cover inline assembly at a later lecture.)
    function getStorageAt(uint idx) public view returns (uint r) {
        assembly {
            r := sload (idx)
        }   
    }
    
    function setFixedValues() public {
        a = 1;
        b = [5,6];
        c.id = 10;
        c.value = 11;
    }
}
