// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract SolidityTypes {
    bool bool_variable;
    int128 signed_int_variable;
    uint128 unsigned_int_variable;
    fixed128x18 signed_fixed_variable;
    ufixed128x18 unsigned_fixed_variable;
    address address_variable;
    bytes32 bytes_fixed_variable;
    
    int[5] int_array_variable;
    bytes bytes_dynamic_variable;
    string string_variable;
    mapping(address => uint128) mapping_variable;

    enum EnumType { Enum1, Enum2, Enum3 }
    EnumType enum_variable;

    struct StructType {
        address addr;
        uint128 number;
    }
    StructType struct_variable;
}