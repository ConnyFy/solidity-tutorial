// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

import "hardhat/console.sol";

/*
Solidity reserves the first four 32-byte slots in Memory.
- 0x00 - 0x3f: Scratch space. It refers to an area in memory that is used temporarily for intermediate computations. It is a working area for more complex calculations e.g. hashing.
- 0x40 - 0x5f: Free memory pointer (FMP). It is used for memory allocations. Free memory pointer points to the first unused* slot in the memory.
- 0x60 - 0x7f: Zero slot. According to the docs, it contains zeroes, should not be overwritten and is used as the initial value for empty dynamic memory arrays.
    However, it is mainly just a gap between the reserved slots and the allocated variables.

In Solidity, memory is never freed. There is no garbage collector and memory variables cannot go out of scope. The FMP keeps getting higher and higher, new objects are allocated sequentally after each other.
*/

contract MemoryReservedSpace {

    function a_FMP() public view returns (uint a, uint b, uint c) {
        /*
        As mentioned, free memory pointer points to the first unused slot in the memory. It is partially true, we will see why.
        
        Everytime we allocate a new variable in the memory, it is placed where the FMP points to.
        After the allocation, the FMP is increased by the size of the allocated space.
        */

        // Initially, the FMP points to 0x80, which is the beginning of the 5th 32-byte slot.
        // a == 0x80 (128)
        assembly {
            a := mload (0x40)
        }

        // Let's allocate an array of uint256. An element of the array is 256-bit, 32-byte.
        uint256[3] memory array;
        // The FMP was increased by 3 slots, 3x32 bytes.
        // b == 0xE0 (224)
        assembly {
            b := mload (0x40)
        }

        // Memory allocation for dynamic arrays works similar.
        // The difference is, an additional slot is allocated at the beginning that holds the length of the array.
        uint256[] memory arrayDynamic = new uint256[](2);
        // The FMP was increased by 3 slots again (1 for the length, 2 for the data).
        // c == 0x140 (320)
        assembly {
            c := mload (0x40)
        }
    }
    
    function b_FMPAssembly(uint addr) public view returns (uint value, uint[] memory dynamicResult) {
        // Let's look at some more examples of FMP.

        // We allocate some space in memory.
        uint8[5] memory numbers = [1,2,3,4,5];
        /*
        The memory looks like this:
        0x00 -> Scratch space
        0x20 -> Scratch space
        0x40 -> FMP -> 0x120 (288)
        0x60 -> Zero slot
        ----------
        0x80 -> 1 ---+
        0xA0 -> 2    |
        0xC0 -> 3    | numbers
        0xE0 -> 4    |
        0x100 -> 5 --+
        0x120       <- FMP
        0x140
        0x160
        0x180
        0x1A0
        ...
        */

        // As mentioned earlier, you do not need to worry about handling FMP if you allocate memory the "normal way", i.e. creating regular variables.
        // However, during the usage of inline assembly, we also need to manage the update of FMP, it is not done automatically.
        // With MSTORE, we can allocate space in memory at an arbitrary place.
        // Don't worry, we will have a separate lesson for inline assembly, now, we just use it to understand how FMP works better.

        // Store 10 at 0x160
        assembly {
            mstore(0x160, 10)
        }
        /*
        0x80 -> 1 ---+
        0xA0 -> 2    |
        0xC0 -> 3    | numbers
        0xE0 -> 4    |
        0x100 -> 5 --+
        0x120       <- FMP
        0x140
        0x160 -> 10
        0x180
        0x1A0
        */

        // Since FMP was not updated, normal memory allocations starts from the address FMP points to.
        // This allocation will overwrite 0x160 with 0 (default value of uint), also, update FMP.
        uint8[3] memory numbers2 = [6,7,8];
        /*
        0x80 -> 1 ---+
        0xA0 -> 2    |
        0xC0 -> 3    | numbers
        0xE0 -> 4    |
        0x100 -> 5 --+
        0x120 -> 6 --+
        0x140 -> 7   | numbers2
        0x160 -> 8 --+
        0x180       <- FMP
        0x1A0
        */

        // If we want to store a new value in Memory, make sure to update FMP correctly.
        assembly {
            mstore(0x180, 9)
            mstore(0x40, 0x1A0)
        }
        /*
        0x80 -> 1 ---+
        0xA0 -> 2    |
        0xC0 -> 3    | numbers
        0xE0 -> 4    |
        0x100 -> 5 --+
        0x120 -> 6 --+
        0x140 -> 7   | numbers2
        0x160 -> 8 --+
        0x180 -> 9
        0x1A0       <- FMP
        */
        
        uint8[1] memory numbers3 = [10];
        /*
        0x80 -> 1 ---+
        0xA0 -> 2    |
        0xC0 -> 3    | numbers
        0xE0 -> 4    |
        0x100 -> 5 --+
        0x120 -> 6 --+
        0x140 -> 7   | numbers2
        0x160 -> 8 --+
        0x180 -> 9
        0x1A0 -> 10 -- numbers3
        0x1C0       <- FMP
        */

        // One last thing, let's try to modify a dynamic array from inline assembly.
        uint[] memory numbers4;

        // The first slot stores the length of the dynamic array, then comes the data, then the slot where FMP points to.
        assembly {
            mstore(0x1C0, 2)
            mstore(0x1E0, 11)
            mstore(0x200, 12)

            mstore(0x40, 0x220)

            numbers4 := 0x1C0
        }
        /*
        0x80 -> 1 ---+
        0xA0 -> 2    |
        0xC0 -> 3    | numbers
        0xE0 -> 4    |
        0x100 -> 5 --+
        0x120 -> 6 --+
        0x140 -> 7   | numbers2
        0x160 -> 8 --+
        0x180 -> 9
        0x1A0 -> 10 -- numbers3
        0x1C0 -> 2 --+
        0x1E0 -> 11  | numbers4
        0x200 -> 12 -+
        0x220       <- FMP
        */

        // The first three instructions set the length of the array to two, and the data.
        // The 4th line updates the FMP to the slot after the last one we have just allocated.
        // The 5th line sets the value of variable numbers4 to the beginning of the allocated space.
        // Remember, numbers4 is just a POINTER, not the actual array. It is a variable ON THE STACK
        // that stores an address from the MEMORY. 

        dynamicResult = numbers4;

        // As you can see, FMP is a key concept in memory management.
        // During normal development, it is handled by the compiler,
        // but in inline assembly, you need to update it. 
        
        // Earlier I said, FMP points to the first unused slot in the memory.  It is for normal variable allocation,
        // but as you have seen it, with inline assembly you can set the FMP to any address, and variable allocation
        // will happen from there.

        assembly {
            value := mload (addr)
        }
    }
    
    function c_msize() public view returns (uint currentMsize, uint fmp) {
        // An other interesting thing.
        // There is an inline assembly instruction, called msize
        // Contrary to what its name suggests, it is not how many slots are allocated in Memory
        // but the address of the highest byte we have ever reached (plus one).
        // During normal allocation, they are the same. All slots are filled sequentially, so the highest
        // address we have reached by allocation (+1) is equal to the number of occupied bytes.

        // But what if we read or write something further up?
        uint8[5] memory numbers = [1,2,3,4,5];
        /*
        0x00 -> Scratch space
        0x20 -> Scratch space
        0x40 -> FMP -> 0x120 (288)
        0x60 -> Zero slot
        0x80 -> 1 ---+
        0xA0 -> 2    |
        0xC0 -> 3    | numbers
        0xE0 -> 4    |
        0x100 -> 5 --+
        0x120       <- FMP
        */
        // Currently msize() == 0x120 (288)
        // The highest memory address ever reached is 0x11F (the last occupied byte of numbers), plus one is 0x120
        // and in total we have occupied 9x32 (= 288 = 0x120) bytes

        uint furtherValue;
        assembly {
            furtherValue := mload (0x200)
        }
        // After this, the FMP still points to 0x120 and we haven't allocated any new space.
        // Still, msize() == 0x220 (544), because the highest memory address we have reached
        // is the last we have touched during mload (0x200). mload loads a 32-byte space, so
        // from 0x200 to 0x21F. Add plus one to 0x21F, it is 0x220.

        assembly {
            currentMsize := msize()
            fmp := mload(0x40)
        }

        // Why did I show this to you? I mentioned earlier, accessing Memory is cheaper than Storage.
        // However, the cost of memory operations is not only depends on how many bytes you want to store,
        // but also on how many bytes you have already used.
        // The cost is linear up to the first 724 bytes (22.625 words), after that a quadratic component is added.
        // By reading a higher address, we just triggered a "memory expansion" making the execution of the function more costly.
        // We will cover cost and cost optimization techniques later on.
    }
}
