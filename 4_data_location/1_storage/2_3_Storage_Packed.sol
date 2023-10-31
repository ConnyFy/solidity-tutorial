// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";

/*
- To make things a little bit more complicated, in storage, variables are "tightly packed". What does it mean? It means that if two (or more) consecutive variables can fit into a 32-byte slot, they will share that slot.
- There are some rules regarding tight packing:
    - Items are stored right-aligned. That means the first variable will occupy the lower bytes - as many as it requires -, it is followed by the next variable and so on.
    - If a variable does not fit fully in the remaining part of a slot, it is stored in the next slot.
    - Sturcts and arrays (static sized) always start a new slot, their items are packed tightly, and the next variable after them also starts a new slot.
*/

contract StoragePacked {
    uint8 a = 3;
    uint8 b = 5;
    uint8 c = 9;
    uint8 d = 17;

    function getStorageAt(uint idx) public view returns (uint r) {
        assembly {
            r := sload (idx)
        }   
    }
    // https://www.rapidtables.com/convert/number/decimal-to-binary.html
    // 285803779 -> 00010001 00001001 00000101 00000011 -> 17 9 5 3
    // That is just 32 bits, the remaining 224 bits (28 bytes) are empty

    // a: Slot 0, Byte 0 - remaining 31 bytes
    // b: Slot 0, Byte 1 - remaining 30 bytes
    // c: Slot 0, Byte 2 - remaining 29 bytes
    // d: Slot 0, Byte 3 - remaining 28 bytes
    uint128 e = 1; // Slot 0, Byte 4-19 (16 total) - remaining 12 bytes
    uint64 f = 1; // Slot 0, Byte 20-27 (8 total) - remaining 4 bytes
    uint32 g = 1; // Slot 0, Byte 28-31 (4 total) - remaining 0 bytes
    uint8 h = 1; // Slot 1, Byte 0 - remaining 31 bytes

    // With inline assembly we can check a storage variable's slot number and its offset within the slot.
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

/*
- Tight packing is a double-edged sword. We can say it is mainly beneficial because the compiler can optimize variable reads and writes so that you can access multiple variables with a single read or write command
- However, there are scenarios when it can backfire. If you only updating one part of a slot, leaving the rest unchanged, the compiler needs to do additional arithmetic logic to extract and to modify only that specific part of the storage.
- For example if you have a variable that is changed quite frequently and the adjescent ones are not, it might be better to reorder declarations and put the frequently changing variable into a separate 32-byte type.
- In a later lecture, I am going to explain more optimization techniques.
*/
