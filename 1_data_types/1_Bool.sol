// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract BoolDemo {
    function demo() public view {
        bool variable; // default value is false
        bool variable_false = false;
        bool variable_true = true;

        // Operators
        bool negate = !variable_false; // true
        bool logical_and = variable_false && variable_true; // false
        bool logical_or = variable_false || variable_true; // true

        bool equal = variable_false == variable_true; // false
        bool equal2 = variable == variable_false; // true
        bool not_equal = variable_false != variable_true; // true

        // Logical operators apply short-circuit rules,
        // so if the value of the operator is already determined
        // by the first operand, the second won't be evaluated.
        // bool_f() returns false, bool_t() returns true
        bool and_circuit1 = bool_f() && bool_t(); // Only bool_f is evaluated
        bool and_circuit2 = bool_t() && bool_f(); // Both of them evaluated
        bool or_circuit1 = bool_f() || bool_t(); // Both of them evaluated
        bool or_circuit2 = bool_t() || bool_f(); // Only bool_t is evaluated
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
