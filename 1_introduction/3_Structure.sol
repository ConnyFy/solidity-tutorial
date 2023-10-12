/*
- Solidity source code files use the .sol extension.
- At the top of each source file we have the SPDX license identifier. It is actually an optional line, but consider this. Smart contracts build on trust. And trust can be established the easiest if the source code is public.
Open-sourcing code can cause legal problems regarding copyrights, ownership of intellectual properties etc.
That is why we can insert this line to have a machine-readable identifier inside the metadata of the contract's bytecode.
Of course if you do not want to use MIT - which technically allows any kind of usage of my code - you can use other licenses, but MIT is recommended one especially for small projects.
- After the SPDX identifier, we usually have the pragma directives. These directives are used to set and give information to the compiler.
The most common one is `pragma solidity` that specifies the EVM versions the code is compatible with. The way it works is the compiler checks your source files and compares these version restrictions to its target EVM version, and if there is a conflict, the build will fail.
You can also set other kind of information like the version of the ABI encoder but they are not used very much.
- Next up, we have our imports. There are several ways to import other files.
    - `import "filename";` that imports all global symbols from filename into the current global scope. However, this is usually not the preferred way as it unnecessarily populates the global space, and can cause identifier conflicts.
    - `import * as symbolName from "filename";` is a much more sophisticated format, as it imports every global symbol as symbolName.symbol.
        - This can be shortened into `import "filename" as symbolName;`
    - `import { symbol } from "filename";` imports only symbol from "filename" at puts it into the global scope.
        - If you would have an indentifier conflict, you can rename the symbol with `import { symbol as alias } from "filename";`.

- Then, we arrive to the grand attraction: the contract. Contracts in Solidity are similar to classes in object-oriented languages. They can contain fields as state variables, methods as functions, they can even define their own events, errors, function modifiers, and not but not least, they can inherit from other contracts.
*/
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract ContractName {
    /*
        Variables are declared with `typename variablename`
    */
    bool stateVariable;

    /*
        Functions are declared with the `function` keyword, followed by the function's name. They can have parameters, visibility and mutability modifiers, return value etc. We will cover these later on. 
    */
    function functionName() public pure returns (bool) {
        bool localVariable = false;
        return localVariable;
    }
}
