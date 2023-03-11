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
		function test() public payable returns (uint8) {
        return 1;
    }
}

contract AddressDemo {
    constructor() payable {}

    function demo() public {
        // 20 bytes, needs to pass checksum
        address address_var = 0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF;
        // address address_var_inv = 0x11113a6d3569DF655070DEd06cb7A1b2Ccd1D3AF; // Does not pass checksum

        // address payable to distinguish accounts where you not supposed to send ether from the ones where you can.
        address payable address_payable_var = payable(0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF);

        // Since 0.6, you need explicit conversion
        // bytes20 bytes_var = 0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF;
        bytes20 bytes_var = bytes20(0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF);

        // uint160 int_var = 0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF;
        uint160 int_var = uint160(0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF);

        // Operators
        // ==, != works the same way as at ingeres and bytes
        // There are also (<, <=, >=, >) but they are not really used

        // Members - ETH related
        // Get balance
        uint256 address_balance = address_var.balance;
        uint256 address_payable_balance = address_payable_var.balance;

        // Send ether
        // address_var.transfer(10); // Invalid as address_var is not payable
        address_payable_var.transfer(10);
        // bool success = address_var.send(10); // Invalid as address_var is not payable
        bool send_success = address_payable_var.send(10);
        // transfer reverts, send returns False

        // Contracts define their own type
        TestContract testContract = new TestContract();
        TestContractReceive testContractReceive = new TestContractReceive();

        // Explicit conversion TO address
        address tC_address = address(testContract);
        address tCR_address = address(testContractReceive);

        // address payable tC_address_payable = payable(testContract); // Invalid, TestContract does not have a receive or a payable fallback function
        address payable tCR_address_payable = payable(testContractReceive);

        // Attention! converting address to payable address is possible, but this will bypass checks.
        address payable tC_address_payable2 = payable(tC_address);
        address payable tCR_address_payable2 = payable(tCR_address);

        // Explicit conversoin FROM address
        TestContract testContract2 = TestContract(tC_address);
        TestContractReceive testContractReceive2 = TestContractReceive(payable(tCR_address));
        TestContractReceive testContractReceive3 = TestContractReceive(tCR_address_payable);

        // Members - low level call
        // call, delegatecall, staticcall
        // They break the type-safety
        {
            uint8 result1 = testContract.test();
            console.log(result1); // Outputs: 1
            (bool call_success, bytes memory returnBytes) = tC_address.call(abi.encodeWithSignature("test()"));
            uint8 result2 = abi.decode(returnBytes, (uint8));
            console.log(result2); // Outputs: 1
        }

        // Sending ether, limiting gas
        {
            uint8 result1 = testContract.test{value: 0, gas: 100000}();
            (bool call_success, bytes memory returnBytes) = tC_address.call{value: 0, gas: 100000}(abi.encodeWithSignature("test()"));
        }

        /*
        send, transfer or call
        https://solidity-by-example.org/sending-ether/
        You can send Ether to other contracts by
        - transfer (2300 gas, throws error)
        - send (2300 gas, returns bool)
        - call (forward all gas or set gas, returns bool)

        call in combination with re-entrancy guard is the recommended method to use after December 2019.

        Guard against re-entrancy by
        - making all state changes before calling other contracts
        - using re-entrancy guard modifier
        */

        // Members - code
        // tC_address.codehash is keccak256(tC_address.code) but cheaper
        // codehash can be used fo check if the contract code has changed
        bytes memory code = tC_address.code;
        bytes32 codehash = tC_address.codehash;

        // tC_address.code is the so-called runtime code.
        // Its very similar but not the same as the creation code which includes the constructor logic too.
        // If you click the ABI button in Remix after compilation you get the creation code.
        // In solidity you can get creation code by type(TestContract).creationCode 
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
