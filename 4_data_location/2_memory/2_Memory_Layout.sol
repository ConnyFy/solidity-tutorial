// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";

// As mentioned, contrary to Storage, variables in Memory are not tight packed.
// Elements of arrays will take up a full 32-byte slot even if the base would require less space.
// The only exeptions are bytes and string types that are still tight packed.

// The first 4 x 32-bytes are reserved in Memory. We are going to talk about this region in the next lesson.
// So, the first real memory slot starts at 0x80 (0x00, 0x20, 0x40, 0x60), the next one at 0xA0, then 0xC0, then 0XE0, then 0x100.

// If you are not familiar with hexadecimal numbers yet, it is a number system with a base of 16, unlike the decimal system which is base 10.
// In this system, numbers are counted from 0 to 9 and then from A to F, where A represents 10, B represents 11, up to F which represents 15.
// The calculate the decimal value of a hexadecimal number, multiply the last number with 1, then add the second last number multipled by 16, then the third last multiplied by 16*16 etc.
// We usually place 0x in front of a hexadecimal number to indicate it is not a simple decimal number.

// So in the example above, the memory starts at 0x80, which is equal to 128.
// To get the address of the next slot, increase this value by 32 - that is 160 - or simply add 0x20 to the hexadecimal number: 0x80 + 0x20 = 0xA0

