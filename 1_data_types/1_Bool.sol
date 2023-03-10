// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract BoolDemo {
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
}
