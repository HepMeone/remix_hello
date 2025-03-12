// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract fund_get{
    uint256 MINIMUN_VALUE = 1*10**18; //USD

    AggregatorV3Interface internal priceFeed;

    mapping (address => uint256) public fundsAmount;

    uint256 constant TARGET = 100*10**18; //USD

    address  public  owner;

    uint256 deploymentTimestamp;
    uint256 lockTime; //seconds

    constructor(uint256 _lockTime){
        //sepolia
        priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        owner = msg.sender;
        deploymentTimestamp = block.timestamp;
        lockTime = _lockTime;
    }

    function pay() external  payable { 
        require(EthToUsd(msg.value)>=MINIMUN_VALUE,"You need to send minimum of 1 USD!");
        require(block.timestamp < deploymentTimestamp+lockTime ,"This operation is not allowed in");
        fundsAmount[msg.sender] = msg.value;
    }

    //预言机
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

    //change owner
    function transformerOwnership(address newowner) public onlyOwner{
        owner = newowner;
    }
    //USTD
    function EthToUsd(uint256 ethAmount) internal view returns(uint256){
        uint256 ethPrice = uint256(getChainlinkDataFeedLatestAnswer());
        return ethAmount * ethPrice / (10**8);
    }

    //contract collected get
    function getFund() external windowsClosed onlyOwner{
        require(address(this).balance >= TARGET,"Not enough 1000 USD");
        //transfer
        // payable(msg.sender).transfer(address(this).balance);

        // bool success = payable(msg.sender).send(address(this).balance);
        // require(success, "Transferring 1000 USD failed");

        //call
        bool success;
        (success, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(success, "Transferring 1000 USD failed");
    }

    function refund() external windowsClosed{
        require(EthToUsd(address(this).balance)<TARGET,"Target is enough");
        require(fundsAmount[msg.sender]!=0, "You did not send any funds!");
        
        bool success;
        (success, ) = payable(msg.sender).call{value: fundsAmount[msg.sender]}("");
        require(success,"Refund failed");
        fundsAmount[msg.sender] = 0;
    }

    modifier windowsClosed(){
        require(block.timestamp >= deploymentTimestamp+lockTime ,"This fund is not closed");
        _;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "You are not the current owner!");
        _;
    }
   
}