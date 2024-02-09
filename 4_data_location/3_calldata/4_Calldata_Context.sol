// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;


/*
In the chapter about memory, we talked about execution context. It is a boundary between external calls.
At the creation of a new execution context, the parameters with which the function was called are passed in calldata.
On return, the return values are passed in something called returndata - which is the counter part of calldata.
*/
contract ContractA {
    ContractB contractb;
    constructor() {
        contractb = new ContractB();
    }

    function a_callInternal(uint[3] calldata data) public view returns (bytes calldata calldataCurrent, bytes memory calldataOther) {
        calldataCurrent = msg.data;
        uint[] memory otherData = new uint[](3);
        calldataOther = otherMethodInternal(otherData);
        /*
        input = [1,2,3]
        ---------------
        calldataCurrent:
        0xcc5085af
        0000000000000000000000000000000000000000000000000000000000000001
        0000000000000000000000000000000000000000000000000000000000000002
        0000000000000000000000000000000000000000000000000000000000000003

        calldataOther:
        0xcc5085af
        0000000000000000000000000000000000000000000000000000000000000001
        0000000000000000000000000000000000000000000000000000000000000002
        0000000000000000000000000000000000000000000000000000000000000003

        On an internal call, no new execution context is created.
        Same execution context, same calldata.
        */
    }

    function b_callExternal(uint[3] calldata data) public view returns (bytes calldata calldataCurrent, bytes memory calldataOther) {
        calldataCurrent = msg.data;
        uint[] memory otherData = new uint[](3);
        calldataOther = contractb.otherMethodExternal(otherData);
        /*
        input = [1,2,3]
        ---------------
        calldataCurrent:
        0xa64d80f1
        0000000000000000000000000000000000000000000000000000000000000001
        0000000000000000000000000000000000000000000000000000000000000002
        0000000000000000000000000000000000000000000000000000000000000003

        calldataOther:
        0x5c0ad753
        0000000000000000000000000000000000000000000000000000000000000020
        0000000000000000000000000000000000000000000000000000000000000003
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000

        Now this is an external call, so otherData was passed in calldata to the other execution context.
        */
    }

    function c_callExternalInside(uint[3] calldata data) public view returns (bytes calldata calldataCurrent, bytes memory calldataOther) {
        calldataCurrent = msg.data;
        uint[] memory otherData = new uint[](3);
        calldataOther = this.otherMethodInternal(otherData);

        /*
        I mentioned earlier that in a following lesson we talk deeply about calls.
        Now, just to showcase, calling a method of the same contract is count as external if we call it like this.menthod().
        A new execution context is going to be created eventhough it calls to the same contract.
        
        input = [1,2,3]
        ---------------
        calldataCurrent:
        0xfedb6885
        0000000000000000000000000000000000000000000000000000000000000001
        0000000000000000000000000000000000000000000000000000000000000002
        0000000000000000000000000000000000000000000000000000000000000003

        calldataOther:
        0xe52ab9e5
        0000000000000000000000000000000000000000000000000000000000000020
        0000000000000000000000000000000000000000000000000000000000000003
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000

        Here we are, the calldata has changed.
        */
    }

    function otherMethodInternal(uint[] memory data) public view returns (bytes calldata calldataResult) {
        calldataResult = msg.data;
    }
}

contract ContractB {
    function otherMethodExternal(uint[] memory data) public view returns (bytes calldata calldataResult) {
        calldataResult = msg.data;
    }
}