contract MemoryLayout {
    struct Person {
        uint256 age;
        uint256[2] heightAndWeight;
        uint256[] favoriteNumbers;
    }

    function getMemoryAt(uint256 addr) public view returns (uint256 r) {
        // Initially, 0x80 equals to 0.

        // Fixed-size arrays take up exactly as many slots as many elements they have.
        uint8[3] memory array = [1, 2, 3];
        /*
            0x80 -> 1
            0xA0 -> 2
            0xC0 -> 3
        */

        // Dynamic arrays work very similarly, but there is an additional slot at the beginning that holds the length of the array.
        uint8[] memory array2 = new uint8[](3);
        array2[0] = 4;
        array2[1] = 5;
        array2[2] = 6;
        /*
            0xE0 -> 3
            0x100 -> 4
            0x120 -> 5
            0x140 -> 6
        */

        // Structs in Memory work a bit different, somewhat like Storage structs.
        // Memory structs first create an outline of the structure just like Storage structs.
        Person memory person = Person({
            age: 20,
            heightAndWeight: [uint256(180), 70],
            favoriteNumbers: new uint256[](3)
        });
        // In this case, person will reserve 0x160, 0x180 and 0x1A0. The first slot will contain age (uint),
        // the second and third slots will each contain a memory pointer.

        // Remember back how Storage structs were stored? In this particular case,
        // slot 0 would contain age (20)
        // slot 1 and 2 would represent heightAndWeight, storing 180 and 70 respectively.
        // slot 4 would contain 3, which is the length of favoriteNumbers. The real data of favoriteNumbers would be placed at hash(4) in Storage.
        // Storage structs do not need to store pointers to reference-type values. Fixed size data is inlined,
        // dynamic size data is stored at a deterministic place, derived from the slot number.

        // Memory is more pointer centric and allocation of memory variables happens at the beginning of memory, sequentally.
        // That is why at first only the outline is created for the stuct, the space for data is allocated after it.

        // So initially, the memory looks like this:
        /*
            0x160 -> 20 (age)
            0x180 -> 0 (pointer to heightAndWeight)
            0x1A0 -> 0 (pointer to favoriteNumbers)
        */
        // After that, allocate space for the data of heightAndWeight. It is a fixed-size 2 length array.
        /*
            0x1C0 -> 180
            0x1E0 -> 70
        */
        // Set pointer of heightAndWeight to the newly allocated array
        /*
            0x180 -> 0xC0
        */
        // Allocate space for the data of favoriteNumbers. It is a dynamic array with length of 3.
        /*
            0x200 -> 3 (length of the dynamic array)
            0x220 -> 0
            0x240 -> 0
            0x260 -> 0
        */
        // Finally, set the pointer of favoriteNumbers to the address of this array
        /*
            0x1A0 -> 0x200
        */

        // So in the end, the memory will look like this:
        /*
            0x160 -> 20 (age)
            0x180 -> 0x1C0 (448) (pointer to heightAndWeight)
            0x1A0 -> 0x200 (512) (pointer to favoriteNumbers)
            0x1C0 -> 180
            0x1E0 -> 70
            0x200 -> 3
            0x220 -> 0
            0x240 -> 0
            0x260 -> 0
        */

        // And now, the same rules apply to person.heightAndWeight and person.favoriteNumbers what we have seen previously in case of memory pointers.
        // For example, we can assign a new value to a single element inside person.heightAndWeight and it will only modify that part in the memory
        // However, if we assign a whole new array to person.heightAndWeight, it allocates a new array in the memory and changes the pointer, just like in case of memory variables.
        person.favoriteNumbers[0] = 42;
        person.heightAndWeight = [uint256(190), 85];
        // After this, the memory will be:
        /*
            0x160 -> 20 (age)
            0x180 -> 0x280 (640) (pointer to heightAndWeight) (modified)
            0x1A0 -> 0x200 (512) (pointer to favoriteNumbers)
            0x1C0 -> 180 (start of old heightAndWeight)
            0x1E0 -> 70
            0x200 -> 3 (start of favoriteNumbers, length of the dynamic array)
            0x220 -> 42 (modified)
            0x240 -> 0
            0x260 -> 0
            0x280 -> 190 (start of new heightAndWeight)
            0x2A0 -> 85
        */

        // Now, let's overwrite person
        // In Memory, nothing is deleted. New objects are appended to the already existing ones.
        // The last reserved slot in Memory is 0x2A0, so this allocation will take place right after that.
        person = Person({
            age: 30,
            heightAndWeight: [uint(170), 80],
            favoriteNumbers: new uint256[](2)
        });
        /*
            0x2C0 -> 30
            0x2E0 -> 0x320 (800) (pointer to heightAndWeight)
            0x300 -> 0x360 (864) (pointer to favoriteNumbers)
            0x320 -> 170
            0x340 -> 80
            0x360 -> 2
            0x380 -> 0
            0x3A0 -> 0
        */

        // At last, let's have a look on bytes and string types. They work the same way, and are tight packed.
        // A single character in a string or bytes occupies 1 byte, so in a slot you can fit 32 characters.
        string memory numbers = "0123456789012345678901234567890123456789";
        /*
            0x3C0 -> 40 (length of the string)
            0x3E0 -> 0x3031323334353637383930313233343536373839303132333435363738393031 (first 32 chars)
            0x400 -> 0x3233343536373839000000000000000000000000000000000000000000000000 (the remaining 8 chars, right padded with zeros)
        */
        // Sequential string (or bytes) variables are not merged together.
        string memory numbers2 = "0123";
        /*
            0x420 -> 4 (length)
            0x440 -> 0x3031323300000000000000000000000000000000000000000000000000000000 (4 chars)
        */
        // If you reassign a string (or bytes) variable,  a new instance will be allocated.
        numbers = "0123456789";
        /*
            0x460 -> 10 (length)
            0x480 -> 0x3031323334353637383900000000000000000000000000000000000000000000
        */

        assembly {
            r := mload(addr)
        }
    }

    // Let's touch some advanced topics too:
    // If you use Memory the "easy way", i.e. at high-level Solidity, you usually do not need to worry about most of the stuffs.
    // However, for more complex contracts and algorithms you might need to write some inline assembly where the usual safeguards are not present.

    // You might wonder after this lecture, what happens if you read between bytes. Nothing protects to read an arbitrary address in memory.
    // However, mload always reads 32 bytes (256 bits). Look at our first example:
    /*
        0x80 -> 1 (255 0s and 1)
        0xA0 -> 2 (255 0s and 2)
    */
    // In reality there is no border between memory slots. It's a long and continuous array.
    /*
        00000000 00000000 ... 00000000 00000001 00000000 00000000 ... 00000000 00000002
        ^--0x80  ^--0x81      ^-0x9E   ^--0x9F  ^--0xA0  ^--0xA1      ^--0xBE  ^-0xBF  
    */
    // So what happens if you read for example 0x81 instead of 0x80?
    // Instead of 0x80-0x9F, the range of the read will be 0x81-0xA0 
    // In this case, it leaves the first BYTE (not bit, you cannot start reading inside of a byte), and appends a byte full of zeroes to the end.
    // The original value is shifted to the left by one byte, that is equal to a multiplication of 256 (0x100).
    // Instead of 1, the result of the read will be 256.
    
    // Why is Memory not tight packed, contrary to Storage?
    // The EVM operates on 32-byte words. Types that occupy less space need to be extracted from the 32-byte slot with arithmetic operations that increases the total cost.
    // I mentioned briefly in some previous lessons, that execution of a smart contract i.e. calling a transaction costs money. This money is what called gas.
    // Some operations are cheaper to execute, some are very expensive.
    // Accessing Storage is a very expensive, while accessing Memory is quite cheap.
    // Usually in smart contracts, developers try to minimize accessing Storage, and using Memory for quick and frequent operations.
    // While tight packing in Memory could potentially save some space, the gas cost for computing offsets and accessing a slice of data might increase.
    // In contrast, using full 32-byte slots simplifies the computation, often resulting in lower gas costs.
    // For Storage, it is the opposite. Tight packing allows multiple smaller variables to be stored in a single slot, reducing the number of storage operations required to read or write these variables.
    // The two areas have different goals:
    // For memory, the priority is computational efficiency and flexibility, accommodating a wide range of data types and structures during execution.
    // For storage, the main goal is minimizing storage costs on the blockchain.
    
    // Having a standard size for memory slots also simplifies the development of smart contracts. Developers don't have to worry about memory layout and can predict more easily how their data will be stored.
    // For example, if you want to overwrite an element in an array, you can simply write
    // mstore(add(array, mul(index, 0x20)), value)
    // You do not need to play around with indices and modulos and shifts.
   
    // One more interesting, why is the memory byte-addressable, why is it not numbered like storage slots, if everything occupies a 32-byte space?
    // There are two reasons, one is to make the language extendable. In this way, the language can introduce features that praises byte addressing.
    // The other - and more important - reason is that there is an MSTORE8 opcode. SLOAD, SSTORE, MLOAD and MSTORE operate on 32-byte slots.
    // With MSTORE8 the program can overwrite a single byte in memory. It is not particularly useful for the regular Memory usage,
    // but it is an essential for built-in hashing algorithms and custom encoding/decoding.
}
