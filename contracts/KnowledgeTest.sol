//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract KnowledgeTest {
    string[] public tokens = ["BTC", "ETH"];
    address[] public players;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    function changeTokens() public {
        string[] storage t = tokens;
        t[0] = "VET";
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function transferAll(address _address) public returns (bool, bytes memory) {
        require(msg.sender == owner, "ONLY_OWNER");
        (bool success, bytes memory returnBytes) = _address.call{value: address(this).balance}("");
        return (success, returnBytes);
    }

    function start() public {
        players.push(msg.sender);
    }

    function concatenate(string calldata a, string calldata b) public pure returns (string memory) {
        return string(abi.encodePacked(a, b));
    }
}
