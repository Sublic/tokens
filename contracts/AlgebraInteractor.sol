// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SublicV0 {
    address public pairAddress;
    address public sublicLiquidityToken;

    constructor() {
    }

    function depositLiquidity(
        address _pairAddress, 
        address _sublicAmount, 
        uint _liquidTokenAmount
    ) external {
        // require(_tokenToWithdraw.transfer(_to, _amount));
    }
}
