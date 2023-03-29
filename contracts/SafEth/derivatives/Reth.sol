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
    address public constant ROCKET_STORAGE_ADDRESS =
        0x1d8f8f00cfa6758d7bE78336684788Fb0ee0Fa46;
    address public constant W_ETH_ADDRESS =
        0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public constant UNISWAP_ROUTER =
        0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45;
    address public constant UNI_V3_FACTORY =
        0x1F98431c8aD98523631AE4a59f267346ea31F984;

    uint256 public maxSlippage;

    // As recommended by https://docs.openzeppelin.com/upgrades-plugins/1.x/writing-upgradeable
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
        @notice - Function to initialize values for the contracts
        @dev - This replaces the constructor for upgradeable contracts
        @param _owner - owner of the contract which handles stake/unstake
    */
    function initialize(address _owner) external initializer {
        _transferOwnership(_owner);
   uint256 constant private MAX_SLIPPAGE = 10000; // 1% represented as parts per million (PPM)
    uint256 private maxSlippage = MAX_SLIPPAGE;

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
        maxSlippage = _slippage;
    }

    /**
        @notice - Get rETH address
        @dev - per RocketPool Docs query addresses each time it is used
     */
   function rethAddress() private view returns (address) {
    address storageAddress = RocketStorageInterface(ROCKET_STORAGE_ADDRESS).getAddress(keccak256(abi.encodePacked("contract.address", "rocketTokenRETH")));
    require(storageAddress != address(0), "RETH address not set in storage");
    require(Address.isContract(storageAddress), "RETH address is not a contract");
    return storageAddress;
}


    /**
        @notice - Swap tokens through Uniswap
        @param _tokenIn - token to swap from
        @param _tokenOut - token to swap to
        @param _poolFee - pool fee for particular swap
        @param _amountIn - amount of token to swap from
        @param _minOut - minimum amount of token to receive (slippage)
     */
   function swapExactInputSingleHop(
    address _tokenIn,
    address _tokenOut,
    uint24 _poolFee,
    uint256 _amountIn,
    uint256 _minOut
   ) private returns (uint256 amountOut) {
    require(_tokenIn != address(0), "Invalid input token address");
    require(_tokenOut != address(0), "Invalid output token address");

       require(IERC20(_tokenIn).totalSupply() > 0, "Invalid input token");
       require(IERC20(_tokenOut).totalSupply() > 0, "Invalid output token");

    require(_amountIn > 0, "Amount in must be greater than zero");
    require(_minOut > 0, "Minimum output must be greater than zero");

    IERC20(_tokenIn).approve(UNISWAP_ROUTER, _amountIn);

    ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
        .ExactInputSingleParams({
            tokenIn: _tokenIn,
            tokenOut: _tokenOut,
            fee: _poolFee,
            recipient: address(this),
            amountIn: _amountIn,
            amountOutMinimum: _minOut,
            sqrtPriceLimitX96: 0
        });

    uint256 balanceBefore = IERC20(_tokenOut).balanceOf(address(this));

    amountOut = ISwapRouter(UNISWAP_ROUTER).exactInputSingle(params);

    require(
        IERC20(_tokenOut).balanceOf(address(this)) - balanceBefore >= _minOut,
        "Received less than minimum output"
    );
}


    /**
        @notice - Convert derivative into ETH
     */
    function withdraw(uint256 amount) external onlyOwner {
        RocketTokenRETHInterface(rethAddress()).burn(amount);
        // solhint-disable-next-line
        (bool sent, ) = address(msg.sender).call{value: address(this).balance}(
            ""
        );
        require(sent, "Failed to send Ether");
    }

    /**
        @notice - Check whether or not rETH deposit pool has room users amount
        @param _amount - amount that will be deposited
     */
