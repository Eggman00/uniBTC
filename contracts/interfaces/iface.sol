// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IMintableContract is IERC20 {
    function mint(address account, uint256 amount) external;
    function burn(uint256 amount) external;
    function burnFrom(address account, uint256 amount) external;
}

interface ISGNFeeQuerier {
    function feeBase() external view returns (uint256);
    function feePerByte() external view returns (uint256);
}

interface IVault {
    function execute(address target, bytes memory data, uint256 value) external returns(bytes memory);
}

// Reference: https://github.com/fbtc-com/fbtcX-contract/blob/main/src/LockedFBTC.sol
interface ILockedFBTC {
    enum Operation {
        Nop, // starts from 1.
        Mint,
        Burn,
        CrosschainRequest,
        CrosschainConfirm
    }

    enum Status {
        Unused,
        Pending,
        Confirmed,
        Rejected
    }

    struct Request {
        Operation op;
        Status status;
        uint128 nonce; // Those can be packed into one slot in evm storage.
        bytes32 srcChain;
        bytes srcAddress;
        bytes32 dstChain;
        bytes dstAddress;
        uint256 amount; // Transfer value without fee.
        uint256 fee;
        bytes extra;
    }

    function mintLockedFbtcRequest(uint256 _amount) external returns (uint256 realAmount);
    function redeemFbtcRequest(uint256 _amount, bytes32 _depositTxid, uint256 _outputIndex) external returns (bytes32 _hash, Request memory _r);
    function confirmRedeemFbtc(uint256 _amount) external;
    function burn(uint256 _amount) external;
    function fbtc() external returns (address);
}

// Reference: https://scan.merlinchain.io/address/0x72A817715f174a32303e8C33cDCd25E0dACfE60b
interface IMTokenSwap {
    function swapMBtc(bytes32 _txHash, uint256 _amount) external;
    function bridgeAddress() external returns (address);
}

// References:
//    1. https://scan.merlinchain.io/address/0x28AD6b7dfD79153659cb44C2155cf7C0e1CeEccC
//    2. https://github.com/MerlinLayer2/BTCLayer2BridgeContract/blob/main/contracts/BTCLayer2Bridge.sol
interface IBTCLayer2Bridge {
    function lockNativeToken(string memory destBtcAddr) external payable;
    function getBridgeFee(address msgSender, address token) external view returns(uint256);
}