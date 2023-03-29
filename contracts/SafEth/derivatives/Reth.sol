// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../../interfaces/IDerivative.sol";
import "../../interfaces/frax/IsFrxEth.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../../interfaces/rocketpool/RocketStorageInterface.sol";
import "../../interfaces/rocketpool/RocketTokenRETHInterface.sol";
import "../../interfaces/rocketpool/RocketDepositPoolInterface.sol";
import "../../interfaces/rocketpool/RocketDAOProtocolSettingsDepositInterface.sol";
import "../../interfaces/IWETH.sol";
import "../../interfaces/uniswap/ISwapRouter.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "../../interfaces/uniswap/IUniswapV3Factory.sol";
import "../../interfaces/uniswap/IUniswapV3Pool.sol";

/// @title Derivative contract for rETH
/// @author Asymmetry Finance
contract Reth is IDerivative, Initializable, OwnableUpgradeable {
    address public immutable ROCKET_STORAGE_ADDRESS;
    address public immutable W_ETH_ADDRESS;
    address public immutable UNISWAP_ROUTER;
    address public immutable UNI_V3_FACTORY;

    uint256 public maxSlippage;

    // As recommended by https://docs.openzeppelin.com/upgrades-plugins/1.x/writing-upgradeable
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor(
        address _rocketStorageAddress,
        address _wethAddress,
        address _uniswapRouter,
        address _uniV3Factory
    ) {
        ROCKET_STORAGE_ADDRESS = _rocketStorageAddress;
        W_ETH_ADDRESS = _wethAddress;
        UNISWAP_ROUTER = _uniswapRouter;
        UNI_V3_FACTORY = _uniV3Factory;
        _disableInitializers();
    }

    /**
        @notice - Function to initialize values for the contracts
        @dev - This replaces the constructor for upgradeable contracts
        @param _owner - owner of the contract which handles stake/unstake
    */
    function initialize(address _owner) external initializer {
        _transferOwnership(_owner);
        maxSlippage = (1 * 10 ** 16); // 1%
    }

    /**
        @notice - Return derivative name
    */
    function name() public pure returns (string memory) {
        return "RocketPool";
    }

    /**
        @notice - Owner only function to set max slippage for derivative
        @param _slippage - new slippage amount in wei
    */
    function setMaxSlippage(uint256 _slippage) external onlyOwner {
        require(_slippage <= 10**18, "Max slippage should be less than or equal to 1");
        maxSlippage = _slippage;
    }

    /**
        @notice - Get rETH address
        @dev - per RocketPool Docs query addresses each time it is used
     */
    function rethAddress() private view returns (address) {
        return
            RocketStorageInterface(ROCKET_STORAGE_ADDRESS).getAddress(
                keccak256(
                    abi.encodePacked("contract.address", "rocketTokenRETH")
                )
            );
    }

    /**
        @notice - Swap tokens through Uniswap
        @param _tokenIn - token to swap from
        @param _tokenOut - token to swap to
        @param _poolFee - pool fee for particular swap
        @param _amountIn - amount of token to swap from
