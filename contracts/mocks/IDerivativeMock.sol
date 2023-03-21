// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IDerivativeMock {
    function deposit() external payable returns (uint256);

    function withdraw(uint amount) external;

    function ethPerDerivative(uint amount) external view returns (uint256);

    function balance() external view returns (uint256);

    function withdrawAll() external;

    function setMaxSlippage(uint256 slippage) external;
}
