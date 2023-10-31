// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";

/*
- To make things a little bit more complicated, in storage, variables are "tightly packed". What does it mean? It means that if two (or more) consecutive variables can fit into a 32byte slot, they will share that slot.
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

    // With inline assembly, we can get the value of a storage slot. We will cover inline assembly at a later lecture.
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
    uint128 e = 1; // Slot 0, Byte 4-19 - remaining 12 bytes
    uint64 f = 1; // Slot 0, Byte 20-27 - remaining 4 bytes
    uint32 g = 1; // Slot 0, Byte 28-31 - remaining 0 bytes
    uint8 h = 1; // Slot 1, Byte 0 - remaining 31 bytes

    function slotNumbers() public view returns(uint256 slotA, uint256 slotB,
                                            uint256 slotC, uint256 slotD,
                                            uint256 slotE, uint256 slotF,
                                            uint256 slotG, uint256 slotH) {
        assembly {
            slotA := a.slot
            slotB := b.slot
            slotC := c.slot
            slotD := d.slot
            slotE := e.slot
            slotF := f.slot
            slotG := g.slot
            slotH := h.slot
        }
    }
    function slotOffsets() public view returns(uint256 offsetA, uint256 offsetB,
                                            uint256 offsetC, uint256 offsetD,
                                            uint256 offsetE, uint256 offsetF,
                                            uint256 offsetG, uint256 offsetH) {
        assembly {
            offsetA := a.offset
            offsetB := b.offset
            offsetC := c.offset
            offsetD := d.offset
            offsetE := e.offset
            offsetF := f.offset
            offsetG := g.offset
            offsetH := h.offset
        }
    }
}

/*
- Tight packing is a double-edged sword. We can say it is mainly beneficial because the compiler can optimize variable reads and writes so that you can access multiple variables with a single read or write command
- However, there are scenarios when it can backfire. If you only updating one part of a slot, leaving the rest unchanged, the compiler needs to do additional arithmetic logic to extract and to modify only that specific part of the storage.
- For example if you have a variable that is changed quite frequently and the adjescent ones are note, it might be better to reorder declarations and put the frequently changing variable into a 32byte type.
- In a later lecture I am going to explain more optimization techniques.
*/
