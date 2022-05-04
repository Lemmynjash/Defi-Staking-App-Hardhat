//stake
//withdraw
//claim reward
//---look for good reward mechanisam

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Stacking {
    IERC20 public s_stackingToken;
    uint256 public s_totalSupply;
    //mapping someones address to ----> what someone has staked
    mapping(address => uint256) public s_balances;

    constructor(address stackingToken) {
        s_stackingToken = IERC20(stackingToken);
    }

    function stake(uint256 amount) external {
        //STEP 1: keep track of how much stake user A has
        //STEP 2: keep track of how much token we have
        //STEP 3: transfer the tokens to the contract address which will be deployed to

        //STEP 1:
        s_balances[msg.sender] = s_balances[msg.sender] + amount;
        //STEP 2:
        s_totalSupply = s_totalSupply + amount;
        //STEP 3
        bool success = s_stackingToken.transfer(
            msg.sender,
            address(this),
            amount
        );
    }
}
