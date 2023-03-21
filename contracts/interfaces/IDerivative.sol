// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IDerivative {
    /// Returns human readable identifier string
    function name() external pure returns (string memory);

    /// buys the underlying derivative for this contract
    function deposit() external payable returns (uint256);

    /// sells the underlying derivative for this contract & sends user eth
    function withdraw(uint256 amount) external;

    /// Estimated price per derivative when depositing amount
    function ethPerDerivative(uint256 amount) external view returns (uint256);

    /// underlying derivative balance held by this contract
    function balance() external view returns (uint256);

    /// Maximum acceptable slippage when buying/selling underlying derivative
    function setMaxSlippage(uint256 slippage) external;
}
