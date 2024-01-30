// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/*
- Memory is meant to store short-term data, that only lives for a transaction. The whole memory is reset between calls.
- There are many similarities to Storage, but also many fundamental differences.

- Memory is mutable, you can create new variables in it at any time.

- Accessing Memory is way-way cheaper than accessing Storage - both for reading and especially for writing.

- Memory can also be interpreted as a big array.
- Remember back, in Storage, static-sized variables occupied the beginning of the Storage, however, dynamic variables lived all around Storage - their exact location is calculated with hash functions.
- In Memory, variables are aligned at the beginning of the "array", sequentally.
    - Dynamic arrays in Memory cannot be expanded. At the time of their allocation, the compiler needs to know how much space they will occupy.
    - Also, it is not possible to create mappings in Memory.

- Memory is not tight-packed. Every element takes up a 32-byte space.
    - While uint64[4] takes a single 32-byte slot in Storage, it takes 128 bytes (4 times 32 bytes) in Memory.

- Storage is word-addressable - meaning that you cannot address smaller units of storage than a 32-byte word.
- Memory, on the other hand, is byte-addressable. You can address individual bytes, but you can still read only in 32-byte words.
- Okey, then what is the difference if you can only load 32-byte chunks from Memory? The difference is in addressing.
    - In Storage, address 0, the 0th slot, means an individual 32-byte space. Address 1, the 1st slot, also meant an individual 32-byte space. Every time you increase the slot index by 1, you get access to a new 32-byte space.
    - In Memory, address 0x00 means a single byte, address 0x01 is also a single byte. It is true that if you read address 0x00, you also get access to 32 bytes - from 0x00 (0) to 0x1F (31). If you want to read the next 32-byte space, you need to read 0x20, instead of 0x01.
- Even though Storage is tight-packed, it is still considered word-addressable.
    - Remember back, if you have a uint64[4] variable, the 4 items will be in the same slot. If you want to modify only one of them, the EVM still needs to read all the 4 and with arithmetic operators modify only that specific item.
- (Note, while SLOAD, SSTORE, MLOAD and MSTORE operates on 32-byte words, there is also MSTORE8 that is used to store a single byte in the memory.)
*/

