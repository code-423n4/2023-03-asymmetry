import * as dotenv from "dotenv";

import "@nomiclabs/hardhat-waffle";
import "@nomiclabs/hardhat-ethers";
import "@typechain/hardhat";
import "hardhat-contract-sizer";
import "hardhat-gas-reporter";
import "@nomiclabs/hardhat-etherscan";
import "hardhat-deploy";
import "solidity-coverage";
import "@openzeppelin/hardhat-upgrades";
import "hardhat-ethernal";
import { HardhatUserConfig } from "hardhat/types";

dotenv.config();

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.13",
    settings: {
      optimizer: {
        enabled: true,
        runs: 100000,
      },
    },
  },
  ethernal: {
    disableSync: false, // If set to true, plugin will not sync blocks & txs
    disableTrace: false, // If set to true, plugin won't trace transaction
    workspace: undefined, // Set the workspace to use, will default to the default workspace (latest one used in the dashboard). It is also possible to set it through the ETHERNAL_WORKSPACE env variable
    uploadAst: false, // If set to true, plugin will upload AST, and you'll be able to use the storage feature (longer sync time though)
    disabled: process.env.ETHERNAL_ENABLED === "false", // If set to true, the plugin will be disabled, nohting will be synced, ethernal.push won't do anything either
    resetOnStart: undefined, // Pass a workspace name to reset it automatically when restarting the node, note that if the workspace doesn't exist it won't error
    serverSync: false, // Only available on public explorer plans - If set to true, blocks & txs will be synced by the server. For this to work, your chain needs to be accessible from the internet. Also, trace won't be synced for now when this is enabled.
    skipFirstBlock: false, // If set to true, the first block will be skipped. This is mostly useful to avoid having the first block synced with its tx when starting a mainnet fork
    verbose: false, // If set to true, will display this config object on start and the full error object
  },
  networks: {
    hardhat: {
      chainId: 1234, // Intentionally set to an "unknown" so openzeppelin upgrades doesn't think forked local is mainnet
      allowUnlimitedContractSize: true,
      accounts: {
        mnemonic: process.env.MNEMONIC,
      },
      forking: {
        url: process.env.MAINNET_URL || "",
        blockNumber: 16871866,
        enabled: true, // Set to false to disable forked mainnet mode
      },
    },
    goerli: {
      url: process.env.GOERLI_URL || "",
      accounts: {
        mnemonic: process.env.MNEMONIC,
      },
    },
    rinkeby: {
      url: process.env.RINKEBY_URL || "",
      accounts: {
        mnemonic: process.env.MNEMONIC,
      },
    },
    mainnet: {
      url: process.env.MAINNET_URL || "",
      accounts: {
        mnemonic: process.env.MNEMONIC,
      },
    },
  },
  paths: {
    deploy: "./scripts/deploy",
    deployments: "./deployments",
    sources: "./contracts",
  },
  namedAccounts: {
    admin: {
      default: 0,
    },
    alice: {
      default: 1,
    },
    bob: {
      default: 2,
    },
    bill: {
      default: 3,
    },
  },
  contractSizer: {
    alphaSort: true,
    runOnCompile: true,
  },
  gasReporter: {
    enabled: true,
    currency: "USD",
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
  mocha: {
    timeout: 130000,
  },
};

export default config;
