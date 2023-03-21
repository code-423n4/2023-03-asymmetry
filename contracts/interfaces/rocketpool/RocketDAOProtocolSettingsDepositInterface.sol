// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface RocketDAOProtocolSettingsDepositInterface {
    function getDepositEnabled() external view returns (bool);

    function getAssignDepositsEnabled() external view returns (bool);

    function getMinimumDeposit() external view returns (uint256);

    function getMaximumDepositPoolSize() external view returns (uint256);

    function getMaximumDepositAssignments() external view returns (uint256);

    function getDepositFee() external view returns (uint256);
}
