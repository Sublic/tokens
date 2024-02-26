// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract SecondToken0 is ERC20, ERC20Burnable {

    address public owner;

    constructor() ERC20("SecondToken0", "SecondToken0") {
        owner = msg.sender;
        _mint(msg.sender, 100_000_000_000 * 10**18);
    }

    function destroySmartContract(address payable _to) external {
        require(msg.sender == owner, "You are not the owner");
        selfdestruct(_to);
    }
}
