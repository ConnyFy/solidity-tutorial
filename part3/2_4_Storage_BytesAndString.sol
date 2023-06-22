// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";

/*
- The last thing we need to talk about is bytes and string.
- They can take up two formats: short-format and long-format.
    - If the data is at most 31 bytes long, the elements are stored in the higher-order bytes (left aligned) and the lowest-order byte stores the value length * 2.
    - If the stored data is 32 or more bytes long, the main slot p stores length * 2 + 1 and the data is stored as usual in keccak256(p).
- This means that you can distinguish a short array from a long array by checking if the lowest bit is set: short (not set) and long (set).
*/

// TODO: Improve the visualization
// TODO: Try not to find a way to convert integers to binary

contract StorageBytesAndString {
    string value = "";

    function getStorageValue(uint256 slotIndex) public {
        uint256 dynIndex = uint256(keccak256(abi.encodePacked(slotIndex)));
        uint256 slot;
        uint256 dynSlot;
        assembly {
            slot := sload (slotIndex)
            dynSlot := sload (dynIndex)
        }
        console.log(slot);
        console.log(dynSlot);
    }

    function setValue(string memory newValue) public {
        value = newValue;
        getStorageValue(0);
        /*
        "a"
            slot: 0x6100000000000000000000000000000000000000000000000000000000000002
            dynSlot: 0
        "aaaaa"
            slot: 0x616161616100000000000000000000000000000000000000000000000000000A
            dynSlot: 0
        28 "a"s
            slot: 0x6161616161616161616161616161616161616161616161616161616100000038
            dynSlot: 0
        30 "a"s
            slot: 0x616161616161616161616161616161616161616161616161616161616161003C
            dynSlot: 0
        31 "a"s
            slot: 0x616161616161616161616161616161616161616161616161616161616161613E
            dynSlot: 0
        32 "a"s
            slot: 65(0x0000000000000000000000000000000000000000000000000000000000000041)
            dynSlot: 0x6161616161616161616161616161616161616161616161616161616161616161
        33 "a"s
            slot: 67(0x0000000000000000000000000000000000000000000000000000000000000043)
            dynSlot: 0x6161616161616161616161616161616161616161616161616161616161616161
            dynSlot did not change because the 33rd "a" is written to (dynSlot+1)
        */
    }

    // Most of the time you won't notice the difference between short-format and long-format.
    // However, when you work with references of .push() it can cause problems.
    
    bytes bytesValue = "aaaaaaaaaaaaaaaaaaaaaaaaaa"; // 26 "a"s

    function addToBytes() public {
        (bytesValue.push(), bytesValue.push()) = (0x61, 0x61);
        getStorageValue(1);

        /*
        28 "a"s
            slot:       0x6161616161616161616161616161616161616161616161616161616100000038
            dynSlot:    0
        30 "a"s
            slot:       0x616161616161616161616161616161616161616161616161616161616161003C
            dynSlot:    0
        32 "a"s
            slot:       0x0000000000000000000000000000000000000000000000000000000000006141
            dynSlot:    0x6161616161616161616161616161616161616161616161616161616161610061
            Note that, the second last byte was written to slot instead of dynSlot
            - First .push() reference:
                - At first, bytesValue has a length of 30.
                - The method call will increase its length to 31.
                - The length is still less than 32 so it will stay in short format.
                - It will give a reference to the new element that is the 31st byte in slot.
                - Remember, the 32nd is reserved for storing the length.
            - Second .push() reference:
                - The length of bytesValue is 31.
                - The method call will increase its length to 32.
                - The length reached 32, so it will transform it to long-format, moving all the elements to dynSlot, keeping only the 32nd byte in slot.
                - Give a reference to the new element that is the 32nd byte in dynSlot.
                - Note that, the transformation from short-format to long-format happened before the assignments, so the at the time of the transformation the 31st byte of slot is still empty.
            - Assignments:
                - The first reference still points to the 31st byte of slot, the second reference to the 32nd byte of dynSlot.
                - It breaks the variable, as in long-format slot supposed to only store the length of the array (more precisely the double of it plus one)
                - 0x6141 -> 24897 -> 12448 length
        */
    }
}
