//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.13;
import "hardhat/console.sol";

contract Lottery {
    // declaring the state variables
    address[] public players; //dynamic array of type address payable
    address[] public gameWinners;
    address public owner;

    // declaring the constructor
    constructor() {
        owner = msg.sender;
    }

    // declaring the receive() function that is necessary to receive ETH
    receive() external payable {
        require(msg.value == 0.1 ether, "incorrect value");
        players.push(msg.sender);
    }

    // returning the contract's balance in wei
    function getBalance() public view returns (uint256) {
        require(msg.sender == owner, "ONLY_OWNER");
        return address(this).balance;
    }

    // selecting the winner
    function pickWinner() public returns (bool, bytes memory) {
        require(msg.sender == owner, "ONLY_OWNER");
        require(players.length >= 3, "  NOT_ENOUGH_PLAYERS");

        uint256 r = random();
        address winner;

        winner = players[r % players.length];

        gameWinners.push(winner);

        delete players;

        (bool success, bytes memory callBytes) = winner.call{value: getBalance()}("");
        return (success, callBytes);
    }

    // helper function that returns a big random integer
    // UNSAFE! Don't trust random numbers generated on-chain, they can be exploited! This method is used here for simplicity
    // See: https://solidity-by-example.org/hacks/randomness
    function random() internal view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        players.length
                    )
                )
            );
    }
}
