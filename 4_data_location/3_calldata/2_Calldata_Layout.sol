// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract CalldataLayout {
    
    // Let's see how calldata looks like. As mentioned, it is a static part of the transaction data, not stored in the memory of the EVM or on the blockchain.
    // Solidity gives us a handy way to reach calldata from a function.
    // msg.data (type: bytes calldata) allows us to directly read calldata.
    // We will talk about other global variables like msg or tx in details in a later section. For now, just remember that msg.data allows to read calldata.
    function a_emptyParams() public view returns (bytes calldata calldataResult) {
        calldataResult = msg.data;
    }
    /*
        calldataResult == 0x8c99aa3f

        Where does it come from?
        As said, the first 4 bytes are special in calldata. It is called the function selector and is calculated by hashing the first 4 bytes of the function signature.
        Here, the function signature is "a_emptyParams()".
        Function selector used by the EVM to determinde which method of a contract it needs to execute.
        When looking up for correct method, it compares function selectors with the first four bytes of the calldata.
        Then, the EVM starts the execution of this function with the given function params - that are also located in calldata.
    */

    function a_emptyParams2() public view returns (bytes calldata calldataResult, bytes4 functionSignature) {
        calldataResult = msg.data;
        // Here's a way how you can compute the signature of a function manually.
        functionSignature = bytes4(keccak256("a_emptyParams2()"));

        // There will be a more advanced lecture about function signatures, low-level calls and ABI.
    }

    // Let's pass some parameters.
    function b1_withValue(uint number) public view returns (bytes calldata calldataResult) {
        calldataResult = msg.data;
        /*
        number == 1
        ----------
        0xe09c0428 <- Function selector
        0000000000000000000000000000000000000000000000000000000000000001 <- number

        Value types are represented simply by their value.
        */
    }
    function b2_withFixedArray(uint[3] calldata numbers) public view returns (bytes calldata calldataResult) {
        calldataResult = msg.data;
        /*
        numbers == [1,2,3]
        ----------
        0x18c479bf <- Function selector
        0000000000000000000000000000000000000000000000000000000000000001 -+ <- numbers
        0000000000000000000000000000000000000000000000000000000000000002  |
        0000000000000000000000000000000000000000000000000000000000000003 -+

        Fixed arrays are inlined if the base type can be inlined.
        Fixed arrays of value types are always inlined because of this.
        However, fixed arrays of non-inlinable types are also not-inlinable. We will see it soon.
        */
    }
    function b3_withDynamicArray(uint[] calldata numbers) public view returns (bytes calldata calldataResult) {
        calldataResult = msg.data;
        /*
        numbers == [1,2,3,4]
        ----------
        0xcfa90f7b <- Function selector
        0000000000000000000000000000000000000000000000000000000000000020 - Pointer to numbers
        0000000000000000000000000000000000000000000000000000000000000004 -+ <- numbers
        0000000000000000000000000000000000000000000000000000000000000001  |
        0000000000000000000000000000000000000000000000000000000000000002  |
        0000000000000000000000000000000000000000000000000000000000000003  |
        0000000000000000000000000000000000000000000000000000000000000004 -+

        Dynamic arrays are never inlined. Instead, a pointer is created, that points to the actual location of the dynamic array.
        This behaviour is very similar to ones we have already seen.
        In storage, dynamic arrays are also stored at a separate location (determined by the hash of the slotnumber). In the actual slot, the length of the array is stored.
        Another place we have seen something similar is stucts in memory. There, a layout for the struct is created - reference values are stored as pointers, then set to the allocated data.
            The exact same thing happens here too. One difference is that in memory structs, fixed size data was also represented by a pointer. Why? Because you could allocate new data and just change the pointer.
            Since calldata is immutable, fixed size data is simply inlined. Just as we saw it in the previous step.

        Okey, so what is that 0x20? It is a pointer to the second calldata slot. When function parameters are encoded for calldata, the function selector is ignored. The first byte of the parameters is the first byte of the first parameter.
        From here, just like in memory, slots are incremented by 0x20. The first slot (here, the pointer) is at 0x00. The second slot (where the actual data of numbers is) is at 0x20 - by the way, this is the length of the array. Then 0x40, 0x60 etc.
        */
    }
    function b4_withBytes(bytes calldata data) public view returns (bytes calldata calldataResult) {
        calldataResult = msg.data;
        /*
        data == 0xCAFECAFE
        ----------
        0x16c89958 <- Function selector
        0000000000000000000000000000000000000000000000000000000000000020 - Pointer to data
        0000000000000000000000000000000000000000000000000000000000000004 -+ <- data
        cafecafe00000000000000000000000000000000000000000000000000000000 -+

        Just like for dynamic arrays, a pointer is created, then comes the actual data. Bytes and string types are tight-packed like in memory.
        */
    }

    // Now, look at a more complex example, to truly understand how calldata is encoded.
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
    function b5_withSturct(Person calldata person) public view returns (bytes calldata calldataResult) {
        calldataResult = msg.data;
        /*
        person = [35, [180, 70], [5,10,15], [2010, "ABC123"], [5, 10]]
        ----------
        0x3a3122a4
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

        Let's deconstruct this. For the simplicity, trim the function selector.
        
        0x000: 0000000000000000000000000000000000000000000000000000000000000020 - Pointer, where person starts
        0x020: 0000000000000000000000000000000000000000000000000000000000000023 -- <- person, person.age
        0x040: 00000000000000000000000000000000000000000000000000000000000000b4 -+ <- person.heightAndWeight
        0x060: 0000000000000000000000000000000000000000000000000000000000000046 -+
        0x080: 00000000000000000000000000000000000000000000000000000000000000e0 - Pointer, where person.favoriteNumbers starts
        0x0A0: 0000000000000000000000000000000000000000000000000000000000000160 - Pointer, where person.car starts
        0x0C0: 0000000000000000000000000000000000000000000000000000000000000005 -+ <- person.experience, person.experience.universityYears
        0x0E0: 000000000000000000000000000000000000000000000000000000000000000a -+ <- person.experience.workingYears
        0x100: 0000000000000000000000000000000000000000000000000000000000000003 -+ <- person.favoriteNumbers
        0x120: 0000000000000000000000000000000000000000000000000000000000000005  |
        0x140: 000000000000000000000000000000000000000000000000000000000000000a  |
        0x160: 000000000000000000000000000000000000000000000000000000000000000f -+
        0x180: 00000000000000000000000000000000000000000000000000000000000007da -- <- person.car, person.car.manufactureYear
        0x1A0: 0000000000000000000000000000000000000000000000000000000000000040 -- Pointer, where person.car.plateNumber starts
        0x1C0: 0000000000000000000000000000000000000000000000000000000000000006 -+ <- person.car.platenumber
        0x1E0: 4142433132330000000000000000000000000000000000000000000000000000 -+

        So, calldata consists of a single struct of type Person. The first calldata slot (first real slot, ignoring the function selector) is a pointer to where the data of person will be placed.
        
        There are no more parameters in calldata, it is time to create the data of person, starting from 0x20. The pointer previously mentioned is set to 0x20.
        Person has age (int), heightAndWeight (fixed array), favoriteNumbers (dynamic array), car (struct) and experience (struct).
        age and heightAndWeight are inlined, 0x20 stores age, while 0x40 and 0x60 stores heightAndWeight.
        favoriteNumbers and car are not inlined, a pointer is reserved for each. 0x80 goes to favoriteNumbers and car takes 0xA0.
        Then comes experience. Because Experience is a struct that only contains values that can be inlined, the whole experience field of person is inlined here.
        person.experience.universityYears is located at 0xC0 while 0xE0 means person.experience.workingYears. 
        The outline of person is finished, let's try to fill up the holes and reserve space for person.favoriteNumbers and person.car.
        
        favoriteNumbers is a dynamic array with length of 3, so 4 slots will be allocated from 0x100 (the last slot for person was 0xE0).
        0x100 = 3 (for the length), 0x120 = 5, 0x140 = 10 (a), 0x160 = 15 (f).
        One last step is to set the pointer in person to 0x100.
        But wait, it says 0xE0, not 0x100. What happened?
        Well, calldata is constructed recursively. When a complex structure is created that that has a variable size substructure, a pointer is created for that subpart.
        The value of the pointer, however, is not measured absolutely like in memory, but relatively to the beginning of the structure it is part of.
        
        person starts from 0x20, counting from here, the slot where person.favoriteNumber is placed is not 0x100 anymore, but 0xE0. That is how we got that 0xE0.

        calldata 0x000:                0000000000000000000000000000000000000000000000000000000000000020 - Pointer, where person starts
        calldata 0x020 [person 0x000]: 0000000000000000000000000000000000000000000000000000000000000023 -- <- person, person.age
        calldata 0x040 [person 0x020]: 00000000000000000000000000000000000000000000000000000000000000b4 -+ <- person.heightAndWeight
        calldata 0x060 [person 0x040]: 0000000000000000000000000000000000000000000000000000000000000046 -+
        calldata 0x080 [person 0x060]: 00000000000000000000000000000000000000000000000000000000000000e0 - Pointer, where person.favoriteNumbers starts
        calldata 0x0A0 [person 0x080]: 0000000000000000000000000000000000000000000000000000000000000160 - Pointer, where person.car starts
        calldata 0x0C0 [person 0x0A0]: 0000000000000000000000000000000000000000000000000000000000000005 -+ <- person.experience, person.experience.universityYears
        calldata 0x0E0 [person 0x0C0]: 000000000000000000000000000000000000000000000000000000000000000a -+ <- person.experience.workingYears
        calldata 0x100 [person 0x0E0]: 0000000000000000000000000000000000000000000000000000000000000003 -+ <- person.favoriteNumbers
        calldata 0x120 [person 0x100]: 0000000000000000000000000000000000000000000000000000000000000005  |
        calldata 0x140 [person 0x120]: 000000000000000000000000000000000000000000000000000000000000000a  |
        calldata 0x160 [person 0x140]: 000000000000000000000000000000000000000000000000000000000000000f -+
        calldata 0x180 [person 0x160]: 00000000000000000000000000000000000000000000000000000000000007da -- <- person.car, person.car.manufactureYear
        calldata 0x1A0 [person 0x180]: 0000000000000000000000000000000000000000000000000000000000000040 -- Pointer, where person.car.plateNumber starts
        calldata 0x1C0 [person 0x1A0]: 0000000000000000000000000000000000000000000000000000000000000006 -+ <- person.car.platenumber
        calldata 0x1E0 [person 0x1C0]: 4142433132330000000000000000000000000000000000000000000000000000 -+

        After the allocation is done for person.favoriteNumbers, let's allocate space for person.car.
        The last slot person.favoriteNumbers used is 0x160, so person.car can be allocated from 0x180.
        For the same reason, relatively from the beginning of person, it is placed at 0x160, that is the value stored in the pointer.

        Okey, person.car is a Car type struct. Its first field is uint (manufactureYear) so it can be inlined and it takes the slot from 0x180.
        The next field has string type (plateNumber) which is again a variable length type.
        The same story repeats, a pointer is placed at 0x1A0 to where the person.car.plateNumber will begin.
        From 0x1C0, person.car.plateNumber can be allocated, 0x1C0 takes the length of the string while 0x1E0 the string data.
        Okey, the last step is to set the pointer at 0x1A0. The "container" structure of person.car.plateNumber now is not person, but person.car,
        so the pointer is set relateively to this one.

        calldata 0x000:                                   0000000000000000000000000000000000000000000000000000000000000020 - Pointer, where person starts
        calldata 0x020 [person 0x000]:                    0000000000000000000000000000000000000000000000000000000000000023 -- <- person, person.age
        calldata 0x040 [person 0x020]:                    00000000000000000000000000000000000000000000000000000000000000b4 -+ <- person.heightAndWeight
        calldata 0x060 [person 0x040]:                    0000000000000000000000000000000000000000000000000000000000000046 -+
        calldata 0x080 [person 0x060]:                    00000000000000000000000000000000000000000000000000000000000000e0 - Pointer, where person.favoriteNumbers starts
        calldata 0x0A0 [person 0x080]:                    0000000000000000000000000000000000000000000000000000000000000160 - Pointer, where person.car starts
        calldata 0x0C0 [person 0x0A0]:                    0000000000000000000000000000000000000000000000000000000000000005 -+ <- person.experience, person.experience.universityYears
        calldata 0x0E0 [person 0x0C0]:                    000000000000000000000000000000000000000000000000000000000000000a -+ <- person.experience.workingYears
        calldata 0x100 [person 0x0E0]:                    0000000000000000000000000000000000000000000000000000000000000003 -+ <- person.favoriteNumbers
        calldata 0x120 [person 0x100]:                    0000000000000000000000000000000000000000000000000000000000000005  |
        calldata 0x140 [person 0x120]:                    000000000000000000000000000000000000000000000000000000000000000a  |
        calldata 0x160 [person 0x140]:                    000000000000000000000000000000000000000000000000000000000000000f -+
        calldata 0x180 [person 0x160] (person.car 0x000): 00000000000000000000000000000000000000000000000000000000000007da -- <- person.car, person.car.manufactureYear
        calldata 0x1A0 [person 0x180] (person.car 0x020): 0000000000000000000000000000000000000000000000000000000000000040 -- Pointer, where person.car.plateNumber starts
        calldata 0x1C0 [person 0x1A0] (person.car 0x040): 0000000000000000000000000000000000000000000000000000000000000006 -+ <- person.car.platenumber
        calldata 0x1E0 [person 0x1C0] (person.car 0x060): 4142433132330000000000000000000000000000000000000000000000000000 -+

        As you can see, the beginning of plateNumber is 0x40 counting from the beginning of person.car.
        */
    }

    /*
    As a general rule, we can say that variable length types (dynamic arrays, bytes and string) are never inlined.
    Fixed length types (fixed arrays, structs) are inlined if they only have inlineable subparts (the base type for arrays, fields for structs).
    If they have any not-inlineable subpart, the whole structrue is not inlined.

    X Person (struct, not-inliabele [has not-inlineable field])
        + age (uint, inlineable [by type])
        + heightAndWeight (fixed array, inlineable [base type is inlineable])
            + uint (inlineable)
        X favoriteNumbers (dynamic array, not-inlineable [by type])
            + uint (inlineable)
        X Car (struct, not-inlineable [has not-inlineable field])
            + manufactureYear (uint, inlineable [by type])
            X plateNumber (string, not-inlineable [by type])
        + Experience (struct, inlineable [all fields are inlineable])
            + universityYears (uint, inlineable [by type])
            + workingYears (uint, inlineable [by type])
    */

    /*
    One last thing, what is the "start" of a structure to which pointers are relative?
    For structs, it is the "beginning" of the struct, i.e. the first slot is uses.
    For fixed array, it is also the "beginning" of the array, i.e. the first slot its first element.
    For dynamic arrays, however, it is the beginning of its data (the beginning of its first element), not counting the length slot.

    For top-level structures, the container structure is the the "calldata".
    Pointers for not-inlineable top level structures is measured to the beginning of calldata (0x00).
    */
    
    // A few more examples about inlining. Experience is inlineable, Car is not.
    // This part is probably not needed.
    function c1_inlinedArray(Experience[2] calldata experiences) public view returns (bytes calldata calldataResult) {
        calldataResult = msg.data;
        /*
        input = [[10,12],[14,15]]
        0x3440943d
        000000000000000000000000000000000000000000000000000000000000000a
        000000000000000000000000000000000000000000000000000000000000000c
        000000000000000000000000000000000000000000000000000000000000000e
        000000000000000000000000000000000000000000000000000000000000000f

        Fixed arrays are inlined if the base type is inlineable.
        */
    }
    struct ExperienceContainer {
        Experience[2] experiences;
    }
    function c2_inlinedStruct(ExperienceContainer calldata experienceContainer) public view returns (bytes calldata calldataResult) {
        calldataResult = msg.data;
        /*
        input = [[[10,12],[14,15]]]
        0xa8e93af1
        000000000000000000000000000000000000000000000000000000000000000a
        000000000000000000000000000000000000000000000000000000000000000c
        000000000000000000000000000000000000000000000000000000000000000e
        000000000000000000000000000000000000000000000000000000000000000f

        A struct is also inlineable if all of its fields are inlineable.
        From the previous example we know that Experience[2] is inlineable, so ExperienceContainer too.
        */
    }

    function c3_notinlinedArray(Experience[] calldata experiences) public view returns (bytes calldata calldataResult) {
        calldataResult = msg.data;
        /*
        input = [[10,12],[14,15]]
        0xe80765cd
        0000000000000000000000000000000000000000000000000000000000000020
        0000000000000000000000000000000000000000000000000000000000000002
        000000000000000000000000000000000000000000000000000000000000000a
        000000000000000000000000000000000000000000000000000000000000000c
        000000000000000000000000000000000000000000000000000000000000000e
        000000000000000000000000000000000000000000000000000000000000000f

        Dynamic arrays are never inlineable. A pointer is created.
        The value of the pointer is technically "absolute", as the array is at top level,
        so its pointer is measured to the beginning of the calldata.
        */
    }

    function c4_notinlinedArray(Car[2] calldata cars) public view returns (bytes calldata calldataResult) {
        calldataResult = msg.data;
        /*
        input = [[1990,"ABC123"],[2010,"XYZ456"]]
        0x5db4d6fb
        calldata 0x000                             0000000000000000000000000000000000000000000000000000000000000020
        calldata 0x020 [cars 0x000]                0000000000000000000000000000000000000000000000000000000000000040 <- beginning of cars, pointer for cars[0]
        calldata 0x040 [cars 0x020]                00000000000000000000000000000000000000000000000000000000000000c0    pointer for cars[1]
        calldata 0x060 [cars 0x040] (cars[0] 0x00) 00000000000000000000000000000000000000000000000000000000000007c6 -+ cars[1]
        calldata 0x080 [cars 0x060] (cars[0] 0x20) 0000000000000000000000000000000000000000000000000000000000000040  |
        calldata 0x0A0 [cars 0x080] (cars[0] 0x40) 0000000000000000000000000000000000000000000000000000000000000006  |
        calldata 0x0C0 [cars 0x0A0] (cars[0] 0x60) 4142433132330000000000000000000000000000000000000000000000000000 -+
        calldata 0x0E0 [cars 0x0C0] (cars[1] 0x00) 00000000000000000000000000000000000000000000000000000000000007da -+ cars[1]
        calldata 0x100 [cars 0x0E0] (cars[1] 0x20) 0000000000000000000000000000000000000000000000000000000000000040  |
        calldata 0x120 [cars 0x100] (cars[1] 0x40) 0000000000000000000000000000000000000000000000000000000000000006  |
        calldata 0x140 [cars 0x120] (cars[1] 0x60) 58595a3435360000000000000000000000000000000000000000000000000000 -+
        */
    }

    function c5_notinlinedArray(Car[] calldata cars) public view returns (bytes calldata calldataResult) {
        calldataResult = msg.data;
        /*
        input = [[1990,"ABC123"],[2010,"XYZ456"]]
        00x14bfe698
        calldata 0x000                             0000000000000000000000000000000000000000000000000000000000000020
        calldata 0x020                             0000000000000000000000000000000000000000000000000000000000000002
        calldata 0x040 [cars 0x000]                0000000000000000000000000000000000000000000000000000000000000040 <- beginning of cars, pointer for cars[0]
        calldata 0x060 [cars 0x020]                00000000000000000000000000000000000000000000000000000000000000c0    pointer for cars[1]
        calldata 0x080 [cars 0x040] (cars[0] 0x00) 00000000000000000000000000000000000000000000000000000000000007c6 -+ cars[1]
        calldata 0x0A0 [cars 0x060] (cars[0] 0x20) 0000000000000000000000000000000000000000000000000000000000000040  |
        calldata 0x0C0 [cars 0x080] (cars[0] 0x40) 0000000000000000000000000000000000000000000000000000000000000006  |
        calldata 0x0E0 [cars 0x0A0] (cars[0] 0x60) 4142433132330000000000000000000000000000000000000000000000000000 -+
        calldata 0x100 [cars 0x0C0] (cars[1] 0x00) 00000000000000000000000000000000000000000000000000000000000007da -+ cars[1]
        calldata 0x120 [cars 0x0E0] (cars[1] 0x20) 0000000000000000000000000000000000000000000000000000000000000040  |
        calldata 0x140 [cars 0x100] (cars[1] 0x40) 0000000000000000000000000000000000000000000000000000000000000006  |
        calldata 0x160 [cars 0x120] (cars[1] 0x60) 58595a3435360000000000000000000000000000000000000000000000000000 -+
        */
    }
}
