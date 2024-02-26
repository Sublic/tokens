// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.8.20;

import '@cryptoalgebra/integral-periphery/contracts/interfaces/ISwapRouter.sol';
import '@cryptoalgebra/integral-periphery/contracts/libraries/TransferHelper.sol';

contract SimpleSwap {

    address public owner;

    ISwapRouter public swapRouter;
    address public USDC = 0xF41D41BcCCeD504fe9FC4625f33034AaC7a60c11;
    
    constructor(
        ISwapRouter _router
    ) {
        owner = msg.sender;
        swapRouter = _router;
    }

    function setRouter(ISwapRouter _swapRouter) external {
        require(msg.sender == owner);
        swapRouter = _swapRouter;
    }

    function setUSDC(address _usdc) external {
        require(msg.sender == owner);
        USDC = _usdc;
    }
    
    function swapUSDCForToken(
        address token,
        uint256 amountIn
    ) external returns (uint256 amountOut) {

        // Transfer the specified amount of USDC to this contract.
        TransferHelper.safeTransferFrom(USDC, msg.sender, address(this), amountIn);
        // Approve the router to spend USDC.
        TransferHelper.safeApprove(USDC, address(swapRouter), amountIn);
        // Note: To use this example, you should explicitly set slippage limits, omitting for simplicity
        // Calculate min output
        uint minOut = 0;  
        // Calculate price limit
        uint160 priceLimit = 0;  
        // Create the params that will be used to execute the swap
        ISwapRouter.ExactInputSingleParams memory params =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: USDC,
                tokenOut: token,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: minOut,
                limitSqrtPrice: priceLimit
            });
        // The call to `exactInputSingle` executes the swap.
        amountOut = swapRouter.exactInputSingle(params);
    }
}
