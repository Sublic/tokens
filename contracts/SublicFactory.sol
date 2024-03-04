// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import '@cryptoalgebra/integral-core/contracts/interfaces/IAlgebraFactory.sol';
import '@cryptoalgebra/integral-periphery/contracts/interfaces/INonfungiblePositionManager.sol';

import "./interfaces/IAlgebraPoolState.sol";
import "./SwapMultihop.sol";
import "./SubSublic.sol";

import "./interfaces/IMediaFactory.sol";

import './helpers/AdminAccess.sol';

import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract SublicFactory is SwapMultihop, AdminAccess {

    using SafeERC20 for IERC20;

    /* ========== CONSTANTS ========== */
    address public immutable treasury = 0x03154a61eb5283C76a8F73d9De717A86aAbE1703;
    IAlgebraFactory public immutable factory;
    INonfungiblePositionManager public positionManager;
    IMediaFactory public mediaFactory;

    /* ========== STATE VARIABLES ========== */
    mapping(string => address) public vaultAddresses;
    IAlgebraPoolState public sublicUSDCPool;
    uint256 public subscriptionPrice = 10000000000000000000;

    /* ========== CONSTRUCTOR ========== */

    constructor(
        IAlgebraFactory _factory,
        INonfungiblePositionManager _positionManager,
        ISwapRouter _swapRouter,
        IMediaFactory _mediaFactory
    ) AdminAccess(msg.sender) {
        factory = _factory;
        positionManager = _positionManager;
        mediaFactory = _mediaFactory;
        setSwapRouter(_swapRouter);
        IERC20(SUBLIC).approve(address(positionManager), 99999999999999999999999999999000);
    }

    /* ========== USER FUNCTIONS ========== */

    function createSubscriptionToken(
        string memory _name,
        string memory _symbol
    ) external returns (address newToken)  {
        newToken = address(new SubSublic(_name, _symbol, msg.sender));
        IERC20(newToken).approve(address(positionManager), 99999999999999999999999999999000);
        address token0;
        address token1;
        (token0, token1) = newToken < SUBLIC ? (newToken, SUBLIC) : (SUBLIC, newToken);
        address pool = positionManager.createAndInitializePoolIfNecessary{value: 0}(
            token0,
            token1,
            79228162514264337593543950336
        );
        INonfungiblePositionManager.MintParams memory params =
            INonfungiblePositionManager.MintParams({
                token0: token0,
                token1: token1,
                tickLower: -60,
                tickUpper: 60,
                amount0Desired: 10000000000000000000000000,
                amount1Desired: 10000000000000000000000000,
                amount0Min: 10000000000000000000000000,
                amount1Min: 10000000000000000000000000,
                recipient: treasury,
                deadline: block.timestamp + 10000
            });
        positionManager.mint{value: 0}(params);
        emit NewSubscriptionTokenCreated(newToken, pool);
    }

    function buySubscriptionWithUSDC(
        uint256 amountIn, 
        bytes32 mediaId
    ) external {
        address token = mediaFactory.resources(mediaId).token;
        swapExactInputMultihop(amountIn, token);
        checkTokensAndGrantSubscriptionOfEnough(msg.sender, token, mediaId);
    }

    function checkTokensAndGrantSubscriptionOfEnough(
        address user,
        address token,
        bytes32 mediaId
    ) public {
        if (IERC20(token).balanceOf(user) > subscriptionPrice) {
            mediaFactory.addToGroup(user, mediaId);
        }
    }


    /* ========== VIEWS ========== */

    function getExpectedPrice(
        address newToken
    ) public view returns (uint160 sqrtPrice) {
        // pool = IAlgebraFactory(factory).poolByPair(token0, token1);
        // uint160 sqrtPriceUSDCSublic = getX96Price(token0, token1);
        (uint160 sqrtPriceUSDCSublic, , , , , ,) = sublicUSDCPool.safelyGetStateOfAMM();
    }

    function getX96Price(
        address token0,
        address token1
    ) public view returns (uint160 sqrtPrice) {
        address pool = factory.poolByPair(token0, token1);
        (uint160 sqrtPrice, , , , , ,) = IAlgebraPoolState(pool).safelyGetStateOfAMM();
    }

    function sqrt(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    /* ========== ADMIN FUNCTIONS ========== */

    function setSublicUSDCPool(IAlgebraPoolState newPool) external onlyAdminOrOwner() {
        sublicUSDCPool = newPool;
        emit SublicUSDCPoolUpdated(address(newPool));
    }

    function setMediaFactory(IMediaFactory newFactory) external onlyAdminOrOwner() {
        mediaFactory = newFactory;
        emit MediaFactoryUpdated(address(newFactory));
    }

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

    /* ========== EVENTS ========== */

    event NewSubscriptionTokenCreated(address indexed token, address indexed pool);
    event SublicUSDCPoolUpdated(address indexed pool);
    event MediaFactoryUpdated(address indexed pool);
}
