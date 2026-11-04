// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

abstract contract ReentrancyGuard {
    bool private _nonReentrant;
    constructor() { _nonReentrant = false; }
    modifier nonReentrant() {
        require(!_nonReentrant, "ReentrancyGuard: reentrant call");
        _nonReentrant = true;
        _;
        _nonReentrant = false;
    }
}
abstract contract Ownable {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor() { _owner = msg.sender; emit OwnershipTransferred(address(0), _owner); }
    modifier onlyOwner() { require(_owner == msg.sender, "Ownable: caller is not the owner"); _; }
    function owner() public view returns (address) { return _owner; }
}

contract OracleNetwork is ReentrancyGuard, Ownable {
    struct DataFeed {
        address aggregator;
        uint256 value;
        uint256 timestamp;
        uint256 updateCount;
        bool active;
    }
    mapping(bytes32 => DataFeed) public feeds;
    mapping(address => bool) public oracle;
    uint256 public oracleCount;
    uint256 public updateCount;

    event DataUpdated(bytes32 indexed key, uint256 value, uint256 timestamp);
    event OracleAdded(address indexed oracle);
    event OracleRemoved(address indexed oracle);

    function addOracle(address o) external onlyOwner {
        require(o != address(0), "Zero address");
        require(!oracle[o], "Already an oracle");
        oracle[o] = true;
        oracleCount += 1;
        emit OracleAdded(o);
    }

    function removeOracle(address o) external onlyOwner {
        require(oracle[o], "Not an oracle");
        oracle[o] = false;
        oracleCount -= 1;
        emit OracleRemoved(o);
    }

    function updateData(bytes32 key, uint256 value) external nonReentrant {
        require(oracle[msg.sender], "Not an oracle");
        DataFeed storage f = feeds[key];
        f.aggregator = msg.sender;
        f.value = value;
        f.timestamp = block.timestamp;
        f.updateCount += 1;
        f.active = true;
        updateCount += 1;
        emit DataUpdated(key, value, block.timestamp);
    }

    function getData(bytes32 key) external view returns (address aggregator, uint256 value, uint256 timestamp, uint256 updateCount, bool active) {
        DataFeed storage f = feeds[key];
        return (f.aggregator, f.value, f.timestamp, f.updateCount, f.active);
    }

    function isOracle(address o) external view returns (bool) { return oracle[o]; }
}