contract MemoryIntroduction {
    struct Person {
        uint256 age;
    }
   
    function a_demo() public {
        uint256 one;
        uint8 ten;
        bool[2] memory answers = [false, true];
        bytes memory secret = hex"CAFE";
        string memory keyword = "magic";
        Person memory person = Person({age:60});
        
        // Contrary to Storage, we cannot create mappings in Memory.
        // As mentioned, variables in Memory need to have an exact size at the time of their allocation. Mapping is a data structure that lets an arbitrary amount of expansion.
        // mapping(address => uint256) memory owe;
        // In theory, it could be possible to create a mapping-like structure in Memory - with a pre-defined keyset it could allocate a fixed size chunk in the memory. So far, nothing like this is implemented in the native language.

        // Moreover, we cannot initialize dynamic-sized arrays like we did in Storage.
        // The following assignment is invalid:
        // uint256[] memory numbers = [1, 2, 3];
        // The reason is, in Storage we can write `uint256[] numbers = [1, 2, 3];` This means a dynamic-sized array of which the first 3 elements are set to 1, 2 and 3.
        // Remember, in Storage, we could use .push() to append new elements to the array, and increasing its size.
        // We could do this because as mentioned, dynamic storage arrays are not stored in their slots slot, but somewhere else in Storage.
        // In memory, again, we need to know the exact size of a variable at the time of the allocation because memory variables are allocated sequentally.
        // We cannot call .push() on memory arrays.
        // Dynamic arrays in memory are dynamic in the meaning they can be assigned to an arbitrary length array. Once assigned, they cannot be expanded.
        // These are valid assignments:
        uint[] memory numbers = new uint[](10);
        numbers = new uint[](100);
        uint arraySize = 1;
        numbers = new uint[](arraySize);
        // You can even assign dynamic storage or calldata variables of the same base type.

        // So, to finally answer the question why the first assignment is invalid, `[1, 2, 3]` by its nature means a 3-long array.
        // Assigning it to uint[] memory would not make any sense. Did the programmer actually mean a 3-long array? Then use uint[3] memory. Did the programmer mean a dynamic array of which the first 3 elements are 1,2 and 3? Then how long the array should be?
    }

    /*
    Pointers/References
    - Pointers work very similar to what we have seen at Storage, but there are some differences
    */

    function b_pointerDemo() public {
        uint8[3] memory numbers1 = [1,2,3];
        uint8[3] memory numbers2 = numbers1;
        console.log("numbers1[0]:", numbers1[0], "numbers2[0]:", numbers2[0]);

        // Modifying data through the original or the reference variable works the same:
        numbers1[0] = 4;
        console.log("numbers1[0]:", numbers1[0], "numbers2[0]:", numbers2[0]);

        numbers2[0] = 5;
        console.log("numbers1[0]:", numbers1[0], "numbers2[0]:", numbers2[0]);

        // Here is a difference:
        numbers1 = [9,8,7];
        console.log("numbers1[0]:", numbers1[0], "numbers2[0]:", numbers2[0]);
        // Storage references are "true references". They refer to the original variable, and "follow" it. Storage references cannot be assigned to a new value, but to a real storage variable.
        // Whenever the real storage variable is assigned to a new value, or deleted (which is technically an assignment to the default value), the reference will reflect the changes. 
        // In case of memory references, the reference does not refer to the original variable itself, but to the same memory address.
        // If the original variable is assigned to a new value, it won't be reflected in the reference variable.
        // Moreover, the reference variable can be assigned to a new variable too, while the original variable stays the same.
        numbers2 = numbers1;
        numbers2 = [7,8,9];
        console.log("numbers1[0]:", numbers1[0], "numbers2[0]:", numbers2[0]);

        // These also applies to delete.
        numbers2 = numbers1;
        delete numbers1;
        console.log("numbers1[0]:", numbers1[0], "numbers2[0]:", numbers2[0]);

        // To provide a deeper explanation, the main reason behind these is a Storage variable has a fixed address. A Storage reference points to this address. Whenever the variable is assigned to a new value, its address stays the same.
        // On the contrary, Memory variables are always references. numbers1 is a reference just like numbers2. Whenever a reference is assigned to another reference (numbers2 = numbers1), it simply sets its pointed address to the other one's.
        // Although when a memory reference is assigned to a new value (numbers1 = [9,8,7]), the right-side is allocated on the memory, and the reference will point to this address. Any other references that pointed to the old address will still point there.
    }

    /*
    Parameters:
    - Memory parameters are mutable references of a data. It can come from an already existing memory variable (internal call), or from transaction data (external call).
    */

    function c_printArray(uint8[3] memory array) public {
        string memory content = string.concat(
            "[",
                Strings.toString(array[0]), ",",
                Strings.toString(array[1]), ",",
                Strings.toString(array[2]),
            "]"
        );
        console.log("Content of array:", content);
    }

    function c_printMyArray() public {
        uint8[3] memory myArray = [1, 2, 3];
        c_printArray(myArray);
    }

    // Just like in case of pointers, you can modify the data through the parameter.
    function c_printUpdatedArray(uint8[3] memory array) public {
        array[0] = 0;
        array[1] += 10;
        array[2] *= 2;
        c_printArray(array);
    }

    /*
    Return value:
    - If you want to return a reference type, it usually have memory data location (sometimes calldata, but it is rarely used).
    */

    function d_concatArray(uint8 a, uint8 b, uint8 c) public returns (uint8[3] memory) {
        uint8[3] memory result = [a, b, c];
        return result;
    }

    function d_printMyArray() public {
        uint8[3] memory myArray = d_concatArray(1, 2, 3);
        c_printArray(myArray);
    } 
}
