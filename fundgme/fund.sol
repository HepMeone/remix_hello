// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract fund_get{
    uint256 MINIMUN_VALUE = 0.01*10**18; //USD
    AggregatorV3Interface internal priceFeed;
    mapping (address => uint256) public fundsAmount;

    constructor(){
        //sepolia
        priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    function pay() external  payable { 
        require(EthToUsd(msg.value)>=MINIMUN_VALUE,"You need to send minimum of 1 ETH!");
        fundsAmount[msg.sender] = msg.value;
    }

     function getChainlinkDataFeedLatestAnswer() public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        return answer;
    }

    function EthToUsd(uint256 ethAmount) internal view returns(uint256){
        uint256 ethPrice = uint256(getChainlinkDataFeedLatestAnswer());
        return ethAmount * ethPrice / (10**8);
    }
}