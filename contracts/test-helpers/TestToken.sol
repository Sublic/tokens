// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestToken is ERC20 {

    constructor() ERC20("Token", "Token") {
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
