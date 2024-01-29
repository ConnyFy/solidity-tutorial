// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

/*
Let's talk about execution context.

First, a brief summary of how contracts can call other contracts.
There are two types of calls: internal calls and external calls.
When a contract calls a method of another contract, it is always an external call.
When a contract calls its own method using just its name, it is an internal call.
However, when a contract calls its own method with this.method(), it is also an external call.
We had to make this differentiation because they behave differently, but we will have an in-depth lesson about function calls.
*/

/*
As mentioned, Memory is meant for short-term data storage, it is refreshed between transactions.
Memory is not only refreshed between transactions, but also cleared at changes of execution context.

An execution context is simply a boundary between external calls. When we create a new execution context - by an external method call - the Memory is reset.
When you make the first call (i.e. a beginning of a transaction) to a method of ContractA, it is the first execution context, introducing a fresh and clean Memory instance.
Let's say, inside that method, ContractA calls a function of ContractB. That is a new context, the Memory is cleared.
When this function of ContractB returns back, we restore the previous execution context and the data that was present in Memory before the context change.
Now, ContractA calls a function of itself (internal call), the EVM stays in the same context, Memory is not cleared.
*/
contract ContractA {
    function A() public view returns (
        uint msizeA,
        uint msizeB
    ) {
        uint[2] memory numbers = [uint(1),2];
        msizeB = B();

        assembly {
            msizeA := msize()
        }
    }

    function B() public view returns (uint msizeB) {
        uint[2] memory numbers = [uint(3),4];
        
        assembly {
            msizeB := msize()
        }
    }
    /*
        If we call B() directly, we just create a two-element array with 3 and 4.
        The Memory will be:
        0x00 -> Scratch space
        0x20 -> Scratch space
        0x40 -> FMP
        0x60 -> Zero slot
        0x80 -> 3
        0xA0 -> 4
        0xC0        <- FMP

        msizeB == 0xC0 (192)
        This is exactly what we have expected.
        ---

        Now, call A(), which after creating an array with two elements (1 and 2), calls B().
        B() simply returns msizeB, then A() calls msize at the end.
        Think about what msizeA and msizeB can be.
        It would be reasonable to expect 0xC0 for both of them, as we create a two-element array in each of them.
        Well, let's see.

        msizeA == msizeB == 0x100 (256)

        How? Let's deconstruct the method call.

        First, we create the array of [1,2]:
        0x00 -> Scratch space
        0x20 -> Scratch space
        0x40 -> FMP
        0x60 -> Zero slot
        0x80 -> 1
        0xA0 -> 2
        0xC0        <- FMP

        Then we make an INTERNAL call to B(). Since it is an internal call, there is no context change!
        Remember back, Memory is cleared when a new execution context is created.
        In this case, there was no new execution context created.
        Even though we call another function, everything is kept in Memory.
        The allocation of [3,4] happens as it was in the same function:
        0x00 -> Scratch space
        0x20 -> Scratch space
        0x40 -> FMP
        0x60 -> Zero slot
        0x80 -> 1
        0xA0 -> 2
        0xC0 -> 3
        0xE0 -> 4
        0x100       <- FMP

        At the end of B(), msize() is equal to 0x100.
        After returning from B, it is still the same execution context. msize() is equal to 0x100 here too.

        Keeping everything in Memory between internal calls is very effective as the EVM do not need to copy and transfer data all around.
        Method parameters and return values are already in the Memory, so the caller/called method can simply set pointers at them.
    */

    // Now, let's see what happens in case of an external call.
    ContractB contractB;
    constructor() {
        contractB = new ContractB();
    }
    
    function extA() public view returns (
        uint msizeA,
        uint msizeB
    ) {
        uint[2] memory numbers = [uint(1),2];
        msizeB = contractB.extB();

        assembly {
            msizeA := msize()
        }
    }
}

