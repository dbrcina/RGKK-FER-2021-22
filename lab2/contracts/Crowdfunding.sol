// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Timer.sol";

/// This contract represents most simple crowdfunding campaign.
/// This contract does not protects investors from not receiving goods
/// they were promised from crowdfunding owner. This kind of contract
/// might be suitable for campaigns that does not promise anything to the
/// investors except that they will start working on some project.
/// (e.g. almost all blockchain spinoffs.)
contract Crowdfunding {

    address private owner;

    Timer private timer;

    uint256 public goal;

    uint256 public endTimestamp;

    mapping(address => uint256) public investments;

    // Use this variable instead of address(this).balance, because of:
    // "A contract without a receive Ether function can receive Ether as a recipient of a coinbase transaction
    // (aka miner block reward) or as a destination of a selfdestruct"
    // https://docs.soliditylang.org/en/latest/contracts.html#receive-ether-function
    uint256 private totalInvestment;

    constructor(
        address _owner,
        Timer _timer,
        uint256 _goal,
        uint256 _endTimestamp
    ) {
        owner = (_owner == address(0) ? msg.sender : _owner);
        timer = _timer; // Not checking if this is correctly injected.
        goal = _goal;
        endTimestamp = _endTimestamp;
        totalInvestment = 0;
    }

    function invest() public payable {
        require(timer.getTime() < endTimestamp, "Funding period has expired!");
        require(totalInvestment < goal, "Enough funds already gathered!");

        investments[msg.sender] += msg.value;
        totalInvestment += msg.value;
    }

    function claimFunds() public {
        require(msg.sender == owner, "Only owner can take funds!");
        require(timer.getTime() >= endTimestamp, "Funding is still in progress!");
        require(totalInvestment >= goal, "Not enough funds gathered!");

        payUp(payable(owner), totalInvestment);
    }

    function refund() public {
        require(timer.getTime() >= endTimestamp, "Funding is still in progress!");
        require(totalInvestment < goal, "Goal has been reached; refunds not available!");

        uint256 amount = investments[msg.sender];
        investments[msg.sender] = 0; // Prevent reentrancy attacks.
        payUp(payable(msg.sender), amount);
    }

    function payUp(address payable _to, uint256 _amount) private {
        (bool success,) = _to.call{value : _amount}("");
        require(success, "Transfer failed!");
    }

}