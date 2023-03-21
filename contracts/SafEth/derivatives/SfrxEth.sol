// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../../interfaces/IDerivative.sol";
import "../../interfaces/frax/IsFrxEth.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../../interfaces/curve/IFrxEthEthPool.sol";
import "../../interfaces/frax/IFrxETHMinter.sol";

/// @title Derivative contract for sfrxETH
/// @author Asymmetry Finance
contract SfrxEth is IDerivative, Initializable, OwnableUpgradeable {
    address public constant SFRX_ETH_ADDRESS =
        0xac3E018457B222d93114458476f3E3416Abbe38F;
    address public constant FRX_ETH_ADDRESS =
        0x5E8422345238F34275888049021821E8E08CAa1f;
    address public constant FRX_ETH_CRV_POOL_ADDRESS =
        0xa1F8A6807c402E4A15ef4EBa36528A3FED24E577;
    address public constant FRX_ETH_MINTER_ADDRESS =
        0xbAFA44EFE7901E04E39Dad13167D089C559c1138;

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
        return "Frax";
    }

    /**
        @notice - Owner only function to set max slippage for derivative
    */
    function setMaxSlippage(uint256 _slippage) external onlyOwner {
        maxSlippage = _slippage;
    }

    /**
        @notice - Owner only function to Convert derivative into ETH
        @dev - Owner is set to SafEth contract
        @param _amount - Amount to withdraw
     */
    function withdraw(uint256 _amount) external onlyOwner {
        IsFrxEth(SFRX_ETH_ADDRESS).redeem(
            _amount,
            address(this),
            address(this)
        );
        uint256 frxEthBalance = IERC20(FRX_ETH_ADDRESS).balanceOf(
            address(this)
        );
        IsFrxEth(FRX_ETH_ADDRESS).approve(
            FRX_ETH_CRV_POOL_ADDRESS,
            frxEthBalance
        );

        uint256 minOut = (((ethPerDerivative(_amount) * _amount) / 10 ** 18) *
            (10 ** 18 - maxSlippage)) / 10 ** 18;

        IFrxEthEthPool(FRX_ETH_CRV_POOL_ADDRESS).exchange(
            1,
            0,
            frxEthBalance,
            minOut
        );
        // solhint-disable-next-line
        (bool sent, ) = address(msg.sender).call{value: address(this).balance}(
            ""
        );
        require(sent, "Failed to send Ether");
    }

    /**
        @notice - Owner only function to Deposit into derivative
        @dev - Owner is set to SafEth contract
     */
    function deposit() external payable onlyOwner returns (uint256) {
        IFrxETHMinter frxETHMinterContract = IFrxETHMinter(
            FRX_ETH_MINTER_ADDRESS
        );
        uint256 sfrxBalancePre = IERC20(SFRX_ETH_ADDRESS).balanceOf(
            address(this)
        );
        frxETHMinterContract.submitAndDeposit{value: msg.value}(address(this));
        uint256 sfrxBalancePost = IERC20(SFRX_ETH_ADDRESS).balanceOf(
            address(this)
        );
        return sfrxBalancePost - sfrxBalancePre;
    }

    /**
        @notice - Get price of derivative in terms of ETH
     */
    function ethPerDerivative(uint256 _amount) public view returns (uint256) {
        uint256 frxAmount = IsFrxEth(SFRX_ETH_ADDRESS).convertToAssets(
            10 ** 18
        );
        return ((10 ** 18 * frxAmount) /
            IFrxEthEthPool(FRX_ETH_CRV_POOL_ADDRESS).price_oracle());
    }

    /**
        @notice - Total derivative balance
     */
    function balance() public view returns (uint256) {
        return IERC20(SFRX_ETH_ADDRESS).balanceOf(address(this));
    }

    receive() external payable {}
}
