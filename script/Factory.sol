// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0;

import "forge-std/Script.sol";
import "../src/UniswapV3Factory.sol";
import "../src/UniswapV3PoolDeployer.sol";

contract Factory is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        UniswapV3Factory factory = new UniswapV3Factory();
        UniswapV3PoolDeployer deployer = new UniswapV3PoolDeployer();

        vm.stopBroadcast();

        console.log("factory address: ", address(factory));
        console.log("deployer address: ", address(deployer));
    }
}
