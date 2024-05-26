import { HardhatUserConfig } from "hardhat/config";
import "@nomiclabs/hardhat-ethers";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";

const FORKING_URL = "https://rpc.ankr.com/bsc";
const BLOCK_NUMBER = 15216420;

const config: HardhatUserConfig = {
  solidity: {
    compilers: [{ version: "0.8.10" }, { version: "0.8.13" }],
  },
  networks: {
    hardhat: {
      forking: {
        url: FORKING_URL,
        blockNumber: BLOCK_NUMBER,
      },
    },
  },
};

export default config;
