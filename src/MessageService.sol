// SPDX-License-Identifier: MIT
//  _____     _ _         _         _
// |_   _|_ _(_) |_____  | |   __ _| |__ ___
//   | |/ _` | | / / _ \ | |__/ _` | '_ (_-<
//   |_|\__,_|_|_\_\___/ |____\__,_|_.__/__/

pragma solidity ^0.8.20;

import { LibSecureMerkleTrie } from "./thirdparty/LibSecureMerkleTrie.sol";

/// @title MessageService
/// @notice The MessageService contract serves as a secure cross-chain message
/// passing system. It defines methods for sending and verifying Messages with
/// merkle proofs.
contract MessageService {
    struct MessageProof {
        uint64 height;
        bytes proof; // A storage proof
    }

    constructor(){}

    /// Setting a slot's:
    // (keccak256(abi.encodePacked(msg.sender, Message))) value to '1'
    function sendMessage(bytes32 messageHash)
        public
        returns (bytes32 storageSlot)
    {
        storageSlot = getMessageSlot(msg.sender, messageHash);
        assembly {
            sstore(storageSlot, 1)
        }
    }

    /// Called on the souce-chain smart contract
    function isMessageSent(
        address sender,
        bytes32 Message
    )
        public
        view
        returns (bool)
    {
        bytes32 slot = getMessageSlot(sender, Message);
        uint256 value;
        assembly {
            value := sload(slot)
        }
        return value == 1;
    }

    /// Called on the destination chain smart contract
    /// with proof (eth_getProof)
    function verifySourceChainMessage(
        address sender,
        bytes32 messageHash,
        bytes32 syncedMessageRoot, // This has to be synchnorized via an automated mechanism
        bytes calldata proof
    )
        public
        pure
        returns (bool)
    {
        // Here could come the logic, so in case the value is indeed
        // 1 then release funds on the destination chain.
        return LibSecureMerkleTrie.verifyInclusionProof(
            bytes.concat(getMessageSlot(sender, messageHash)),
            hex"01",
            proof,
            syncedMessageRoot
        );
    }

    /// @notice Get the storage slot of the Message.
    /// @param sender The address that initiated the Message.
    /// @param message The Message to get the storage slot of.
    /// @return messageSlot The unique storage slot of the Message which is
    /// created by encoding the sender address with the Message (message).
    function getMessageSlot(
        address sender,
        bytes32 message
    )
        public
        pure
        returns (bytes32 messageSlot)
    {
        // Equivalent to `keccak256(abi.encodePacked(sender, message))`
        assembly {
            // Load the free memory pointer
            let ptr := mload(0x40)
            // Store the sender address and Message bytes32 value in the allocated
            // memory
            mstore(ptr, sender)
            mstore(add(ptr, 32), message)
            // Calculate the hash of the concatenated arguments using keccak256
            messageSlot := keccak256(add(ptr, 12), 52)
            // Update free memory pointer
            mstore(0x40, add(ptr, 64))
        }
    }
}
