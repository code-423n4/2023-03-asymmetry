// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "./IDerivativeMock.sol";
import "../interfaces/frax/IsFrxEth.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../interfaces/curve/IFrxEthEthPool.sol";
import "../SafEth/derivatives/SfrxEth.sol";

/// @title Derivative contract for testing contract upgrades
/// @author Asymmetry Finance
contract DerivativeMock is SfrxEth {
    /**
        @notice - New function to test upgrading a contract and using new functionality
        */
    function withdrawAll() public onlyOwner {
        IsFrxEth(SFRX_ETH_ADDRESS).redeem(
            balance(),
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
        IFrxEthEthPool(FRX_ETH_CRV_POOL_ADDRESS).exchange(
            1,
            0,
            frxEthBalance,
            0
        );
        // solhint-disable-next-line
        (bool sent, ) = address(msg.sender).call{value: address(this).balance}(
            ""
        );
        require(sent, "Failed to send Ether");
    }
}
