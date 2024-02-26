// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

interface ISwapMultihop {
  function swapExactInputMultihop(
        uint256 amountIn,
        address token
    ) external returns (uint256 amountOut);

    function swapExactOutputMultihop(
        uint256 amountOut, 
        uint256 amountInMaximum,
        address token
    ) external returns (uint256 amountIn);
}