//stake
//withdraw
//claim reward
//---look for good reward mechanisam

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

error Staking__TransferFailed();
error Staking__NeedMoreThanZero();

contract Staking {
    IERC20 public s_stackingToken;
    IERC20 public s_rewardsToken;

    uint256 public s_totalSupply;
    //mapping someones address to ----> what someone has staked
    mapping(address => uint256) public s_balances;
    // a mapping of how much each address has been paid
    mapping(address => uint256) public s_userRewardPerTokenPaid;
    // a mapping of how much rewards each address has TO CLAIM
    mapping(address => uint256) public s_rewards;

    uint256 public constant REWARD_RATE = 100;
    uint256 public s_totalSupply;
    uint256 public s_rewardPerTokenStored;
    uint256 public s_lastUpdateTime;

    modifier updateReward(address account) {
        // get how much reward per token
        // last timestamp
        s_rewardPerTokenStored = rewardPerToken();
        s_lastUpdateTime = block.timestamp;
        //we can see in person/ in total how a person has earned
        s_rewards[accounts] = earned(account);
        s_userRewardPerTokenPaid[account] = s_rewardPerTokenStored;
        _;
    }

    modifier moreThanZero(uint256 amount) {
        if(amount==0){
            Stacking__NeedMoreThanZero();
        }
        _;
    }
    constructor(address stackingToken, address rewardsToken) {
        s_stackingToken = IERC20(stackingToken);
        s_rewardsToken = IERC20(rewardsToken);
    }

    function earned(address account) public view returns (uint256){
        uint256 currentbalance = s_balances[account];
        //how much they have paid already
        uint256 amountPaid = s_userRewardPerTokenPaid[account];
        uint256 currentRewardPerToken = rewardPerToken();
        uint256 pastRewards = s_rewards[account];
        uint256 earned = ((currentbalance * (currentRewardPerToken - amountPaid)) / 1e18) + pastRewards;
        return earned;
    }

    function rewardPerToken() public view returns (uint256) {
        if (s_totalSupply == 0) {
            return s_rewardPerTokenStored;
        }
        return
        s_rewardPerTokenStored + (((block.timestamp - s_lastUpdateTime) * REWARD_RATE * 1e18) / s_totalSupply);
    }

    //STAKE
    function stake(uint256 amount) external updateReward(msg.sender) moreThanZero(amount){
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
    function withdraw(uint256 amount) external updateReward(msg.sender) moreThanZero(amount) {
        //STEP 1:
        s_balances[msg.sender] = s_balances[msg.sender] - amount;
        //STEP 2:
        s_totalSupply = s_totalSupply - amount;

        bool success = s_stackingToken.transfer(msg.sender, amount);
        if (!success) {
            revert Stacking__TransferFailed();
        }
    }

    //CLAIM REWARD
    function claimReward() external updateReward(msg.sender) {
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

        uint256 rewards = s_rewards[msg.sender];
        bool success = s_rewardsToken.transfer(msg.sender, rewards);
        if (!success) {
            revert Stacking__TransferFailed();
        }
    }
}
