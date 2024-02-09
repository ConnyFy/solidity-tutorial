// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;


/*
As mentioned, calldata is the place where input parameters arrive on the creation of a new execution context.
The counterpart of calldata is returndata. It is the place where return values leave the execution context,
either giving back the result to the previous context, or to the "user".
Returndata is usually not mentioned as a data location in articles, as it is not a place where you directly find your data,
you cannot allocate data inside it, and you cannot even tap into it outside of inline assembly.
Returndata is encoded the same way as calldata, nothing special.
Just for a quick demonstration, let's look at some examples.
*/
contract ContractA {

    ContractB contractb;
    constructor() {
        contractb = new ContractB();
    }

    enum CALL_TYPE {
        NUMBER,
        FIX_ARRAY,
        DYNAMIC_ARRAY,
        BYTES,
        FIX_ARRAY_BYTES,
        STRUCT
    }

    function returnDataNumber(CALL_TYPE callType) public view returns (bytes memory returnData) {
        if(callType == CALL_TYPE.NUMBER) {
            contractb.returnNumber();
        }
        else if(callType == CALL_TYPE.FIX_ARRAY) {
            contractb.returnFixedArray();
        }
        else if(callType == CALL_TYPE.DYNAMIC_ARRAY) {
            contractb.returnDynamicArray();
        }
        else if(callType == CALL_TYPE.BYTES) {
            contractb.returnBytes();
        }
        else if(callType == CALL_TYPE.FIX_ARRAY_BYTES) {
            contractb.returnFixedArrayOfBytes();
        }
        else if(callType == CALL_TYPE.STRUCT) {
            contractb.returnPerson();
        }
        returnData = _copyReturndataToMemory();
    }
    
    function _copyReturndataToMemory() private view returns (bytes memory res) {
        assembly {
            let rsize := returndatasize()
            let offset := add(div(sub(rsize, 1), 0x20), 1)
            res := mload(0x40)
            mstore(res, rsize)
            returndatacopy(add(res, 0x20), 0, rsize)
            mstore(0x40, add(res, mul(add(offset, 1), 0x20)))
        }
    }
}

contract ContractB {
    function returnNumber() public view returns (uint returnValue) {
        returnValue = 1;
        /*
        0000000000000000000000000000000000000000000000000000000000000001
        */
    }
    function returnFixedArray() public view returns (uint[3] memory returnValue) {
        returnValue = [uint(1),2,3];
        /*
        0000000000000000000000000000000000000000000000000000000000000001
        0000000000000000000000000000000000000000000000000000000000000002
        0000000000000000000000000000000000000000000000000000000000000003
        */
    }
    function returnDynamicArray() public view returns (uint[] memory returnValue) {
        returnValue = new uint[](3);
        returnValue[0] = 1;
        returnValue[1] = 2;
        returnValue[2] = 3;
        /*
        0000000000000000000000000000000000000000000000000000000000000020
        0000000000000000000000000000000000000000000000000000000000000003
        0000000000000000000000000000000000000000000000000000000000000001
        0000000000000000000000000000000000000000000000000000000000000002
        0000000000000000000000000000000000000000000000000000000000000003
        */
    }
    function returnBytes() public view returns (bytes memory returnValue) {
        returnValue = hex"CAFECAFE";
        /*
        0000000000000000000000000000000000000000000000000000000000000020
        0000000000000000000000000000000000000000000000000000000000000004
        cafecafe00000000000000000000000000000000000000000000000000000000
        */
    }
    function returnFixedArrayOfBytes() public view returns (bytes[3] memory returnValue) {
        returnValue = [bytes(hex"01"), hex"02", hex"03"];
        /*
        0000000000000000000000000000000000000000000000000000000000000020
        0000000000000000000000000000000000000000000000000000000000000060
        00000000000000000000000000000000000000000000000000000000000000a0
        00000000000000000000000000000000000000000000000000000000000000e0
        0000000000000000000000000000000000000000000000000000000000000001
        0100000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000001
        0200000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000001
        0300000000000000000000000000000000000000000000000000000000000000
        */
    }

    struct Person {
        uint age;
        uint[2] heightAndWeight;
        uint[] favoriteNumbers;
        Car car;
        Experience experience;
    }
    struct Car {
        uint manufactureYear;
        string plateNumber;
    }
    struct Experience {
        uint universityYears;
        uint workingYears;
    }

    function returnPerson() public view returns (Person memory person) {
        person = Person({
            age: 35,
            heightAndWeight: [uint(180), 70],
            favoriteNumbers: new uint[](3),
            car: Car({
                manufactureYear: 2010,
                plateNumber: "ABC123"
            }),
            experience: Experience({
                universityYears: 5,
                workingYears: 10
            })
        });
        person.favoriteNumbers[0] = 5;
        person.favoriteNumbers[1] = 10;
        person.favoriteNumbers[2] = 15;
        /*
        0000000000000000000000000000000000000000000000000000000000000020 - Pointer, where person starts
        0000000000000000000000000000000000000000000000000000000000000023 -- <- person, person.age
        00000000000000000000000000000000000000000000000000000000000000b4 -+ <- person.heightAndWeight
        0000000000000000000000000000000000000000000000000000000000000046 -+
        00000000000000000000000000000000000000000000000000000000000000e0 -- Pointer, where person.favoriteNumbers starts
        0000000000000000000000000000000000000000000000000000000000000160 -- Pointer, where person.car starts
        0000000000000000000000000000000000000000000000000000000000000005 -+ <- person.experience, person.experience.universityYears
        000000000000000000000000000000000000000000000000000000000000000a -+ <- person.experience.workingYears
        0000000000000000000000000000000000000000000000000000000000000003 -+ <- person.favoriteNumbers
        0000000000000000000000000000000000000000000000000000000000000005  |
        000000000000000000000000000000000000000000000000000000000000000a  |
        000000000000000000000000000000000000000000000000000000000000000f -+
        00000000000000000000000000000000000000000000000000000000000007da -- <- person.car, person.car.manufactureYear
        0000000000000000000000000000000000000000000000000000000000000040 -- Pointer, where person.car.plateNumber starts
        0000000000000000000000000000000000000000000000000000000000000006 -+ <- person.car.platenumber
        4142433132330000000000000000000000000000000000000000000000000000 -+
        
        It is the exact same we got during the test of calldata.
        */
    }
}