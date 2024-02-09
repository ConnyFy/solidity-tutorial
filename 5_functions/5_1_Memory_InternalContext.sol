// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/*
Let's talk about memory parameters, return types and execution context.

First, a brief summary of how contracts can call other contracts.
There are two types of calls: internal calls and external calls.
When a contract calls a method of another contract, it is always an external call.
When a contract calls its own method using just its name, it is an internal call.
However, when a contract calls its own method with this.method(), it is also an external call.
We had to make this differentiation because they behave differently, but we will have an in-depth lesson about function calls.
*/

/*
As mentioned, memory is meant for short-term data storage, it is refreshed between transactions.
Memory is not only refreshed between transactions, but also cleared at changes of execution context.

An execution context is simply a boundary between external calls. When we create a new execution context - by an external method call - the memory is reset.
When you make the first call (i.e. a beginning of a transaction) to a method of ContractA, it is the first execution context, introducing a fresh and clean memory instance.
Let's say, inside that method, ContractA calls a function of ContractB. That is a new context, the memory is cleared.
When this function of ContractB returns back, we restore the previous execution context and the data that was present in memory before the context change.
Now, ContractA calls a function of itself (internal call), the EVM stays in the same context, memory is not cleared.
*/

/*
As a general rule, memory parameters are copied to the memory sequentally as they were a regulare variable that was just initialized.
Then, memory return variables are initialized with a default value - for fixed size types the EVM allocates space, while dynamic size types set to point at the Zero slot.
*/

