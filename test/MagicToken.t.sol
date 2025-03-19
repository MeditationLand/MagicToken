// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {MagicToken} from "../src/MagicToken.sol";

contract MagicTokenTest is Test {
    MagicToken public token;
    address public owner;
    address public user1;
    address public user2;
    uint256 public initialSupply = 10 ** 9; // 初始供应量：1,000,000
    
    function setUp() public {
        owner = address(1);
        user1 = address(2);
        user2 = address(3);
        
        vm.startPrank(owner);
        token = new MagicToken("Magic Token", "MGT", initialSupply, owner);
        vm.stopPrank();
    }

    function test_InitialSupply() public view {
        assertEq(token.totalSupply(), initialSupply * 10 ** 18);
        assertEq(token.balanceOf(owner), initialSupply * 10 ** 18);
    }
    
    function test_TokenMetadata() public view {
        assertEq(token.name(), "Magic Token");
        assertEq(token.symbol(), "MGT");
        assertEq(token.decimals(), 18);
    }
    
    function test_Transfer() public {
        uint256 amount = 1000 * 10 ** 18;
        
        vm.startPrank(owner);
        token.transfer(user1, amount);
        vm.stopPrank();
        
        assertEq(token.balanceOf(user1), amount);
        assertEq(token.balanceOf(owner), (initialSupply * 10 ** 18) - amount);
    }
    
    function test_Approve_TransferFrom() public {
        uint256 amount = 500 * 10 ** 18;
        
        vm.startPrank(owner);
        token.approve(user1, amount);
        vm.stopPrank();
        
        vm.startPrank(user1);
        token.transferFrom(owner, user2, amount);
        vm.stopPrank();
        
        assertEq(token.balanceOf(user2), amount);
        assertEq(token.balanceOf(owner), (initialSupply * 10 ** 18) - amount);
        assertEq(token.allowance(owner, user1), 0);
    }
    
    function test_Mint() public {
        uint256 mintAmount = 5000 * 10 ** 18;
        
        vm.startPrank(owner);
        token.mint(user1, mintAmount);
        vm.stopPrank();
        
        assertEq(token.balanceOf(user1), mintAmount);
        assertEq(token.totalSupply(), (initialSupply * 10 ** 18) + mintAmount);
    }
    
    function test_Burn() public {
        uint256 transferAmount = 2000 * 10 ** 18;
        uint256 burnAmount = 1000 * 10 ** 18;
        
        vm.startPrank(owner);
        token.transfer(user1, transferAmount);
        vm.stopPrank();
        
        vm.startPrank(user1);
        token.burn(burnAmount);
        vm.stopPrank();
        
        assertEq(token.balanceOf(user1), transferAmount - burnAmount);
        assertEq(token.totalSupply(), (initialSupply * 10 ** 18) - burnAmount);
    }
    
    function test_BurnFrom() public {
        uint256 transferAmount = 3000 * 10 ** 18;
        uint256 approveAmount = 2000 * 10 ** 18;
        uint256 burnAmount = 1500 * 10 ** 18;
        
        // 向user1转账一些代币
        vm.startPrank(owner);
        token.transfer(user1, transferAmount);
        vm.stopPrank();
        
        // user1授权user2可以使用2000代币
        vm.startPrank(user1);
        token.approve(user2, approveAmount);
        vm.stopPrank();
        
        // 检查授权金额是否正确
        assertEq(token.allowance(user1, user2), approveAmount);
        
        // user2代表user1销毁1500代币
        vm.startPrank(user2);
        token.burnFrom(user1, burnAmount);
        vm.stopPrank();
        
        // 验证user1余额减少了
        assertEq(token.balanceOf(user1), transferAmount - burnAmount);
        // 验证总供应量减少了
        assertEq(token.totalSupply(), (initialSupply * 10 ** 18) - burnAmount);
        // 验证授权额度减少了
        assertEq(token.allowance(user1, user2), approveAmount - burnAmount);
    }
    
    function test_RevertWhen_UnauthorizedMint() public {
        vm.startPrank(user1);
        vm.expectRevert();
        token.mint(user1, 1000 * 10 ** 18);
        vm.stopPrank();
    }
    
    function test_RevertWhen_BurnFromWithoutApproval() public {
        uint256 transferAmount = 2000 * 10 ** 18;
        
        // 向user1转账一些代币
        vm.startPrank(owner);
        token.transfer(user1, transferAmount);
        vm.stopPrank();
        
        // user2尝试在没有授权的情况下代表user1销毁代币
        vm.startPrank(user2);
        vm.expectRevert();
        token.burnFrom(user1, 1000 * 10 ** 18);
        vm.stopPrank();
    }
    
    function test_RevertWhen_BurnFromExceedsAllowance() public {
        uint256 transferAmount = 3000 * 10 ** 18;
        uint256 approveAmount = 1000 * 10 ** 18;
        
        // 向user1转账一些代币
        vm.startPrank(owner);
        token.transfer(user1, transferAmount);
        vm.stopPrank();
        
        // user1授权user2可以使用1000代币
        vm.startPrank(user1);
        token.approve(user2, approveAmount);
        vm.stopPrank();
        
        // user2尝试销毁超过授权额度的代币
        vm.startPrank(user2);
        vm.expectRevert();
        token.burnFrom(user1, 1500 * 10 ** 18);
        vm.stopPrank();
    }
    
    function test_RevertWhen_BurnFromExceedsBalance() public {
        uint256 transferAmount = 1000 * 10 ** 18;
        uint256 approveAmount = 2000 * 10 ** 18;
        
        // 向user1转账一些代币
        vm.startPrank(owner);
        token.transfer(user1, transferAmount);
        vm.stopPrank();
        
        // user1授权user2可以使用较大额度的代币（超过实际持有量）
        vm.startPrank(user1);
        token.approve(user2, approveAmount);
        vm.stopPrank();
        
        // user2尝试销毁超过user1余额的代币
        vm.startPrank(user2);
        vm.expectRevert();
        token.burnFrom(user1, 1500 * 10 ** 18);
        vm.stopPrank();
    }
} 