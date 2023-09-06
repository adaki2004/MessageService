// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

contract CreateMessage is Test {

    function setUp() public {}

    function test_create_message_slot() view public {
        string memory unhashedMsg = "Hereby i'm sending 20 ETH to myself on the destination chain";
        address sender = 0x927a146e18294efb36edCacC99D9aCEA6aB16b95;
        bytes32 hashedMessage = keccak256(bytes(unhashedMsg));

        console.log("The message hash:");
        console.logBytes32(hashedMessage);

        console.log("The storge slot, which value shall be 1 if we sent the above message:");
        console.logBytes32(keccak256(abi.encodePacked(sender, hashedMessage)));
    }
}
