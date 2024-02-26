// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';

import './helpers/AdminAccess.sol';

import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract SubSublic is ERC20, ERC20Burnable, AdminAccess, ReentrancyGuard {

    /* ========== CONSTANTS ========== */

    /* ========== STRUCTS ========== */

    /* ========== STATE VARIABLES ========== */

    /* ========== CONSTRUCTOR ========== */

    constructor(
        string memory _name, 
        string memory _symbol,
        address _admin
    ) ERC20(_name, _symbol) AdminAccess(_admin) {
        _mint(msg.sender, 100_000_000_000 * 10**18);
    }

    /* ========== USER FUNCTIONS ========== */

    /* ========== INTERNAL FUNCTIONS ========== */

    /* ========== ADMIN FUNCTIONS ========== */

    function withdrawToken(
        IERC20 _tokenToWithdraw, 
        address _to, 
        uint _amount
    ) external onlyAdminOrOwner {
        require(_tokenToWithdraw.transfer(_to, _amount));
    }

    function withdrawEth(
        address payable _to, 
        uint _amount
    ) public onlyAdminOrOwner {
        (bool success, ) = _to.call{value: _amount}("");
        require(success, "Failed to send Ether");
    }
}
