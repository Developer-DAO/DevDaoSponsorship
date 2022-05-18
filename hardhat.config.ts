import { config as dotenvConfig } from "dotenv";
import { resolve } from "path";
dotenvConfig({ path: resolve(__dirname, "./.env") });

import "@typechain/hardhat";
import "@nomiclabs/hardhat-ethers";
import "hardhat-gas-reporter";
import "@nomiclabs/hardhat-waffle";
import "@nomiclabs/hardhat-etherscan";

const PRIVATE_KEY = process.env.PRIVATE_KEY || "";
const ARBITRUM_URL = process.env.ARBITRUM;
const ARBITRUM_RINKEBY_URL = process.env.ARBITRUM_RINKEBY;
const MUMBAI_URL = process.env.MUMBAI;
const MATIC_URL = process.env.MATIC;
const RINKEBY_URL = process.env.RINKEBY;

const config = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      timeout: 100_000,
      chainId: 1337,
      loggingEnabled: true,
    },
    localhost: {
      timeout: 100_000,
      loggingEnabled: true,
      mining: {
        auto: true,
      },
      url: "http://127.0.0.1:8545/",
    },
    rinkeby: {
      url: RINKEBY_URL,
      accounts: [PRIVATE_KEY],
    },
    arbitrumRinkeby: {
      url: ARBITRUM_RINKEBY_URL,
      accounts: [PRIVATE_KEY],
    },
    arbitrum: {
      url: ARBITRUM_URL,
      accounts: [PRIVATE_KEY],
    },
    mumbai: {
      url: MUMBAI_URL,
      accounts: [PRIVATE_KEY],
    },
    matic: {
      url: MATIC_URL,
      accounts: [PRIVATE_KEY],
    },
  },
  solidity: "0.8.4",
  typechain: {
    outDir: "typechain",
    target: "ethers-v5",
  },
  mocha: {
    timeout: 1_200_000,
  },
  etherscan: {
    apiKey: {
      arbitrumOne: process.env.ARBISCAN_API_KEY,
      arbitrumTestnet: process.env.ARBISCAN_API_KEY,
      polygonMumbai: process.env.POLYGONSCAN_API_KEY,
      polygon: process.env.POLYGONSCAN_API_KEY,
    },
  },
};

export default config;