function poolCanDeposit(uint256 _amount) private view returns (bool) {
    address rocketDepositPoolAddress = RocketStorageInterface(
        ROCKET_STORAGE_ADDRESS
    ).getAddress(
        keccak256(
            abi.encodePacked("contract.address", "rocketDepositPool")
        )
    );
    RocketDepositPoolInterface rocketDepositPool = RocketDepositPoolInterface(
        rocketDepositPoolAddress
    );
    
    uint256 availableSpace = rocketDepositPool.availableSpace();
    
    return _amount <= availableSpace;
}

    
    try RocketDepositPoolInterface(rocketDepositPoolAddress).getMaxDepositAmount() returns (uint256 maxDeposit) {
        return maxDeposit >= _amount;
    } catch {
        return false;
    }
}

        address rocketProtocolSettingsAddress = RocketStorageInterface(
            ROCKET_STORAGE_ADDRESS
        ).getAddress(
                keccak256(
                    abi.encodePacked(
                        "contract.address",
                        "rocketDAOProtocolSettingsDeposit"
                    )
                )
            );
        RocketDAOProtocolSettingsDepositInterface rocketDAOProtocolSettingsDeposit = RocketDAOProtocolSettingsDepositInterface(
                rocketProtocolSettingsAddress
            );

        return
            rocketDepositPool.getBalance() + _amount <=
            rocketDAOProtocolSettingsDeposit.getMaximumDepositPoolSize() &&
            _amount >= rocketDAOProtocolSettingsDeposit.getMinimumDeposit();
    }

    /**
        @notice - Deposit into derivative
        @dev - will either get rETH on exchange or deposit into contract depending on availability
     */
    function deposit() external payable onlyOwner returns (uint256) {
        // Per RocketPool Docs query addresses each time it is used
        address rocketDepositPoolAddress = RocketStorageInterface(
            ROCKET_STORAGE_ADDRESS
        ).getAddress(
                keccak256(
                    abi.encodePacked("contract.address", "rocketDepositPool")
                )
            );

        RocketDepositPoolInterface rocketDepositPool = RocketDepositPoolInterface(
                rocketDepositPoolAddress
            );

        if (!poolCanDeposit(msg.value)) {
            uint rethPerEth = (10 ** 36) / poolPrice();

            uint256 minOut = ((((rethPerEth * msg.value) / 10 ** 18) *
                ((10 ** 18 - maxSlippage))) / 10 ** 18);

            IWETH(W_ETH_ADDRESS).deposit{value: msg.value}();
            uint256 amountSwapped = swapExactInputSingleHop(
                W_ETH_ADDRESS,
                rethAddress(),
                500,
                msg.value,
                minOut
            );

            return amountSwapped;
        } else {
            address rocketTokenRETHAddress = RocketStorageInterface(
                ROCKET_STORAGE_ADDRESS
            ).getAddress(
                    keccak256(
                        abi.encodePacked("contract.address", "rocketTokenRETH")
                    )
                );
            RocketTokenRETHInterface rocketTokenRETH = RocketTokenRETHInterface(
                rocketTokenRETHAddress
            );
            uint256 rethBalance1 = rocketTokenRETH.balanceOf(address(this));
            rocketDepositPool.deposit{value: msg.value}();
            uint256 rethBalance2 = rocketTokenRETH.balanceOf(address(this));
            require(rethBalance2 > rethBalance1, "No rETH was minted");
            uint256 rethMinted = rethBalance2 - rethBalance1;
            return (rethMinted);
        }
    }

    /**
        @notice - Get price of derivative in terms of ETH
        @dev - we need to pass amount so that it gets price from the same source that it buys or mints the rEth
        @param _amount - amount to check for ETH price
     */
    function ethPerDerivative(uint256 _amount) public view returns (uint256) {
        if (poolCanDeposit(_amount))
            return
                RocketTokenRETHInterface(rethAddress()).getEthValue(10 ** 18);
        else return (poolPrice() * 10 ** 18) / (10 ** 18);
    }

    /**
        @notice - Total derivative balance
     */
    function balance() public view returns (uint256) {
        return IERC20(rethAddress()).balanceOf(address(this));
    }

    /**
        @notice - Price of derivative in liquidity pool
     */
    function poolPrice() private view returns (uint256) {
        address rocketTokenRETHAddress = RocketStorageInterface(
            ROCKET_STORAGE_ADDRESS
        ).getAddress(
                keccak256(
                    abi.encodePacked("contract.address", "rocketTokenRETH")
                )
            );
        IUniswapV3Factory factory = IUniswapV3Factory(UNI_V3_FACTORY);
        IUniswapV3Pool pool = IUniswapV3Pool(
            factory.getPool(rocketTokenRETHAddress, W_ETH_ADDRESS, 500)
        );
        (uint160 sqrtPriceX96, , , , , , ) = pool.slot0();
        return (sqrtPriceX96 * (uint(sqrtPriceX96)) * (1e18)) >> (96 * 2);
    }

    receive() external payable {}
}
