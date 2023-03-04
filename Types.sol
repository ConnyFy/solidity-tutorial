// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";

contract SolidityTypes {
    // # Simple
    bool bool_variable;
    int128 signed_int_variable;
    uint128 unsigned_int_variable;
    fixed128x18 signed_fixed_variable;
    ufixed128x18 unsigned_fixed_variable;
    address address_variable;
    bytes32 bytes_fixed_variable;

    // ## Demo bool
    function demo_bool() public view {
        bool variable; // false
        bool variable_false = false;
        bool variable_true = true;

        bool negate = !variable_false; // true
        bool logical_and = variable_false && variable_true; // false
        bool logical_or = variable_false || variable_true; // true

        bool equal = variable_false == variable_true; // false
        bool equal2 = variable == variable_false; // true
        bool not_equal = variable_false != variable_true; // true

        console.log("Short circuit - AND");
        bool and_circuit1 = bool_f() && bool_t();
        console.log("---");
        bool and_circuit2 = bool_t() && bool_f();
        console.log("Short circuit - OR");
        bool or_circuit1 = bool_f() || bool_t();
        console.log("---");
        bool or_circuit2 = bool_t() || bool_f();
    }

    function bool_f() public view returns (bool) {
        console.log("f called");
        return false;
    }

    function bool_t() public view returns (bool) {
        console.log("t called");
        return true;
    }

    // ## integers
    function integer_demo() public view {
        int8 int8_var; // 8 bits = 1 byte
        int16 int16_var; // 2 bytes
        /* ... */
        int256 int256_var; // 32 bytes

        uint8 uint8_var; // 1 byte
        /*...*/
        uint256 uint256_var; // 32 bytes

        int int_var; // == int256 int_var;
        uint uint_var; // == uint256 uint_var;

        // Comparison
        uint8 a = 7;
        uint8 b = 42;
        
        bool comparison = a < b;
        // <, <=, ==, !=, >=, >

        // Arithmetic
        // a+b, a-b, a*b, a/b, a%b, -a, a**2
        // a/0, a%0 == error
        // 0**0 == 1

        // Bit operators
        /*
        a=42 ->    00101010
        b=6 ->     00000110
        -------------------
        a&b ->     00000010 (=2)
        a|b ->     00101110 (=46)
        a^b ->     00101100 (=44)
        ~a ->      11010101 (=213)
        */

        // Shift operators
        /*
        a=42 ->    00101010 (=42)
        a<<1 ->    01010100 (=84)
        a<<2 ->    10101000 (=168)
        a>>1 ->    00010101 (=21)
        a>>2 ->    00001010 (=10)
        */

        //TODO: quick demo how signed integers behave

    }
    
    // # Compound
    enum EnumType { Enum1, Enum2, Enum3 }
    EnumType enum_variable;

    struct StructType {
        address addr;
        uint128 number;
    }
    StructType struct_variable;

    type UFixed256x18 is uint256;
    UFixed256x18 user_defined_type_variable;

    // # Dynamic
    int[5] int_array_variable;
    int[] int_dynamic_array_variable;
    bytes bytes_dynamic_variable;
    string string_variable;
    mapping(address => uint128) mapping_variable;
}