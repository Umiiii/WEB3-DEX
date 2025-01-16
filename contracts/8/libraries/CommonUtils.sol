/// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Base contract with common permit handling logics
abstract contract CommonUtils {
    address internal constant _ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    uint256 internal constant _ADDRESS_MASK =
        0x000000000000000000000000ffffffffffffffffffffffffffffffffffffffff;
    uint256 internal constant _REVERSE_MASK =
        0x8000000000000000000000000000000000000000000000000000000000000000;
    uint256 internal constant _ORDER_ID_MASK =
        0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
    uint256 internal constant _WEIGHT_MASK =
        0x00000000000000000000ffff0000000000000000000000000000000000000000;
    uint256 internal constant _CALL_GAS_LIMIT = 5000;
    uint256 internal constant ORIGIN_PAYER =
        0x3ca20afc2ccc0000000000000000000000000000000000000000000000000000;

    /// @dev WETH address is network-specific and needs to be changed before deployment.
    /// It can not be moved to immutable as immutables are not supported in assembly
    // ETH:     C02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
    // BSC:     bb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c
    // OEC:     8f8526dbfd6e38e3d8307702ca8469bae6c56c15
    // LOCAL:   5FbDB2315678afecb367f032d93F642f64180aa3
    // LOCAL2:  02121128f1Ed0AdA5Df3a87f42752fcE4Ad63e59
    // POLYGON: 0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270
    // AVAX:    B31f66AA3C1e785363F0875A1B74E27b85FD66c7
    // FTM:     21be370D5312f44cB42ce377BC9b8a0cEF1A4C83
    // ARB:     82aF49447D8a07e3bd95BD0d56f35241523fBab1
    // OP:      4200000000000000000000000000000000000006
    // CRO:     5C7F8A570d578ED84E63fdFA7b1eE72dEae1AE23
    // CFX:     14b2D3bC65e74DAE1030EAFd8ac30c533c976A9b
    // POLYZK   4F9A0e7FD2Bf6067db6994CF12E4495Df938E6e9
    address public constant _WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    // address public constant _WETH = 0x5FbDB2315678afecb367f032d93F642f64180aa3;    // hardhat1
    // address public constant _WETH = 0x707531c9999AaeF9232C8FEfBA31FBa4cB78d84a;    // hardhat2

    // ETH:     70cBb871E8f30Fc8Ce23609E9E0Ea87B6b222F58
    // ETH-DEV：02D0131E5Cc86766e234EbF1eBe33444443b98a3
    // BSC:     d99cAE3FAC551f6b6Ba7B9f19bDD316951eeEE98
    // OEC:     E9BBD6eC0c9Ca71d3DcCD1282EE9de4F811E50aF
    // LOCAL:   e7f1725E7734CE288F8367e1Bb143E90bb3F0512
    // LOCAL2:  95D7fF1684a8F2e202097F28Dc2e56F773A55D02
    // POLYGON: 40aA958dd87FC8305b97f2BA922CDdCa374bcD7f
    // AVAX:    70cBb871E8f30Fc8Ce23609E9E0Ea87B6b222F58
    // FTM:     E9BBD6eC0c9Ca71d3DcCD1282EE9de4F811E50aF
    // ARB:     E9BBD6eC0c9Ca71d3DcCD1282EE9de4F811E50aF
    // OP:      100F3f74125C8c724C7C0eE81E4dd5626830dD9a
    // CRO:     E9BBD6eC0c9Ca71d3DcCD1282EE9de4F811E50aF
    // CFX:     100F3f74125C8c724C7C0eE81E4dd5626830dD9a
    // POLYZK   1b5d39419C268b76Db06DE49e38B010fbFB5e226
    address public constant _APPROVE_PROXY =
        0x70cBb871E8f30Fc8Ce23609E9E0Ea87B6b222F58;
    // address public constant _APPROVE_PROXY = 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512;    // hardhat1
    // address public constant _APPROVE_PROXY = 0x2538a10b7fFb1B78c890c870FC152b10be121f04;    // hardhat2

    // ETH:     5703B683c7F928b721CA95Da988d73a3299d4757
    // BSC:     0B5f474ad0e3f7ef629BD10dbf9e4a8Fd60d9A48
    // OEC:     d99cAE3FAC551f6b6Ba7B9f19bDD316951eeEE98
    // LOCAL:   D49a0e9A4CD5979aE36840f542D2d7f02C4817Be
    // LOCAL2:  11457D5b1025D162F3d9B7dBeab6E1fBca20e043
    // POLYGON: f332761c673b59B21fF6dfa8adA44d78c12dEF09
    // AVAX:    3B86917369B83a6892f553609F3c2F439C184e31
    // FTM:     40aA958dd87FC8305b97f2BA922CDdCa374bcD7f
    // ARB:     d99cAE3FAC551f6b6Ba7B9f19bDD316951eeEE98
    // OP:      40aA958dd87FC8305b97f2BA922CDdCa374bcD7f
    // CRO:     40aA958dd87FC8305b97f2BA922CDdCa374bcD7f
    // CFX:     40aA958dd87FC8305b97f2BA922CDdCa374bcD7f
    // POLYZK   d2F0aC2012C8433F235c8e5e97F2368197DD06C7
    address public constant _WNATIVE_RELAY =
        0x5703B683c7F928b721CA95Da988d73a3299d4757;
    // address public constant _WNATIVE_RELAY = 0x0B306BF915C4d645ff596e518fAf3F9669b97016;   // hardhat1
    // address public constant _WNATIVE_RELAY = 0x6A47346e722937B60Df7a1149168c0E76DD6520f;   // hardhat2

    event OrderRecord(
        address fromToken,
        address toToken,
        address sender,
        address receiver,
        uint256 fromAmount,
        uint256 returnAmount
    );
    event SwapOrderId(uint256 id);
}
