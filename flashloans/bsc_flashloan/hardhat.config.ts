import { HardhatUserConfig } from "hardhat/config";
import "@nomiclabs/hardhat-ethers";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";
import dotenv from "dotenv";
dotenv.config();

const mainnet_provider_url = process.env.MAINNET_PROVIDER_URL || "";
const testnet_provider_url = process.env.TESTNET_PROVIDER_URL || "";
const private_key = process.env.ACCOUNT_PRIVATE_KEY || "";

const config: HardhatUserConfig = {
  solidity: {
    compilers: [{ version: "0.8.10" }, { version: "0.8.13" }],
  },
  networks: {
    hardhat: {
      // hardhat means local network
      forking: {
        url: mainnet_provider_url,
      },
    },
    testnet: {
      url: testnet_provider_url,
      chainId: 97,
      accounts: [private_key],
    },
    mainnet: {
      url: mainnet_provider_url,
      chainId: 57,
      accounts: [private_key],
    },
  },
};

export default config;
