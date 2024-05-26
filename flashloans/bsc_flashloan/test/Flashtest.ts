import { ethers } from "hardhat";
import { network } from "hardhat";
import { expect } from "chai";

describe("Flashloan", function () {
  it("Should flashloan", async function () {
    const provider = new ethers.providers.JsonRpcProvider(
      "http://127.0.0.1:8545/"
    );
    const blockNumber = await provider.getBlockNumber();
    console.log("Block number: ", blockNumber);
  });
});
