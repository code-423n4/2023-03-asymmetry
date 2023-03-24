# Asymmetry Finance contest details

- Total Prize Pool: $49,200 USDC
  - HM awards: $25,500 USDC 
  - QA report awards: $3,000 USDC
  - Gas report awards: $1,500 USDC 
  - Lookout awards: $2,400 USDC
  - Judge awards: $6,300 USDC
  - Scout awards: $500 USDC
  - Mitigation review contest: $10,000 USDC
- Join [C4 Discord](https://discord.gg/code4rena) to register
- Submit findings [using the C4 form](https://code4rena.com/contests/2023-03-asymmetry-contest/submit)
- [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
- Starts March 24, 2023 20:00 UTC
- Ends March 30, 2023 20:00 UTC

## Automated Findings / Publicly Known Issues

Automated findings output for the contest can be found [here](https://gist.github.com/muratkurtulus/c7a89b0ef411b5b96dd8af23ccd95dc4).

_Note for C4 wardens: Anything included in the automated findings output is considered a publicly known issue and is ineligible for awards._

# Overview

SafEth is a smart contract suite developed by [Asymmetry Finance](https://www.asymmetry.finance/) that enables a user to diversify their ETH into staked derivatives.
Currently the supported staked derivatives are [wstETH](https://lido.fi/), [rETH](https://rocketpool.net/), and [sfrxETH](https://docs.frax.finance/frax-ether/frxeth-and-sfrxeth).

The goal of SafEth is to help decentralize the liquid staked derivatives on the Ethereum blockchain. This is done by enabling and easy access to diversification of derivatives.

In the future, SafEth will be used in conjunction with other smart contracts to allow the staking of SafEth to gain higher yield.


![image](https://user-images.githubusercontent.com/11018468/227099513-cf9ce9cd-083e-41fd-adab-49373f122e42.png)


There are two main functions a user will interact with and they both reside in [SafEth.sol](https://github.com/code-423n4/2023-03-asymmetry/tree/main/contracts/SafEth/SafEth.sol)
- `stake`: The main entry-point to the protocol.  Will take the users `ETH` and convert it into various derivatives based on their weights and mint an amount of `safETH` that represents a percentage of the total assets in the system.
- `unstake`: The main exit-point from the protocol.  Will burn the users `safETH` and convert a percentage of each derivative to give the user their ETH back including any of the rewards their derivatives have accrued over the time since they started staking.

## Protocol Contracts:

[SafEth](https://github.com/code-423n4/2023-03-asymmetry/tree/main/contracts/SafEth/SafEth.sol): An upgradeable ERC20 contract that handles the conversion between ETH and whatever derivatives that are implemented

## Derivative Contracts:

[Reth](https://github.com/code-423n4/2023-03-asymmetry/tree/main/contracts/SafEth/derivatives/Reth.sol) -
[SfrxEth](https://github.com/code-423n4/2023-03-asymmetry/tree/main/contracts/SafEth/derivatives/SfrxEth.sol) -
[WstEth](https://github.com/code-423n4/2023-03-asymmetry/tree/main/contracts/SafEth/derivatives/WstEth.sol)

These contracts handle all business logic to deposit and withdraw through their specific protocols. These will change after Shanghai is released when withdrawing from the beacon chain is enabled

## Scope

### Files in scope

| File                                                                                                                                                                                                             |      [SLOC](#nowhere "(nSLOC, SLOC, Lines)")       | Description and [Coverage](#nowhere "(Lines hit / Total)")                                                  | Libraries                                                |
| :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------: | :---------------------------------------------------------------------------------------------------------- | :------------------------------------------------------- |
| _Contracts (4)_                                                                                                                                                                                                  |
| [contracts/SafEth/derivatives/WstEth.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/derivatives/WstEth.sol) [💰](#nowhere "Payable Functions")                                  |   [54](#nowhere "(nSLOC:54, SLOC:54, Lines:98)")   | Derivative contract for wstETH, &nbsp;&nbsp;[95.00%](#nowhere "(Hit:19 / Total:20)")                        | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [contracts/SafEth/derivatives/SfrxEth.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/derivatives/SfrxEth.sol) [💰](#nowhere "Payable Functions")                                |  [81](#nowhere "(nSLOC:81, SLOC:81, Lines:127)")   | Derivative contract for sfrxETH, &nbsp;&nbsp;[95.00%](#nowhere "(Hit:19 / Total:20)")                       | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [contracts/SafEth/SafEth.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol) [💰](#nowhere "Payable Functions")                                                          | [156](#nowhere "(nSLOC:144, SLOC:156, Lines:247)") | This contract is the main staking/unstaking contract, &nbsp;&nbsp;[100.00%](#nowhere "(Hit:74 / Total:74)") | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [contracts/SafEth/derivatives/Reth.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/derivatives/Reth.sol) [💰](#nowhere "Payable Functions") [🧮](#nowhere "Uses Hash-Functions") | [169](#nowhere "(nSLOC:163, SLOC:169, Lines:245)") | Derivative contract for rETH, &nbsp;&nbsp;[97.56%](#nowhere "(Hit:40 / Total:41)")                          | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| Total (over 4 files):                                                                                                                                                                                            | [460](#nowhere "(nSLOC:442, SLOC:460, Lines:717)") | [98.06%](#nowhere "Hit:152 / Total:155")                                                                    |

### All other source contracts (not in scope)

| File                                                                                                                                                                                                                          |       [SLOC](#nowhere "(nSLOC, SLOC, Lines)")       | Description and [Coverage](#nowhere "(Lines hit / Total)") | Libraries                                                |
| :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------: | :--------------------------------------------------------- | :------------------------------------------------------- |
| _Contracts (1)_                                                                                                                                                                                                               |
| [contracts/SafEth/SafEthStorage.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEthStorage.sol)                                                                                            |   [12](#nowhere "(nSLOC:12, SLOC:12, Lines:24)")    | -                                                          |                                                          |
| _Abstracts (2)_                                                                                                                                                                                                               |
| [contracts/interfaces/lido/IstETH.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/lido/IstETH.sol)                                                                                        |     [5](#nowhere "(nSLOC:5, SLOC:5, Lines:8)")      | -                                                          | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [contracts/interfaces/lido/IWStETH.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/lido/IWStETH.sol)                                                                                      |    [12](#nowhere "(nSLOC:8, SLOC:12, Lines:18)")    | -                                                          | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| _Interfaces (29)_                                                                                                                                                                                                             |
| [contracts/interfaces/IWETH.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/IWETH.sol) [💰](#nowhere "Payable Functions")                                                                 |     [6](#nowhere "(nSLOC:6, SLOC:6, Lines:10)")     | -                                                          | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [contracts/interfaces/frax/IFrxETHMinter.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/frax/IFrxETHMinter.sol) [💰](#nowhere "Payable Functions")                                       |     [6](#nowhere "(nSLOC:4, SLOC:6, Lines:10)")     | -                                                          |                                                          |
| [contracts/interfaces/IDerivative.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/IDerivative.sol) [💰](#nowhere "Payable Functions")                                                     |     [9](#nowhere "(nSLOC:9, SLOC:9, Lines:22)")     | -                                                          |                                                          |
| [contracts/interfaces/curve/IStEthEthPool.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/curve/IStEthEthPool.sol) [💰](#nowhere "Payable Functions")                                     |     [9](#nowhere "(nSLOC:4, SLOC:9, Lines:12)")     | -                                                          |                                                          |
| [contracts/interfaces/rocketpool/RocketDAOProtocolSettingsDepositInterface.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/rocketpool/RocketDAOProtocolSettingsDepositInterface.sol)      |     [9](#nowhere "(nSLOC:9, SLOC:9, Lines:16)")     | -                                                          |                                                          |
| [contracts/interfaces/uniswap/pool/IUniswapV3PoolImmutables.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/uniswap/pool/IUniswapV3PoolImmutables.sol)                                    |     [9](#nowhere "(nSLOC:9, SLOC:9, Lines:35)")     | -                                                          |                                                          |
| [contracts/interfaces/uniswap/pool/IUniswapV3PoolOwnerActions.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/uniswap/pool/IUniswapV3PoolOwnerActions.sol)                                |     [9](#nowhere "(nSLOC:5, SLOC:9, Lines:23)")     | -                                                          |                                                          |
| [contracts/interfaces/curve/IFrxEthEthPool.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/curve/IFrxEthEthPool.sol) [💰](#nowhere "Payable Functions")                                   |    [10](#nowhere "(nSLOC:5, SLOC:10, Lines:14)")    | -                                                          |                                                          |
| [contracts/interfaces/frax/IsFrxEth.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/frax/IsFrxEth.sol) [💰](#nowhere "Payable Functions")                                                 |    [11](#nowhere "(nSLOC:7, SLOC:11, Lines:18)")    | -                                                          |                                                          |
| [contracts/interfaces/rocketpool/RocketDepositPoolInterface.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/rocketpool/RocketDepositPoolInterface.sol) [💰](#nowhere "Payable Functions") |   [11](#nowhere "(nSLOC:11, SLOC:11, Lines:20)")    | -                                                          |                                                          |
| [contracts/interfaces/curve/IAfEthPool.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/curve/IAfEthPool.sol) [💰](#nowhere "Payable Functions")                                           |    [12](#nowhere "(nSLOC:5, SLOC:12, Lines:16)")    | -                                                          |                                                          |
| [contracts/interfaces/rocketpool/RocketTokenRETHInterface.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/rocketpool/RocketTokenRETHInterface.sol) [💰](#nowhere "Payable Functions")     |   [13](#nowhere "(nSLOC:13, SLOC:13, Lines:24)")    | -                                                          | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [contracts/interfaces/uniswap/ISwapRouter.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/uniswap/ISwapRouter.sol) [💰](#nowhere "Payable Functions")                                     |   [15](#nowhere "(nSLOC:13, SLOC:15, Lines:21)")    | -                                                          |                                                          |
| [contracts/interfaces/uniswap/IUniswapV3Pool.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/uniswap/IUniswapV3Pool.sol)                                                                  |   [16](#nowhere "(nSLOC:16, SLOC:16, Lines:24)")    | -                                                          |                                                          |
| [contracts/interfaces/curve/ICrvEthPool.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/curve/ICrvEthPool.sol) [💰](#nowhere "Payable Functions")                                         |    [22](#nowhere "(nSLOC:8, SLOC:22, Lines:29)")    | -                                                          |                                                          |
| [contracts/interfaces/curve/IFxsEthPool.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/curve/IFxsEthPool.sol) [💰](#nowhere "Payable Functions")                                         |    [22](#nowhere "(nSLOC:8, SLOC:22, Lines:29)")    | -                                                          |                                                          |
| [contracts/interfaces/uniswap/pool/IUniswapV3PoolDerivedState.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/uniswap/pool/IUniswapV3PoolDerivedState.sol)                                |    [23](#nowhere "(nSLOC:5, SLOC:23, Lines:48)")    | -                                                          |                                                          |
| [contracts/interfaces/uniswap/IUniswapV3Factory.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/uniswap/IUniswapV3Factory.sol)                                                            |   [26](#nowhere "(nSLOC:18, SLOC:26, Lines:78)")    | -                                                          |                                                          |
| [contracts/interfaces/curve/ICrvEthPoolLegacy.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/curve/ICrvEthPoolLegacy.sol) [💰](#nowhere "Payable Functions")                             |   [32](#nowhere "(nSLOC:11, SLOC:32, Lines:41)")    | -                                                          |                                                          |
| [contracts/interfaces/uniswap/pool/IUniswapV3PoolActions.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/uniswap/pool/IUniswapV3PoolActions.sol)                                          |   [39](#nowhere "(nSLOC:10, SLOC:39, Lines:105)")   | -                                                          |                                                          |
| [contracts/interfaces/rocketpool/RocketStorageInterface.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/rocketpool/RocketStorageInterface.sol)                                            |   [42](#nowhere "(nSLOC:34, SLOC:42, Lines:81)")    | -                                                          |                                                          |
| [contracts/interfaces/uniswap/pool/IUniswapV3PoolState.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/uniswap/pool/IUniswapV3PoolState.sol)                                              |   [61](#nowhere "(nSLOC:12, SLOC:61, Lines:125)")   | -                                                          |                                                          |
| [contracts/interfaces/uniswap/pool/IUniswapV3PoolEvents.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/uniswap/pool/IUniswapV3PoolEvents.sol)                                            |   [62](#nowhere "(nSLOC:62, SLOC:62, Lines:131)")   | -                                                          |                                                          |
| Total (over 32 files):                                                                                                                                                                                                        | [564](#nowhere "(nSLOC:342, SLOC:564, Lines:1071)") | -                                                          |

## External imports

- **@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol**
  - [contracts/SafEth/SafEth.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol)
  - [contracts/SafEth/derivatives/Reth.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/derivatives/Reth.sol)
  - [contracts/SafEth/derivatives/SfrxEth.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/derivatives/SfrxEth.sol)
  - [contracts/SafEth/derivatives/WstEth.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/derivatives/WstEth.sol)
- **@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol**
  - [contracts/SafEth/SafEth.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol)
- **@openzeppelin/contracts/token/ERC20/ERC20.sol**
  - ~~[contracts/interfaces/lido/IWStETH.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/lido/IWStETH.sol)~~
  - ~~[contracts/interfaces/lido/IstETH.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/lido/IstETH.sol)~~
- **@openzeppelin/contracts/token/ERC20/IERC20.sol**
  - [contracts/SafEth/SafEth.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/SafEth.sol)
  - [contracts/SafEth/derivatives/Reth.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/derivatives/Reth.sol)
  - [contracts/SafEth/derivatives/SfrxEth.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/derivatives/SfrxEth.sol)
  - [contracts/SafEth/derivatives/WstEth.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/SafEth/derivatives/WstEth.sol)
  - ~~[contracts/interfaces/IWETH.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/IWETH.sol)~~
  - ~~[contracts/interfaces/rocketpool/RocketTokenRETHInterface.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/rocketpool/RocketTokenRETHInterface.sol)~~
  - ~~[contracts/interfaces/stakewise/IStakewiseStaker.sol](https://github.com/code-423n4/2023-03-asymmetry/blob/main/contracts/interfaces/stakewise/IStakewiseStaker.sol)~~

# Additional Context

- Minting safETH is done as a percentage of the entire value of the system. If you put in 10% of the ETH in the system, you will own 10% of the safETH.
- Weights are set for each derivative and will stake at a percentage to whatever the current weight is set to.
- Weights are not set in percentage out of 100, so if you set derivatives weights to 400, 400, and 200 they will be 40%, 40%, and 20% respectively.
- A lot of protocols haven't implemented withdrawing yet, so the derivative contracts will be upgraded after Shanghai

## Scoping Details

```
- If you have a public code repo, please share it here: https://github.com/asymmetryfinance/smart-contracts
- How many contracts are in scope?:   4
- Total SLoC for these contracts?:  645
- How many external imports are there?:  12
- How many separate interfaces and struct definitions are there for the contracts within scope?:  20
- Does most of your code generally use composition or inheritance?:   inheritance
- How many external calls?:   27
- What is the overall line coverage percentage provided by your tests?:  92
- Is there a need to understand a separate part of the codebase / get context in order to audit this part of the protocol?:   False
- Please describe required context:
- Does it use an oracle?:  No
- Does the token conform to the ERC20 standard?:  Yes
- Are there any novel or unique curve logic or mathematical models?: Yes
- Does it use a timelock function?: No
- Is it an NFT?: No
- Does it have an AMM?:   Yes
- Is it a fork of a popular project?:   False
- Does it use rollups?: No
- Is it multi-chain?: No
- Does it use a side-chain?: False
```

# Quickstart Command

To immediately get started run the following command

```
export FORK_URL="<your-mainnet-url-goes-here>" && rm -Rf 2023-03-asymmetry || true && git clone https://github.com/code-423n4/2023-03-asymmetry.git -j8 && cd 2023-03-asymmetry && cat .env.sample | sed -e 's|MAINNET_URL=|MAINNET_URL="'"$FORK_URL"'"|g' > .env && nvm use && yarn && yarn compile && REPORT_GAS=true yarn test
```

# Tests

## Local Development

To use the correct node version run

```
nvm use
```

To install dependencies:

First copy the `.env.sample` to a file called `.env` and add an [Alchemy Node URL](https://www.alchemy.com/) under the variable `MAINNET_URL`

Next run `yarn` to install dependencies and run `yarn compile` to compile the project.

## Hardhat

For testing on hardhat simply run:

```
yarn test
```

Or for complete coverage:

```
yarn coverage
```

## Local Node

Run the following command to spin up your local node

```
yarn local-node
```

In another terminal run this command to deploy the contracts to your local node

```
yarn deploy --network localhost
```

Once deployed you can interact with your local contracts through Ethernal or scripts/tests
