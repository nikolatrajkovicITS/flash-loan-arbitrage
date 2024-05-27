// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

// solidty dont have console.log so we use hardhat/console.sol
import "hardhat/console.sol";

// IUniswapV2Router02 is the interface for the UniswapV2Router contract  - which is the contract for the Uniswap V2 router
import {IUniswapV2Router02} from "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

// ISwapRouter is the interface for the UniswapV3Router contract
import {ISwapRouter} from "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

// IUniswapV3Pool is the interface for the UniswapV3Pool contract - which is the contract for the Uniswap V3 pool
import {IUniswapV3Pool} from "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";

// contract for the ERC20 token
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// TransferHelper is a library that provides functions for transferring tokens
import {TransferHelper} from "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";

// SafeERC20 is a library that provides functions for safely transferring ERC20 tokens - check does transfer succeed or fail
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

// SafeMath is a library that provides functions for performing math operations safely
import {SafeMath} from "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract FlashLoan {
    IERC20 private immutable token0;
    IERC20 private immutable token1;
    IUniswapV3Pool private immutable pool;

    address private constant deployer =
        0x41ff9AA7e16B8B1a8a8dc4f0eFacd93D02d071c9;

    constructor(address _token0, address _token1, uint24 _fee) {
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
        // calculate the pool address using the UniswapV3Pool contract and the token0, token1, and fee parameters
        pool = IUniswapV3Pool(IUniswapV3Pool(getPool(_token0, _token1, _fee)));

        console.log("Pool address: %s", address(pool));
    }

    function getPool(
        address _token0,
        address _token1,
        uint24 _fee
    ) public pure returns (address) {
        PoolAddress.PoolKey memory poolKey = PoolAddress.getPoolKey(
            _token0,
            _token1,
            _fee
        );
        return PoolAddress.computeAddress(deployer, poolKey);
    }
}

library PoolAddress {
    // POOL_INIT_CODE_HASH is the keccak256 hash of the init code for the UniswapV3Pool contract
    bytes32 internal constant POOL_INIT_CODE_HASH =
        0x6ce8eb472fa82df5469c6ab6d485f17c3ad13c8cd7af59b3d4a8026c5ce0f7e2;

    struct PoolKey {
        address token0;
        address token1;
        uint24 fee;
    }

    function getPoolKey(
        address tokenA,
        address tokenB,
        uint24 fee
    ) internal pure returns (PoolKey memory) {
        // memory is a data location that is used for function arguments and return parameters

        if (tokenA < tokenB) {
            return PoolKey(tokenA, tokenB, fee);
        } else {
            return PoolKey(tokenB, tokenA, fee);
        }
    }

    function computeAddress(
        address deployer,
        PoolKey memory key
    ) internal pure returns (address pool) {
        require(key.token0 < key.token1);

        // keccak256 expects 32 bytes, so we need to pack the data
        // hex"ff" is a prefix to prevent accidental collisions
        // deployer is the address of the contract that will deploy the pool
        // key.token0, key.token1, and key.fee are the parameters that define the pool
        // POOL_INIT_CODE_HASH is the keccak256 hash of the init code for the UniswapV3Pool contract
        pool = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            hex"ff",
                            deployer,
                            keccak256(
                                abi.encode(key.token0, key.token1, key.fee)
                            ),
                            POOL_INIT_CODE_HASH
                        )
                    )
                )
            )
        );
    }
}
