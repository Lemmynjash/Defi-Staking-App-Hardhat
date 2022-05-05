//stake
//withdraw
//claim reward
//---look for good reward mechanisam

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

error Stacking__TransferFailed();

contract Stacking {
    IERC20 public s_stackingToken;
    uint256 public s_totalSupply;
    //mapping someones address to ----> what someone has staked
    mapping(address => uint256) public s_balances;

    constructor(address stackingToken) {
        s_stackingToken = IERC20(stackingToken);
    }

    //STAKE
    function stake(uint256 amount) external {
        //STEP 1: keep track of how much stake user A has
        //STEP 2: keep track of how much token we have
        //STEP 3: transfer the tokens to the contract address which will be deployed to

        //STEP 1:
        s_balances[msg.sender] = s_balances[msg.sender] + amount;
        //STEP 2:
        s_totalSupply = s_totalSupply + amount;
        //STEP 3
        // address(this) referring to the address of the contract instance 
        // msg.sender referring to the address where the contract call originated from
        bool success = s_stackingToken.transferFrom(
            msg.sender,
            address(this),
            amount
        );

        if (!success) {
            revert Stacking__TransferFailed();
        }
    }

    //WITHDRAW
    function withdraw(uint256 amount) external {
        //STEP 1:
        s_balances[msg.sender] = s_balances[msg.sender] - amount;
        //STEP 2:
        s_totalSupply = s_totalSupply - amount;

        bool success = s_stackingToken.transfer(
            msg.sender,
            amount
        );
        if(!success){
            revert Stacking__TransferFailed();
        }
    }


    //CLAIM REWARD
    function claimReward() external {

        // How much reward they get 
        // The contract is going to emit X tokens per seconds
        // And disperse them to all token stakers
        //
        // 100 reward tokens / second
        // staked: 50 stacked tokens, 20 staked tokens, 30 staked tokens
        // rewards: 50 reward tokens, 20 reward tokens, 30 reward tokens
        // 
        // staked: 100,50,20,30 (total =200)
        // rewards: 50,25,10,15
        //
        //

    }

}
