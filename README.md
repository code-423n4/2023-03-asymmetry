# ✨ So you want to sponsor a contest

This `README.md` contains a set of checklists for our contest collaboration.

Your contest will use two repos:

- **a _contest_ repo** (this one), which is used for scoping your contest and for providing information to contestants (wardens)
- **a _findings_ repo**, where issues are submitted (shared with you after the contest)

Ultimately, when we launch the contest, this contest repo will be made public and will contain the smart contracts to be reviewed and all the information needed for contest participants. The findings repo will be made public after the contest report is published and your team has mitigated the identified issues.

Some of the checklists in this doc are for **C4 (🐺)** and some of them are for **you as the contest sponsor (⭐️)**.

---

# Contest setup

## 🐺 C4: Set up repos

- [x] Create a new private repo named `YYYY-MM-sponsorname` using this repo as a template.
- [x] Rename this repo to reflect contest date (if applicable)
- [x] Rename contest H1 below
- [x] Update pot sizes
- [x] Fill in start and end times in contest bullets below
- [x] Add link to submission form in contest details below
- [x] Add the information from the scoping form to the "Scoping Details" section at the bottom of this readme.
- [ ] Add matching info to the [code423n4.com public contest data here](https://github.com/code-423n4/code423n4.com/blob/main/_data/contests/contests.csv))
- [x] Add sponsor to this private repo with 'maintain' level access.
- [x] Send the sponsor contact the url for this repo to follow the instructions below and add contracts here.
- [ ] Delete this checklist.

# Repo setup

## ⭐️ Sponsor: Add code to this repo

- [x] Create a PR to this repo with the below changes:
- [x] Provide a self-contained repository with working commands that will build (at least) all in-scope contracts, and commands that will run tests producing gas reports for the relevant contracts.
- [x] Make sure your code is thoroughly commented using the [NatSpec format](https://docs.soliditylang.org/en/v0.5.10/natspec-format.html#natspec-format).
- [x] Please have final versions of contracts and documentation added/updated in this repo **no less than 24 hours prior to contest start time.**
- [x] Be prepared for a 🚨code freeze🚨 for the duration of the contest — important because it establishes a level playing field. We want to ensure everyone's looking at the same code, no matter when they look during the contest. (Note: this includes your own repo, since a PR can leak alpha to our wardens!)

---

## ⭐️ Sponsor: Edit this README

Under "SPONSORS ADD INFO HERE" heading below, include the following:

- [x] Modify the bottom of this `README.md` file to describe how your code is supposed to work with links to any relevent documentation and any other criteria/details that the C4 Wardens should keep in mind when reviewing. ([Here's a well-constructed example.](https://github.com/code-423n4/2022-08-foundation#readme))
  - [ ] When linking, please provide all links as full absolute links versus relative links
  - [x] All information should be provided in markdown format (HTML does not render on Code4rena.com)
- [ ] Under the "Scope" heading, provide the name of each contract and:
  - [ ] source lines of code (excluding blank lines and comments) in each
  - [ ] external contracts called in each
  - [ ] libraries used in each
- [ ] Describe any novel or unique curve logic or mathematical models implemented in the contracts
- [ ] Does the token conform to the ERC-20 standard? In what specific ways does it differ?
- [ ] Describe anything else that adds any special logic that makes your approach unique
- [ ] Identify any areas of specific concern in reviewing the code
- [ ] Optional / nice to have: pre-record a high-level overview of your protocol (not just specific smart contract functions). This saves wardens a lot of time wading through documentation.
- [ ] See also: [this checklist in Notion](https://code4rena.notion.site/Key-info-for-Code4rena-sponsors-f60764c4c4574bbf8e7a6dbd72cc49b4#0cafa01e6201462e9f78677a39e09746)
- [ ] Delete this checklist and all text above the line below when you're ready.

---

# Asymmetry contest details

- Total Prize Pool: $36,500
  - HM awards: $25,500
  - QA report awards: #3,000
  - Gas report awards: $1,500
  - Judge + presort awards: $6,000
  - Scout awards: $500 USDC
  - Mitigation review contest: $10,000 (_Opportunity goes to top X certified wardens based on placement in this contest._)
- Join [C4 Discord](https://discord.gg/code4rena) to register
- Submit findings [using the C4 form](https://code4rena.com/contests/2023-03-asymmetry-contest/submit)
- [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
- Starts 24 March 2023 20:00 UTC
- Ends 30 March 2023 20:00 UTC

## Automated Findings / Publicly Known Issues

Automated findings output for the contest can be found [here](add link to report) within an hour of contest opening.

_Note for C4 wardens: Anything included in the automated findings output is considered a publicly known issue and is ineligible for awards._

# Overview

SafEth is a smart contract suite that enables a user to diversify their ETH into staked derivatives.
Currently the supported staked derivatives are [wstETH](https://lido.fi/), [rETH](https://rocketpool.net/), and [sfrxETH](https://docs.frax.finance/frax-ether/frxeth-and-sfrxeth).

The goal of SafEth is to help decentralize the liquid staked derivatives on the Ethereum blockchain. This is done by enabling and easy access to diversification of derivatives.

In the future, SafEth will be used in conjunction with other smart contracts to allow the staking of SafEth to gain higher yield.

[Architecture Diagram](assets/SafEth-Architecture.drawio)

## Protocol Contracts:

[SafEth](contracts/SafEth/SafEth.sol): An upgradeable ERC20 contract that handles the conversion between ETH and whatever derivatives that are implemented

## Derivative Contracts:

[Reth](https://github.com/code-423n4/2023-03-asymmetry/tree/main/contracts/SafEth/derivatives/Reth.sol) -
[SfrxEth](https://github.com/code-423n4/2023-03-asymmetry/tree/main/contracts/SafEth/derivatives/SfrxEth.sol) -
[WstEth](https://github.com/code-423n4/2023-03-asymmetry/tree/main/contracts/SafEth/derivatives/WstEth.sol)

These contracts handle all business logic to deposit and withdraw through their specific protocols. These will change after Shanghai is released when withdrawing from the beacon chain is enabled

# Scope

| Contract                                                                                                                                       | SLOC | Purpose                                              | Libraries used                                           |
| ---------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ---------------------------------------------------- | -------------------------------------------------------- |
| [contracts/SafEth/SafEth.sol](https://github.com/code-423n4/2023-03-asymmetry/tree/main/contracts/SafEth/SafEth.sol)                           | 224  | This contract is the main staking/unstaking contract | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [contracts/SafEth/derivatives/Reth.sol](https://github.com/code-423n4/2023-03-asymmetry/tree/main/contracts/SafEth/derivatives/Reth.sol)       | 222  | Derivative contract for rETH                         | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [contracts/SafEth/derivatives/SfrxEth.sol](https://github.com/code-423n4/2023-03-asymmetry/tree/main/contracts/SafEth/derivatives/SfrxEth.sol) | 113  | Derivative contract for sfrxETH                      | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |
| [contracts/SafEth/derivatives/WstEth.sol](https://github.com/code-423n4/2023-03-asymmetry/tree/main/contracts/SafEth/derivatives/WstEth.sol)   | 86   | Derivative contract for wstETH                       | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |

## Out of scope

All the `mock` contracts are only used for testing purposes

# Additional Context

- Minting safETH is done as a percentage of the entire value of the system. If you put in 10% of the ETH in the system, you will own 10% of the safETH.
- Weights are set for each derivative dynamically and will stake at a percentage to whatever the current weight is set to.
- Weights are not set in percentage out of 100, so if you set derivatives weights to 400, 400, and 200 they will be 40%, 40%, and 20% respectively.
- A lot of protocols haven't implemented withdrawing yet, so the derivative contracts will be upgraded after Shanghai

## Scoping Details

```
- If you have a public code repo, please share it here: https://github.com/asymmetryfinance/smart-contracts
- How many contracts are in scope?:   4
- Total SLoC for these contracts?:  645
- How many external imports are there?:  12
- How many separate interfaces and struct definitions are there for the contracts within scope?:  12
- Does most of your code generally use composition or inheritance?:   inheritance
- How many external calls?:   27
- What is the overall line coverage percentage provided by your tests?:  92
- Is there a need to understand a separate part of the codebase / get context in order to audit this part of the protocol?:   False
- Please describe required context:
- Does it use an oracle?:  No
- Does the token conform to the ERC20 standard?:  Yes
- Are there any novel or unique curve logic or mathematical models?:
- Does it use a timelock function?:
- Is it an NFT?:
- Does it have an AMM?:   Yes
- Is it a fork of a popular project?:   False
- Does it use rollups?:
- Is it multi-chain?:
- Does it use a side-chain?: False
```

# Tests

## Local Development

To use the correct node version run

```
nvm use
```

To install dependencies and compile run

```
yarn && yarn compile
```

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
yarn local:node
```

In another terminal run this command to deploy the contracts to your local node

```
yarn deploy --network localhost
```

Once deployed you can interact with your local contracts through Ethernal or scripts/tests
