# MagicToken

MagicToken 是一个基于 ERC-20 标准的智能合约项目，使用 Solidity 开发。该代币合约提供了基本的 ERC-20 功能，并增加了铸造和销毁代币的特性。

## 项目特点

- 标准 ERC-20 接口实现
- 代币铸造功能 (仅限所有者)
- 代币销毁功能
- 代表他人销毁代币功能 (需要授权)
- 基于 OpenZeppelin 合约库构建
- 使用 Foundry 框架进行开发和测试

## 合约功能

1. **代币基本信息**
   - 名称：Magic Token
   - 符号：MGT
   - 小数位：18
   - 初始供应量：1,000,000,000 MGT

2. **主要功能**
   - `transfer`: 转移代币
   - `approve`: 授权他人使用代币
   - `transferFrom`: 代表他人转移代币
   - `mint`: 铸造新代币 (仅限所有者)
   - `burn`: 销毁自己的代币
   - `burnFrom`: 销毁他人代币 (需要授权)

## 开发环境设置

### 前提条件

- [Foundry](https://getfoundry.sh/)
- Git

### 安装步骤

1. 克隆仓库：
   ```bash
   git clone https://github.com/MeditationLand/MagicToken.git
   cd MagicToken
   ```

2. 安装依赖：
   ```bash
   forge install
   ```

3. 配置环境变量：
   在项目根目录创建 `.env` 文件，填写以下内容：
   ```
   PRIVATE_KEY=你的以太坊钱包私钥
   SEPOLIA_RPC_URL=你的以太坊测试网RPC URL
   ETHERSCAN_API_KEY=你的Etherscan API密钥
   ```

> **⚠️ 安全提示**：
> - 确保`.env`文件已添加到`.gitignore`中，永远不要将其提交到Git仓库
> - 私钥等敏感信息只能存储在本地`.env`文件中，切勿分享给他人
> - 建议在测试网络使用专门的测试账户，不要使用主网账户的私钥
> - 定期检查`.env`文件的权限设置，确保只有你能访问
> - 如果不小心泄露了私钥，请立即转移账户中的资产

## 测试

运行测试命令：

```bash
forge test
```

测试包括：
- 初始供应量验证
- 代币元数据验证
- 代币转移功能
- 铸造和销毁功能
- 授权和代表他人转移功能
- 错误情况处理

## 部署

> **提示**: 部署前请确保你的账户中有足够的ETH作为Gas费，否则交易将会失败。Sepolia测试网络可以通过水龙头获取免费的测试ETH。

部署到测试网络：

```bash
forge script script/MagicToken.s.sol:MagicTokenScript --rpc-url $SEPOLIA_RPC_URL --broadcast --verify -vvvv
```

> MagicToken已经部署在Sepolia网络，合约地址：0xb2228912018202D7ac9322b7b227C1878F5DC3A3

## 许可证

本项目采用 MIT 许可证。详见 [LICENSE](./LICENSE) 文件。
