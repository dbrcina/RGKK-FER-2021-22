// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Auction.sol";

contract EnglishAuction is Auction {

    uint internal highestBid;
    uint internal initialPrice;
    uint internal biddingPeriod;
    uint internal lastBidTimestamp;
    uint internal minimumPriceIncrement;

    address internal highestBidder;

    constructor(
        address _sellerAddress,
        address _judgeAddress,
        Timer _timer,
        uint _initialPrice,
        uint _biddingPeriod,
        uint _minimumPriceIncrement
    ) Auction(_sellerAddress, _judgeAddress, _timer) {
        initialPrice = _initialPrice;
        biddingPeriod = _biddingPeriod;
        minimumPriceIncrement = _minimumPriceIncrement;

        // Start the auction at contract creation.
        lastBidTimestamp = time();
    }

    function bid() public payable {
        require(outcome == Outcome.NOT_FINISHED, "Auction has finished!");
        require(time() < lastBidTimestamp + biddingPeriod, "Bidding time exceeded!");

        uint minRequiredPrice = highestBidder == address(0) ? initialPrice : highestBid + minimumPriceIncrement;

        require(msg.value >= minRequiredPrice, "Bid lower than asking price!");

        if (highestBidder != address(0)) {
            payUp(payable(highestBidder), highestBid);
        }

        highestBid = msg.value;
        highestBidder = msg.sender;
        lastBidTimestamp = time();
    }

    function getHighestBidder() public virtual override returns (address) {
        if (time() >= lastBidTimestamp + biddingPeriod) {
            Outcome outcome = highestBidder == address(0) ? Outcome.NOT_SUCCESSFUL : Outcome.SUCCESSFUL;
            finishAuction(outcome, highestBidder);
        }
        return highestBidderAddress;
    }

}