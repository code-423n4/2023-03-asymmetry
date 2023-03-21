// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../../interfaces/IDerivative.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../../interfaces/uniswap/ISwapRouter.sol";
import "../../interfaces/uniswap/IUniswapV3Pool.sol";
import "../../interfaces/IWETH.sol";
import "../../interfaces/stakewise/IStakewiseStaker.sol";

/// @title Derivative contract for sfrxETH
/// @author Asymmetry Finance
/// @dev Stakewise if kindof weird, theres 2 underlying tokens. sEth2 and rEth2.  Both are stable(ish) to eth but you receive rewards in rEth2
/// @dev There is also an "activation period" that applies to larger deposits.
/// @dev This derivative wont be enabled for the initial release
contract StakeWise is IDerivative, Initializable, OwnableUpgradeable {
    address public constant UNISWAP_ROUTER =
        0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45;
    address public constant SETH2 = 0xFe2e637202056d30016725477c5da089Ab0A043A;
    address public constant RETH2 = 0x20BC832ca081b91433ff6c17f85701B6e92486c5;
    address public constant RETH2_SETH2_POOL =
        0xa9ffb27d36901F87f1D0F20773f7072e38C5bfbA;
    address public constant SETH2_WETH_POOL =
        0x7379e81228514a1D2a6Cf7559203998E20598346;
    address public constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public constant STAKER = 0xC874b064f465bdD6411D45734b56fac750Cda29A;

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
        maxSlippage = (1 * 10 ** 16); // 1%
    }

    /**
        @notice - Return derivative name
    */
    function name() public pure returns (string memory) {
        return "StakeWise";
    }

    /**
        @notice - Owner only function to set max slippage for derivative
        @param _slippage - Amount of slippage to set in wei
    */
    function setMaxSlippage(uint256 _slippage) external onlyOwner {
        maxSlippage = _slippage;
    }

    /**
        @notice - Convert derivative into ETH
     */
    function withdraw(uint256 _amount) external onlyOwner {
        sellAllReth2();

        // Theres a chance balance() returns more than they actually have to withdraew because of rEth2/sEth2 price variations
        // if they tried to withdraw more than they have just set it to their balance
        uint256 withdrawAmount;
        if (_amount > IERC20(SETH2).balanceOf(address(this)))
            withdrawAmount = IERC20(SETH2).balanceOf(address(this));
        else withdrawAmount = _amount;
        uint256 wEthReceived = sellSeth2ForWeth(withdrawAmount);
        IWETH(WETH).withdraw(wEthReceived);
        // solhint-disable-next-line
        (bool sent, ) = address(msg.sender).call{value: address(this).balance}(
            ""
        );
        require(sent, "Failed to send Ether");
    }

    /**
        @notice - Deposit into derivative
        @dev - will either get sETH2 on exchange or deposit into contract depending on availability
     */
    function deposit() external payable onlyOwner returns (uint256) {
        if (msg.value > IStakewiseStaker(STAKER).minActivatingDeposit()) {
            // solhint-disable-next-line
            (bool sent, ) = address(msg.sender).call{value: msg.value}("");
            require(sent, "Failed to send Ether");
            return 0;
        }
        uint256 balanceBefore = IERC20(SETH2).balanceOf(address(this));
        IStakewiseStaker(STAKER).stake{value: msg.value}();
        uint256 balanceAfter = IERC20(SETH2).balanceOf(address(this));
        return balanceAfter - balanceBefore;
    }

    /**
        @notice - Get price of derivative in terms of ETH
        @dev - TODO: This should return the rate being used for IStakewiseStaker(staker).stake().
     */
    function ethPerDerivative(uint256 _amount) public view returns (uint256) {
        uint256 wethOutput = estimatedSellSeth2Output(10 ** 18); // we can assume weth is always 1-1 with eth
        return wethOutput;
    }

    /**
        @notice - Total derivative balance
        @dev - This is more like virtualBalance because its estimating total sEth2 holding based on rEth price2
     */
    function balance() public view returns (uint256) {
        // seth2Balance + estimated seth2 value of reth holdings
        return
            IERC20(SETH2).balanceOf(address(this)) +
            estimatedSellReth2Output(IERC20(RETH2).balanceOf(address(this)));
    }

    /**
        @notice - Convert rewards into derivative
     */
    function sellAllReth2() private returns (uint) {
        uint256 rEth2Balance = IERC20(RETH2).balanceOf(address(this));

        if (rEth2Balance == 0) return 0;

        uint256 minOut = (estimatedSellReth2Output(rEth2Balance) *
            (10 ** 18 - maxSlippage)) / 10 ** 18;

        IERC20(RETH2).approve(UNISWAP_ROUTER, rEth2Balance);
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams({
                tokenIn: RETH2,
                tokenOut: SETH2,
                fee: 500,
                recipient: address(this),
                amountIn: rEth2Balance,
                amountOutMinimum: minOut,
                sqrtPriceLimitX96: 0
            });
        return ISwapRouter(UNISWAP_ROUTER).exactInputSingle(params);
    }

    /**
        @notice - How much seth2 we expect to get for a given reth2 input amount
        @dev - how much weth we expect to get for a given seth2 input amount
        @param _amount - amount of sETH2 to sell for wETH
     */
    function sellSeth2ForWeth(uint256 _amount) private returns (uint) {
        IERC20(SETH2).approve(
            UNISWAP_ROUTER,
            IERC20(SETH2).balanceOf(address(this))
        );

        uint256 minOut = (estimatedSellSeth2Output(_amount) *
            (10 ** 18 - maxSlippage)) / 10 ** 18;

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams({
                tokenIn: SETH2,
                tokenOut: WETH,
                fee: 500,
                recipient: address(this),
                amountIn: _amount,
                amountOutMinimum: minOut,
                sqrtPriceLimitX96: 0
            });
        return ISwapRouter(UNISWAP_ROUTER).exactInputSingle(params);
    }

    /**
        @notice - How much seth2 we expect to get for a given reth2 input amount
        @dev - how much weth we expect to get for a given seth2 input amount
        @param _amount - amount of sETH2 to sell for wETH
     */
    function estimatedSellSeth2Output(
        uint256 _amount
    ) private view returns (uint) {
        return (_amount * 10 ** 18) / poolPrice(SETH2_WETH_POOL);
    }

    /**
        @notice - How much seth2 we expect to get for a given reth2 input amount
     */
    function estimatedSellReth2Output(
        uint256 _amount
    ) private view returns (uint) {
        return (_amount * 10 ** 18) / poolPrice(RETH2_SETH2_POOL);
    }

    /**
        @notice - Price of sETH2 in liquidity pool
     */
    function poolPrice(address _poolAddress) private view returns (uint256) {
        IUniswapV3Pool pool = IUniswapV3Pool(_poolAddress);
        (uint160 sqrtPriceX96, , , , , , ) = pool.slot0();
        return (sqrtPriceX96 * (uint(sqrtPriceX96)) * (1e18)) >> (96 * 2);
    }

    receive() external payable {}
}
