// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {MagicToken} from "../src/MagicToken.sol";

contract MagicTokenScript is Script {
    MagicToken public token;

    function setUp() public {}

    function run() public {
        // 从环境变量中获取私钥
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);

        // 部署代币，初始供应量为1,000,000,000，名称为"Magic Token"，符号为"MGT"
        token = new MagicToken(
            "Magic Token", 
            "MGT", 
            10 ** 9, 
            vm.addr(deployerPrivateKey) // 使用私钥对应的地址作为初始所有者
        );
        
        console.log("MagicToken deployed at: %s", address(token));
        console.log("Total Supply: %s", token.totalSupply());
        console.log("Deployer: %s", vm.addr(deployerPrivateKey));

        vm.stopBroadcast();
    }
} 