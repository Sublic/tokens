// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';

import './helpers/AdminAccess.sol';

import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract SublicToken is AdminAccess, ReentrancyGuard {

    /* ========== CONSTANTS ========== */

    string public name;

    /* ========== STRUCTS ========== */

    /* ========== STATE VARIABLES ========== */

    /* ========== CONSTRUCTOR ========== */

    constructor(
        string memory _name,
        address _admin
    ) AdminAccess(_admin) {
        name = _name;
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
