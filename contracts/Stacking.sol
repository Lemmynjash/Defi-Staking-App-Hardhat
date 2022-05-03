//stake
//withdraw
//claim reward
//---look for good reward mechanisam

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Stacking {
    IERC20 public s_stackingToken;

    constructor(address stackingToken) {
        s_stackingToken = IERC20(stackingToken);
    }

    function stake(uint256 amount) external {

        //keep track of how much stake user A has
        //keep track of how much token we have
        //transfer the tokens to the contract address which will be deployed to
        
         
    }
}
