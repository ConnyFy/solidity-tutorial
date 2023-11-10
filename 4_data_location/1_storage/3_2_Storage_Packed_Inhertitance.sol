// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract BaseContract {
    uint8 a = 3;
    uint8 b = 5;
}

contract ParentContract is BaseContract {
    uint8 c = 9;
    uint8 d = 17;
}

contract StoragePackedInheritance is ParentContract {

    function getStorageAt(uint idx) public view returns (uint r) {
        assembly {
            r := sload (idx)
        }   
    }
    // a: Slot 0, Byte 0 - remaining 31 bytes
    // b: Slot 0, Byte 1 - remaining 30 bytes
    // c: Slot 0, Byte 2 - remaining 29 bytes
    // d: Slot 0, Byte 3 - remaining 28 bytes
    uint128 e = 1; // Slot 0, Byte 4-19 (16 total) - remaining 12 bytes
    uint64 f = 1; // Slot 0, Byte 20-27 (8 total) - remaining 4 bytes
    uint32 g = 1; // Slot 0, Byte 28-31 (4 total) - remaining 0 bytes
    uint8 h = 1; // Slot 1, Byte 0 - remaining 31 bytes

    function slotParameters() public {
        uint256[8] memory slotNumbers;
        uint256[8] memory offsets;

        assembly {
            mstore(add(slotNumbers, 0), a.slot)
            mstore(add(slotNumbers, 0x20), b.slot)
            mstore(add(slotNumbers, 0x40), c.slot)
            mstore(add(slotNumbers, 0x60), d.slot)
            mstore(add(slotNumbers, 0x80), e.slot)
            mstore(add(slotNumbers, 0xA0), f.slot)
            mstore(add(slotNumbers, 0xC0), g.slot)
            mstore(add(slotNumbers, 0xE0), h.slot)
            
            mstore(add(offsets, 0), a.offset)
            mstore(add(offsets, 0x20), b.offset)
            mstore(add(offsets, 0x40), c.offset)
            mstore(add(offsets, 0x60), d.offset)
            mstore(add(offsets, 0x80), e.offset)
            mstore(add(offsets, 0xA0), f.offset)
            mstore(add(offsets, 0xC0), g.offset)
            mstore(add(offsets, 0xE0), h.offset)
        }
        console.log("variable a - slot:", slotNumbers[0], "offset:", offsets[0]);
        console.log("variable b - slot:", slotNumbers[1], "offset:", offsets[1]);
        console.log("variable c - slot:", slotNumbers[2], "offset:", offsets[2]);
        console.log("variable d - slot:", slotNumbers[3], "offset:", offsets[3]);
        console.log("variable e - slot:", slotNumbers[4], "offset:", offsets[4]);
        console.log("variable f - slot:", slotNumbers[5], "offset:", offsets[5]);
        console.log("variable g - slot:", slotNumbers[6], "offset:", offsets[6]);
        console.log("variable h - slot:", slotNumbers[7], "offset:", offsets[7]);
    }
}
