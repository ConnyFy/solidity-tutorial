// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";

contract TestContract {
    function test() public payable returns (uint8) {
        return 1;
    }
}

contract TestContractReceive {
    receive() external payable {}
}

contract SolidityTypes {
    constructor() payable {}
    // # Simple

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

    // ## Demo Integers
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

        //Right-padded
        uint8 a = 1;
        uint16 b = 1;

        //uint8 c = b;
        uint16 d = a;

        // Comparison
        uint8 x = 7;
        uint8 y = 42;
        
        bool comparison = x < y; // true
        // <, <=, ==, !=, >=, >
        
        uint16 yy = 42;
        bool comparison2 = y == yy; // true
        console.log(comparison2);

        // int16 xx = 42;
        // bool comparison3 = x == xx;

        // Arithmetic
        // x+y, x-y, x*y, x/y, x%y, -x, x**2
        // x/0, x%0 == error
        // Division rounds towards zero
        // 0**0 == 1

        // Bit operators
        /*
        x=42 ->    00101010
        y=6 ->     00000110
        -------------------
        x&y ->     00000010 (=2)
        x|y ->     00101110 (=46)
        x^y ->     00101100 (=44)
        ~x ->      11010101 (=213)
        */

        // Shift operators
        /*
        x=42 ->    00101010 (=42)
        x<<1 ->    01010100 (=84)
        x<<2 ->    10101000 (=168)
        x>>1 ->    00010101 (=21)
        x>>2 ->    00001010 (=10)
        */

        //TODO: quick demo how signed integers behave

    }

    // ## Demo Fixed number
    function fixed_demo() public view {
        // Not implemented yet

        /*
            fixedMxN, ufixedMxN, where M is 8, 16, ..., 256; and N is 0, 1, ..., 80
            fixed = fixed128x18
            ufixed = ufixed128x18
        */

        // Comparison
        // <, <=, ==, !=, >=, >

        // Arithmetic
        // a+b, a-b, a*b, a/b, a%b, -a (no power operator!)
        // a/0, a%0 == error

        uint256 var1 = 25 *10**18; // NOTE: 18 decimal places, so 25.000000000000000000
        
        uint256 var2 = 4 *10**10; // NOTE: 10 decimal places, so 4.0000000000

        uint256 var3 = var1*var2; // NOTE: 28 decimal places.
        var3 = var3 / 10**10;

    }

    // # Demo Static sized byte arrays
    function static_bytes_demo() public view {
        bytes4 bytes_string = "xyzw";
        bytes4 bytes_hex = hex"78797A77"; //xyzw

        // Comparison
        // <, <=, ==, !=, >=, >
        console.log("1", bytes_string == bytes_hex); // true

        bytes2 bytes_short = "ab";
        bytes4 bytes_rightpad = "ab\x00\x00";
        bytes4 bytes_leftpad = "\x00\x00ab";
        
        console.log("right", bytes_short == bytes_rightpad); //true
        console.log("left", bytes_short == bytes_leftpad); //false

        // Bit operators
        // &, |, ^, ~

        // Shift operators
        // <<, >>
        {
            bytes2 bytes_shift = "11"; //00110001, 00110001
            console.log(string(abi.encode(bytes_shift))); //11
            bytes2 bytes_shifted_by1 = bytes_shift<<1; //01100010, 01100010
            console.log(string(abi.encode(bytes_shifted_by1))); //bb
        }

        {
            bytes2 bytes_shift = hex"F133"; //11110001 00110011
            console.log(string(abi.encode(bytes_shift))); //??
            bytes2 bytes_shifted_by1 = bytes_shift>>2; //00111100 01001100
            console.log(string(abi.encode(bytes_shifted_by1))); //<L;
        }

        // Similar to an array
        bytes1 bytes_element = bytes_rightpad[0]; //a;
        // bytes1 bytes_element_inv = bytes_string_rightpad[4];

        uint8 bytes_length = bytes_rightpad.length; //4;

        // bytes (without number suffix) is dynamically sized!
        // static sized byte arrays is copied by value and cannot be modified
        // bytes_short_copy[0] = "A";
    }

    // Demo Address, contract
    function address_demo() public {
        address address_var = 0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF; // 20 bytes, checksum
        address payable address_payable_var = payable(0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF);
        // address address_var_inv = 0x11113a6d3569DF655070DEd06cb7A1b2Ccd1D3AF;

        // Since 0.6, you need explicit conversion
        // bytes20 bytes_var = 0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF;
        bytes20 bytes_var = bytes20(0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF);

        // uint160 int_var = 0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF;
        uint160 int_var = uint160(0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF);

        // Operators
        // ==, !=, (<, <=, >=, >)

        // Members - ETH related
        uint256 address_balance = address_var.balance;
        uint256 address_payable_balance = address_payable_var.balance;

        // address_var.transfer(10);
        //address_payable_var.transfer(10);
        // bool success = address_var.send(10);
        //bool send_success = address_payable_var.send(10);
        // transfer reverts, send returns False

        TestContract testContract = new TestContract();
        TestContractReceive testContractReceive = new TestContractReceive();

        address tC_address = address(testContract);
        address tCR_address = address(testContractReceive);

        // address payable tC_address_payable = payable(testContract);
        address payable tCR_address_payable = payable(testContractReceive);

        address payable tC_address_payable2 = payable(tC_address);
        address payable tCR_address_payable2 = payable(tCR_address);

        // Members - low level call
        // call, delegatecall, staticcall
        //uint8 result1 = testContract.test{value: 0, gas: 100000}();
        //console.log(result1);
        //(bool call_success, bytes memory returnBytes) = tC_address.call{value: 0, gas: 100000}(abi.encodeWithSignature("test()"));
        //uint8 result2 = abi.decode(returnBytes, (uint8));
        //console.log(result2);

        // send, transfer or call
        // 2300 eth limit

        // Members - code
        bytes memory code = tC_address.code;
        bytes32 codehash = tC_address.codehash;
        console.log(code.length);
        console.log(iToHex(code));
        bytes memory creation_code = type(TestContract).creationCode;
        console.log(creation_code.length);
        console.log(iToHex(creation_code));
    }
    function iToHex(bytes memory buffer) public pure returns (string memory) {

        // Fixed buffer size for hexadecimal convertion
        bytes memory converted = new bytes(buffer.length * 2);

        bytes memory _base = "0123456789abcdef";

        for (uint256 i = 0; i < buffer.length; i++) {
            converted[i * 2] = _base[uint8(buffer[i]) / _base.length];
            converted[i * 2 + 1] = _base[uint8(buffer[i]) % _base.length];
        }

        return string(abi.encodePacked("0x", converted));
    }

    // # Compound
    struct StructType {
        address addr;
        uint128 number;
    }
    StructType struct_variable;

    type UFixed256x18 is uint256;
    UFixed256x18 user_defined_type_variable;

    // Demo Enum
    enum Status { DRAFT, SENT, DELIVERED }

    function enum_demo() public pure {
        Status enum_var; // DRAFT
        Status enum_var2 = Status.SENT; // SENT
        Status enum_var3 = Status(2); // DELIVERED
    }

    // # Dynamic
    int[5] int_array_variable;
    int[] int_dynamic_array_variable;
    bytes bytes_dynamic_variable;
    string string_variable;
    mapping(address => uint128) mapping_variable;
}