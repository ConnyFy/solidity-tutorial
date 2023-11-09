// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";

/*
- The last thing we need to talk about is bytes and string.
- They can take up two formats: short-format and long-format.
    - If the data is at most 31 bytes long, the elements are stored in the higher-order bytes (left aligned) and the lowest-order byte stores the value length * 2.
    - If the stored data is 32 or more bytes long, the main slot p stores length * 2 + 1 and the data is stored as usual at keccak256(p).
- This is a optimisation mechanism for short bytes and strings.
- Why does it store length*2 and length*2+1?
    - This way we can distinguish a short array from a long array by checking if the lowest bit is set:
        - short: not set, because length*2 is alway an even number.
        - long: set, length*2+1 is always odd.
*/

contract StorageBytesAndString {
    string value = "";

    function printStorageValueAt(uint256 slotIndex) public {
        uint256 dynIndex = uint256(keccak256(abi.encodePacked(slotIndex)));
        uint256 slot;
        uint256 dynSlot;
        assembly {
            slot := sload (slotIndex)
            dynSlot := sload (dynIndex)
        }
        console.log("Slot:", toHexString(slot), "dynSlot:", toHexString(dynSlot));
    }

    function toHexDigit(uint8 d) internal pure returns (bytes1) {
        if (0 <= d && d <= 9) {
            return bytes1(uint8(bytes1('0')) + d);
        } else if (10 <= d && d <= 15) {
            return bytes1(uint8(bytes1('A')) + d - 10);
        }
        revert();
    }
    function toHexString(uint a) internal pure returns (string memory) {
        uint count = 0;
        uint b = a;
        while (b != 0) {
            count++;
            b /= 16;
        }
        if (count == 0) {
            return "0";
        }
        bytes memory res = new bytes(count);
        for (uint i=0; i<count; ++i) {
            b = a % 16;
            res[count - i - 1] = toHexDigit(uint8(b));
            a /= 16;
        }
        return string.concat("0x", string(res));
    }

    function setValue(string memory newValue) public {
        value = newValue;
        printStorageValueAt(0);
        /*
        "a"
            slot: 0x6100000000000000000000000000000000000000000000000000000000000002 - last byte is 2 == length(1)*2
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
            slot: 0x616161616161616161616161616161616161616161616161616161616161613E - last byte is 62 == length(31)*2
            dynSlot: 0
        32 "a"s
            slot: 0x0000000000000000000000000000000000000000000000000000000000000041 == 65 == length(32)*2+1
            dynSlot: 0x6161616161616161616161616161616161616161616161616161616161616161
        33 "a"s
            slot: 0x0000000000000000000000000000000000000000000000000000000000000043 == 67 == length(33)*2+1
            dynSlot: 0x6161616161616161616161616161616161616161616161616161616161616161
            Note that the value of dynSlot did not change because the 33rd "a" was written to the the slot after it (dynSlot+1)
        */
    }

    // BE CAREFUL!
    // Most of the time you won't notice the difference between short-format and long-format.
    // However, when you work with references of .push() it can cause problems.
    
    bytes bytesValue = "aaaaaaaaaaaaaaaaaaaaaaaaaa"; // 26 "a"s

    function addToBytes() public {
        (bytesValue.push(), bytesValue.push()) = (0x61, 0x61);
        printStorageValueAt(1);

        /*
        28 "a"s
            After the first run, we didn't experience any problems.
            The first .push() increased the length and gave a reference to the 27th (by index the 26th) byte of the slot,
            the second .push() increased the length and gave a reference to the 28th byte.
            The values are just as we expected:
            slot:       0x6161616161616161616161616161616161616161616161616161616100000038
            dynSlot:    0
        30 "a"s
            Similar thing happened, the first .push() increased the length and gave a reference to the 29th byte,
            the second .push() also increased the length and gave a reference to the 30th byte.
            slot:       0x616161616161616161616161616161616161616161616161616161616161003C
            dynSlot:    0
        32 "a"s
            And here's the catch.
            The first .push() call:
                - At first, bytesValue has a length of 30.
                - .push() will increase its length to 31.
                - The length is still less than 32 so it will stay in short format.
                - .push() will give a reference to the new element that is the 31st byte in slot(!).
                - Remember, the 32nd is reserved for storing the length.
            The second .push() call:
                - The length of bytesValue is 31.
                - The call of .push() will increase its length to 32.
                - The length reached 32, so it will be transformed to long-format:
                    - move all the elements to dynSlot
                    - leave only the 32nd byte in place and set its last bit to 1, indicating the array is in long-format.
                - .push() gives a reference to the new element that is the 32nd byte of dynSlot(!).
            
            The problem is, the reference that the first .push() call gave still points to the 31st byte of slot(!) besides bytesValue is in long-format now.
            
            What happens after the assignments:
                - The first reference still points to the 31st byte of slot, the second reference to the 32nd byte of dynSlot.
                - It breaks the variable, as in long-format slot supposed to only store the length of the array (more precisely the double of it plus one)
                - 0x6141 -> 24897 -> 12448 length
            
            slot:       0x0000000000000000000000000000000000000000000000000000000000006141
            dynSlot:    0x6161616161616161616161616161616161616161616161616161616161610061
        */
    }
}
