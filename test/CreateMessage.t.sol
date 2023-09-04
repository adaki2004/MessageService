// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

contract CreateMessage is Test {

    function setUp() public {}

    function test_create_message_slot() view public {
        string memory unhashedMsg = "Hereby i'm sending 20 ETH to myself on the destination chain";
        address sender = 0x927a146e18294efb36edCacC99D9aCEA6aB16b95;
        bytes32 hashedMessage = keccak256(bytes(unhashedMsg));

        console.log("The hashed message we want to send cross-chain:");
        console.logBytes32(hashedMessage);

        console.log("The storge slot, which value:1 is:");
        console.logBytes32(keccak256(abi.encodePacked(sender, hashedMessage)));
    }
}