/*
Let's start exploring memory in case of internal calls.
*/
contract ContractA {

    function method1(uint[3] memory param) public view returns (
        uint[3] memory result,
        uint msize1, uint ptrParam1, uint ptrResult1,
        uint msize2, uint ptrParam2, uint ptrResult2, uint ptrVariable2,
        uint msize3, uint ptrParam3, uint ptrResult3, uint ptrVariable3
    ) {
        // Step 1
        assembly {
            msize1 := msize()
            ptrParam1 := param
            ptrResult1 := result
        }
        
        // Step 2
        uint[3] memory variable = [uint(4),5,6];
        assembly {
            msize2 := msize()
            ptrParam2 := param
            ptrResult2 := result
            ptrVariable2 := variable
        }

        // Step 3
        result = variable;
        assembly {
            msize3 := msize()
            ptrParam3 := param
            ptrResult3 := result
            ptrVariable3 := variable
        }
    }
    /*
        param == [1,2,3]
        ---------------------
        result == [4,5,6]
        msize1 == 0x140 (320), ptrParam1 == 0x80 (128), ptrResult1 == 0xE0 (224)
        msize2 == 0x1A0 (416), ptrParam2 == 0x80 (128), ptrResult2 == 0xE0 (224), ptVariable2 == 0x140 (320)
        msize3 == 0x1A0 (416), ptrParam3 == 0x80 (128), ptrResult3 == 0x140 (320), ptVariable3 == 0x140 (320)

        What happened?

        The first 4 slots are reserved.
        0x00 -> Scratch space
        0x20 -> Scratch space
        0x40 -> FMP
        0x60 -> Zero slot

        Then, we have a memory parameter. It is simply copied to the memory as it was a variable we just created.
        0x80 -> 1   <- param points here
        0xA0 -> 2
        0xC0 -> 3

        Then, allocate space for the default value of the memory return variable.
        This function have a uint[3] return variable, so the EVM allocated the next 3 slots and set `result` to point to this space.
        0x80 -> 1   <- param points here
        0xA0 -> 2
        0xC0 -> 3
        0xE0 -> 0   <- result points here
        0x100 -> 0
        0x120 -> 0
        0x140       <- FMP
        
        Step 1:
        All of these has happaned before the first instruction of the function body.
        That is why, at step 1 we get
        msize1 == 0x140 (320), ptrParam1 == 0x80 (128), ptrResult1 == 0xE0 (224)

        Step 2:
        The next line is `uint[3] memory variable = [uint(4),5,6];`.
        We already now what that is. It allocates a new 3-slot long space in the memory, and sets `variable` to point there.
        0x80 -> 1   <- param points here
        0xA0 -> 2
        0xC0 -> 3
        0xE0 -> 0   <- result points here
        0x100 -> 0
        0x120 -> 0
        0x140 -> 4  <- variable points here
        0x160 -> 5
        0x180 -> 6
        0x1A0       <- FMP

        msize() has increased by 3x32 (= 96), from 0x140 to 0x1A0.
        msize2 == 0x1A0 (416), ptrParam2 == 0x80 (128), ptrResult2 == 0xE0 (224), ptVariable2 == 0x140 (320)

        Step 3:
        And finally, `result = variable;`
        It sets `result` to point where `variable` points to.
        0x80 -> 1   <- param points here
        0xA0 -> 2
        0xC0 -> 3
        0xE0 -> 0
        0x100 -> 0
        0x120 -> 0
        0x140 -> 4  <- variable points here, result points here
        0x160 -> 5
        0x180 -> 6
        0x1A0       <- FMP

        msize3 == 0x1A0 (416), ptrParam3 == 0x80 (128), ptrResult3 == 0x140 (320), ptVariable3 == 0x140 (320)
        msize() stays the same, as there was no new memory allocation, just a pointer assignment.


        And finally, the function returns. The uint params have their value assigned.
        `result` has a type of uint[3], so it returns the next 3 slots form where it points to (0x80 - 0xA0 - 0xC0).
    */

    // A lot of stuff happened, now let's look at a scenario when the size of the parameter or the return value is unknown.
    function method2(uint[] memory param) public view returns (
        uint[] memory result,
        uint msize1, uint ptrParam1, uint ptrResult1,
        uint msize2, uint ptrParam2, uint ptrResult2, uint ptrVariable2,
        uint msize3, uint ptrParam3, uint ptrResult3, uint ptrVariable3
    ) {
        // Step 1
        assembly {
            msize1 := msize()
            ptrParam1 := param
            ptrResult1 := result
        }
        
        // Step 2
        uint[] memory variable = new uint[](3);
        variable[0] = 4;
        variable[1] = 5;
        variable[2] = 6;
        assembly {
            msize2 := msize()
            ptrParam2 := param
            ptrResult2 := result
            ptrVariable2 := variable
        }

        // Step 3
        result = variable;
        assembly {
            msize3 := msize()
            ptrParam3 := param
            ptrResult3 := result
            ptrVariable3 := variable
        }
    }
    /*
        param == [1,2,3]
        ---------------------
        result == [4,5,6]
        msize1 == 0x100 (256), ptrParam1 == 0x80 (128), ptrResult1 == 0x60 (96)
        msize2 == 0x180 (384), ptrParam2 == 0x80 (128), ptrResult2 == 0x60 (96) , ptVariable2 == 0x100 (256)
        msize3 == 0x180 (384), ptrParam3 == 0x80 (128), ptrResult3 == 0x100 (256), ptVariable3 == 0x100 (256)

        Let's deconstruct this function call.
        The beginning is almost the same.
        The first 4 slots are reserved.
        0x00 -> Scratch space
        0x20 -> Scratch space
        0x40 -> FMP
        0x60 -> Zero slot

        Then, we have the memory parameter. As in the previous case, it is copied to the memory as it was a regular variable.
        Now, it is a dynamic array, so the difference is that there is an additional slot reserved for the length of the array.
        0x80 -> 3 (length)  <- param points here
        0xA0 -> 1
        0xC0 -> 2
        0xE0 -> 3
        0x100       <- FMP

        Now, the return type is also a dynamic array.
        As mentioned previously, the EVM could have allocated a slot full of zeroes - indicating a zero-length dynamic array -
        but it did a more optimized step. Instead of allocating empty slot, it sets the return variable to point to the Zero slot.

        0x00 -> Scratch space
        0x20 -> Scratch space
        0x40 -> FMP
        0x60 -> Zero slot   <- result points here
        0x80 -> 3 (length)  <- param points here
        0xA0 -> 1
        0xC0 -> 2
        0xE0 -> 3
        0x100       <- FMP

        // Step 1
        And that is why we got this result at Step 1.
        msize1 == 0x100 (256), ptrParam1 == 0x80 (128), ptrResult1 == 0x60 (96)

        // Step 2
        `uint[] memory variable = new uint[](3);` is again, a memory allocation and a pointer assignment.
        We also change the value of all three elements of variable.
        0x00 -> Scratch space
        0x20 -> Scratch space
        0x40 -> FMP
        0x60 -> Zero slot   <- result points here
        0x80 -> 3 (length)  <- param points here
        0xA0 -> 1
        0xC0 -> 2
        0xE0 -> 3
        0x100 -> 3 (length) <- variable points here
        0x120 -> 4
        0x140 -> 5
        0x160 -> 6
        0x180       <- FMP

        msize2 == 0x180 (384), ptrParam2 == 0x80 (128), ptrResult2 == 0x60 (96) , ptVariable2 == 0x100 (256)

        // Step 3
        And the last step is again a pointer assignment.
        `result = variable;`
        0x00 -> Scratch space
        0x20 -> Scratch space
        0x40 -> FMP
        0x60 -> Zero slot
        0x80 -> 3 (length)  <- param points here
        0xA0 -> 1
        0xC0 -> 2
        0xE0 -> 3
        0x100 -> 3 (length) <- variable points here, result points here
        0x120 -> 4
        0x140 -> 5
        0x160 -> 6
        0x180       <- FMP

        msize3 == 0x180 (384), ptrParam3 == 0x80 (128), ptrResult3 == 0x100 (256), ptVariable3 == 0x100 (256)
    */

    
    // Finally, let's talk about execution context in case of internal calls.
    // function method3_A() public view returns (
    //     uint msizeA,
    //     uint msizeB
    // ) {
    //     uint[2] memory numbers = [uint(1),2];
    //     msizeB = method3_B();

    //     assembly {
    //         msizeA := msize()
    //     }
    // }

    // function method3_B() public view returns (uint msizeB) {
    //     uint[2] memory numbers = [uint(3),4];
        
    //     assembly {
    //         msizeB := msize()
    //     }
    // }
    // /*
    //     If we call method3_B() directly, we just create a two-element array with 3 and 4.
    //     The memory will be:
    //     0x00 -> Scratch space
    //     0x20 -> Scratch space
    //     0x40 -> FMP
    //     0x60 -> Zero slot
    //     0x80 -> 3
    //     0xA0 -> 4
    //     0xC0        <- FMP

    //     msizeB == 0xC0 (192)
    //     This is exactly what we have expected.
    //     ---

    //     Now, call method3_A(), that after creating an array with two elements (1 and 2), calls method3_B().
    //     method3_B() simply returns msizeB. We query msize at the end of method3_A().
    //     Think about what msizeA and msizeB can be.
    //     It would be reasonable to expect 0xC0 for both of them, as we create a two-element array in each of them.
    //     Well, let's see.

    //     msizeA == msizeB == 0x100 (256)

    //     How? Let's deconstruct the method call.

    //     First, we create the array of [1,2]:
    //     0x00 -> Scratch space
    //     0x20 -> Scratch space
    //     0x40 -> FMP
    //     0x60 -> Zero slot
    //     0x80 -> 1
    //     0xA0 -> 2
    //     0xC0        <- FMP

    //     Then we make an INTERNAL call to beta(). Since it is an internal call, there is no context change!
    //     Remember back, memory is cleared when a new execution context is created.
    //     In this case, there was no new execution context created.
    //     Even though we call another function, everything is kept in memory.
    //     The allocation of [3,4] happens as it was in the same function:
    //     0x00 -> Scratch space
    //     0x20 -> Scratch space
    //     0x40 -> FMP
    //     0x60 -> Zero slot
    //     0x80 -> 1
    //     0xA0 -> 2
    //     0xC0 -> 3
    //     0xE0 -> 4
    //     0x100       <- FMP

    //     At the end of method3_B(), msize() is equal to 0x100.
    //     After returning from method3_B, it is still the same execution context. msize() is equal to 0x100 here too.

    //     Keeping everything in memory between internal calls is very effective as the EVM do not need to copy and transfer data all around.
    //     Method parameters and return values are already in the memory, so the caller/called method can simply set pointers at them.
    // */
}