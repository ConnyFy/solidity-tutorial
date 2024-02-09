// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


/*
In a computer program, memory can be divided into two main parts, each with its own purpose and characteristics:
Stack
- The stack is a region of memory used for storing function call information, local value variables, function parameters, and the return value.
- Whenever a function is called, the program generates a new stack memory frame for the function to utilize.
- Stack memory uses a "Last In, First Out" (LIFO) data structure, meaning that the most recently added item is the first to be removed.
- When the function or procedure is finished executing, the stack memory frame is released automatically, and the program returns to the previous point of execution.
- Variables stored on the stack must have a known, fixed size.

Heap
- The heap is a region of memory used for dynamic memory allocation.
- Variables with an unknown size at compile time or a size that might change must be stored on the heap.
- It is where reference types are stored.
- Programming languages solves dynamic memory management in different ways.
    - In C and C++ you have to explicitly allocate and deallocate memory in the heap using functions like malloc and free or new and delete.
    - In Java and Python you only need to allocate memory, deallocation is managed by a garbage collector.
    - In Rust memory is managed through a system of ownership with a set of rules that the compiler checks.
- The management of the heap is usually done through pointers. Pointers are special variables in the stack which point to a memory space in the heap.
*/

/*
There are two categories of variables with respect of how they are stored.

Value types
- The variable itself holds the data, it stores it directly in the memory.
- They live in the stack.
- They are tipically smaller in size and their size must be known at compile-time.
- On copy the value is copied. Changes to one variable will not be reflected on the other.

Reference types
- The variable stores a reference (a memory address) to the actual data somewhere else.
- The reference is typically stored in the stack, while the referred, real data stored in the heap.
- They are more flexible and can hold larger and more complex data.
- As mentioned, data with unknown compile-time size or variable size must live in the heap, hence they need to be a reference type.
- On copy, the reference (the value of the pointer, the memory address) is copied. Changes to one variable (more precisely to the referred, actual data) will be reflected on the other variable.
*/

/*
In Solidity, the layout of the memory is a bit different than in traditional programs.
Instead of separating the memory space into two parts (stack and heap), it is separated into 3+1 parts (stack, memory, storage and calldata).
- Stack is the same in the two cases
- Memory works similar to the heap
- Storage is a mixture of a stack and a heap
- Calldata is fixed, read-only memory region

Stack
- Stack is meant to store primite types declared during a function call.
- It is just like the stack we have seen earlier.

    What is stored here?
        - Value types declared inside a function.
    Where is it located?
        - Inside the EVM memory. It uses a LIFO data structure that has a maximum depth of 1024 elements and contains words of 256 bits.
        - Access to the stack is limited to the top end in the following way:
            - It is possible to copy one of the topmost 16 elements to the top of the stack or
            - Swap the topmost element with one of the 16 elements below it.
            - It is not possible to just access arbitrary elements deeper in the stack without first removing the top of the stack.

Memory
- The EVM operates as a stack machine on 32-bytes words. When the EVM encounters data larger than 32-bytes (complex types like string, bytes, struct or arrays), it cannot process them on the stack.
- Memory is meant to store reference variables declared inside a function call.
- It is very similar to the heap. It is like the RAM of your computer.
- Writing memory variables is way cheaper than storage variables.
- Memory variables live up to a function call (transaction), after they are erased. Compared to storage, memory is also called the "short-term" memory of a smart contract.

    What is stored here?
        - Reference type variables inside function calls (either in the function body or as a function parameter) that are marked with the 'memory' keyword.
    Where is it located?
        - Inside the EVM memory. It is a linear data structure that can be addressed at byte level
            - Reads are limited to a width of 256 bits, while
            - Writes can be either 8 bits or 256 bits wide.
        - Memory is expanded by a word (256-bit), when accessing (either reading or writing) a previously untouched memory word (i.e. any offset within a word).
            - At the time of expansion, the cost in gas must be paid.
            - Memory is more costly the larger it grows (it scales quadratically).

Storage
- Storage is the "long-term memory" where contract-scoped or in other words state variables are stored.
- They are persistent between function calls, and are meant to store the state of a contract.
- You can think on it like the storage of your computer - it is where you store data that will be present even if you restart you computer.
- Writing to the storage is very expensive, so one should only store the really necessary things in it.
- The layout of the storage is fixed once the contract is created. You cannot create new or delete existing storage variables.
- Each contract can maintain their own storage and can access - meaning both reading and writing - only their own data by default.
- The only way contract A can read or write contract B storage is when contract B exposes functions that enable it to do so.

    What is stored here?
        - Variables defined outside of functions (i.e. at contract-level) are storage variables.
        - Does not matter if it is a value or a reference type variable.
    Where is it located?
        - Data stored in storage does not occupy space in the EVM memory directly. Instead, it's stored on the Ethereum blockchain itself.
        - Storage is a key-value store that maps 256-bit words to 256-bit words.
        - Technically it is a huge array with full of zeros. It has a length of 2^256 and contains 32-byte (256-bit) values. Elements of storage is also referred as slots.
            - Of course that is not how it actually stored as that number is approximately the number of atoms in the observable universe.
            - It is implemented by a slotindex -> slotvalue mapping that maps 32-byte keys to 32-byte values.
        - It is like a mixture of a stack and a heap
            - Space for storage variables is allocated at the beginning of the "array".
            - For reference type variables, however, the actual data is stored somewhere else. Instead of using pointer, this location is calculated based on the the variable's offset in the array.

Calldata

- Calldata is a special data location that is very similar to memory.
- It is a read-only area where function arguments are stored.
- Compared to memory the difference is that accessing calldata variables is even cheaper but they are read-only, meaning you cannot declare or assign to calldata variables.

    What is stored here?
        - Referene type variables in a function's parameter list that are marked with 'calldata'.
    Where is it located?
        - It is not located in the EVM memory nor on the blockchain. It is a read-only, static part of the transaction's data.
*/

/*
                | Contract-level    | Function declared | Function parameter
--------------------------------------------------------------------------------
Value types     | Storage           | Stack             | Stack
--------------------------------------------------------------------------------
Reference types | Storage           | Memory            | Memory / Calldata
--------------------------------------------------------------------------------

Inside functions, every reference type declaration has an additional annotation, the "data location". It defines where the referred data is stored.
*/

contract DataLocationDemo {

    uint[] storageVariable = [1,2,3];

    function demo(uint[] calldata calldataVariable) public {
        uint[] memory memoryVariable = new uint[](3);

        // ------
        uint[] storage storagePointer = storageVariable;
        uint[] memory memoryPointer = memoryVariable;
        uint[] calldata calldataPointer = calldataVariable;
    }
}