contract ContractB {
    function extB() public view returns (uint msizeB) {
        uint[2] memory numbers = [uint(3),4];
        
        assembly {
            msizeB := msize()
        }
    }
    /*
        If we call ContractB.extB() directly, it is technically the same when we called ContractA.B() directly.
        We just create a two-element array with 3 and 4.
        The Memory will be:
        0x00 -> Scratch space
        0x20 -> Scratch space
        0x40 -> FMP
        0x60 -> Zero slot
        0x80 -> 3
        0xA0 -> 4
        0xC0        <- FMP

        msizeB == 0xC0 (192)
        Nothing unusual.
        ---

        Let's call ContractA.extA(), that will call ContractB.extB() after creating a two-element array (1 and 2).
        In the previous case, we got
        msizeA == msizeB == 0x100 (256)
        Now, it is an EXTERNAL call, so we expect a reset in Memory because there will be an execution context switch.
        Now the result is:
        msizeA == 0xE0 (224)
        mszieB == 0xC0 (192)
        
        Let's see what happened.

        First, we create the array of [1,2] inside the execution context 1 (EC1) that was created for the first call:
        EC1
            0x00 -> Scratch space
            0x20 -> Scratch space
            0x40 -> FMP
            0x60 -> Zero slot
            0x80 -> 1
            0xA0 -> 2
            0xC0        <- FMP

        Then we make an EXTERNAL call to ContractB.extB(). It is an external call, so a new execution context is created (EC2).
        Memory is fresh and clean at this point.

        Inside extB(), the allocation of [3,4] happens in EC2, not in EC1:
        EC2
            0x00 -> Scratch space
            0x20 -> Scratch space
            0x40 -> FMP
            0x60 -> Zero slot
            0x80 -> 3
            0xA0 -> 4
            0xC0       <- FMP

        At the end of B(), msize() is equal to 0xC0. We return back to extA().

        Now, something will happen that we haven't covered yet but will talk about in-depth in the next chapter.
        Because the return values of extB() live in a separate execution context (EC2), we cannot simply set pointers at them, or get them from the stack (in case of value types).
        Somehow, they are need to be moved back to the caller's execution context (EC1). The EVM does this by copying every return variable to the Memory of the caller's EC.
        By every return variable, I am truly mean every, including value types. Here, there is only one return variable of the called method (msizeB) that can fit in a single slot.
        
        EC1
            0x00 -> Scratch space
            0x20 -> Scratch space
            0x40 -> FMP
            0x60 -> Zero slot
            0x80 -> 1
            0xA0 -> 2
            0xC0 -> 0xC0 (msizeB, coming from ContractB.extB())
            0xE0        <- FMP

        At last, extA() also calls msize() that is equal to 0xE0.

        Do not worry about this last part of copying return variables to the Memory. We wil cover it in the next chapter.
        For now, concentrate on the fact that in case external calls, a new execution context was created and Memory was reset. However, everything is kept in Memory for internal calls.

        The results again:
        Internal call:
            B():
                0x00 -> Scratch space
                0x20 -> Scratch space
                0x40 -> FMP
                0x60 -> Zero slot
                0x80 -> 3
                0xA0 -> 4
                0xC0        <- FMP

                msizeB == 0xC0 (192)
            
            A() -> B():
                0x00 -> Scratch space
                0x20 -> Scratch space
                0x40 -> FMP
                0x60 -> Zero slot
                0x80 -> 1
                0xA0 -> 2
                0xC0 -> 3
                0xE0 -> 4
                0x100       <- FMP

                msizeA == 0x100 (256)
                msizeB == 0x100 (256)
        
        External call:
            extB():
                0x00 -> Scratch space
                0x20 -> Scratch space
                0x40 -> FMP
                0x60 -> Zero slot
                0x80 -> 3
                0xA0 -> 4
                0xC0        <- FMP

                msizeB == 0xC0 (192)
            
            extA() -> extB():
                EC1
                    0x00 -> Scratch space
                    0x20 -> Scratch space
                    0x40 -> FMP
                    0x60 -> Zero slot
                    0x80 -> 1
                    0xA0 -> 2
                    0xC0 -> 0xC0 (msizeB, coming from ContractB.extB())
                    0xE0        <- FMP
                EC2
                    0x00 -> Scratch space
                    0x20 -> Scratch space
                    0x40 -> FMP
                    0x60 -> Zero slot
                    0x80 -> 3
                    0xA0 -> 4
                    0xC0       <- FMP
                  
                msizeA == 0xE0 (224)
                mszieB == 0xC0 (192)
    */
}