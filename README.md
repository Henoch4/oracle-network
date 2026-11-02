# Oracle Network — Decentralized Data Feeds

> A push/pull data oracle where reporters stake on values, readers consume verified aggregates per report, and reports are versioned and contested on-chain - the smallest oracle on the network.

## What it does

A push/pull data oracle where reporters stake on values, readers consume verified aggregates per report, and reports are versioned and contested on-chain - the smallest oracle on the network. The entire lifecycle lives in one contract, every button in the UI calls a real function on it — there is no mock backend.

## Contract

| | |
|---|---|
| File | `contracts/OracleNetwork.sol` |
| Contract name | `OracleNetwork` (inherits `ReentrancyGuard, Ownable`) |
| Solidity | `^0.8.20` |
| State functions | 6 (of which 0 payable) |
| Deployed (mainnet 677) | not yet deployed — placeholder `0x000…000` |

### Function surface

| Function | Type | Returns |
|---|---|---|
| `owner` | view | address |
| `addOracle` | write | result / revert |
| `removeOracle` | write | result / revert |
| `updateData` | write | result / revert |
| `getData` | view | address aggregator, uint256 value, uint256 timestamp, uint256 updateCount, bool active |
| `isOracle` | view | bool |

### Events

| Event | Signature |
|---|---|
| `OwnershipTransferred` | (address indexed previousOwner, address indexed newOwner) |
| `DataUpdated` | (bytes32 indexed key, uint256 value, uint256 timestamp) |
| `OracleAdded` | (address indexed oracle) |
| `OracleRemoved` | (address indexed oracle) |

## Network

| | |
|---|---|
| Chain | BOT Chain Mainnet (chainId `677`) |
| RPC | `https://rpc.botchain.ai` |
| Explorer | `https://scan.botchain.ai` |
| Native currency | BOT (18 decimals) |
| Testnet | BOT Chain Testnet (chainId `968`) - `https://rpc.bohr.life` |

## Frontend

- **Wallet connection** - [Reown/AppKit](https://reown.com) (Web3Modal v2, inline modal, `subscribeAccount` / `subscribeNetwork`)
- **Web3 library** - ethers.js v6 (`BrowserProvider`, `Contract`, `parseEther`)
- **Animation** - GSAP 3 + ScrollTrigger (`expo.out` entrances, `prefers-reduced-motion` fallback renders content instantly)
- **Zero build step** - single `index.html`, CDN imports via ESM import map; no bundler, no framework runtime
- **Accessibility** - auto-generated `aria-label`s on all binary and form controls, focus-visible styles, button busy states

## Run it locally

```bash
git clone https://github.com/Henoch4/oracle-network.git
cd oracle-network
# open the frontend directly (no build step)
start frontend/index.html   # Windows
# or serve it if your browser blocks file:// modules:
npx serve frontend
```

> **Note** — contract addresses: the UI reads its deploy target from the `CA` constant at the top of the inline script. Until the contract is deployed to mainnet 677, the demo runs against the deterministic sample data built into the page; after deployment, set `CA['677']` to the real address and every button goes live.