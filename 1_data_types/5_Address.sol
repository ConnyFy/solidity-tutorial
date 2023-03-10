// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract AddressDemo {
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
}
