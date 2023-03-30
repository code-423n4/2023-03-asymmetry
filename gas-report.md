# Gas Optimization Report

##   Use custom errors rather than revert()/require() strings to save gas
<br />
When a **`revert()`** or **`require()`** statement is executed in Solidity, a string message can be passed along with it to provide context about why the function call failed. However, defining these string messages can be expensive in terms of gas cost, especially if they are used frequently in the code.

With Solidity version 0.8.4, custom errors were introduced as an alternative to using string messages. Custom errors are defined using the **`error`** keyword and can be thrown in the same way as **`revert()`** or **`require()`** statements.

Using custom errors instead of string messages can save gas cost because they don't require the allocation and storage of a string message. The cost savings per use of a custom error is approximately 50 gas. Additionally, not defining string messages also saves gas cost during deployment.

Therefore, using **`calldata`** for read-only parameters can lead to gas savings in Solidity.


    error StakingIsPaused();
    error AmountTooLow();
    error AmountTooHigh();

    function stake() external payable {
        // @audit-ok [gas] - use custom errors rather than revert()/require() strings to save gas
        if(pauseStaking)
            revert StakingIsPaused();
        if(msg.value <= minAmount)
            revert AmountTooLow();
        if(msg.value >= maxAmount)
            revert AmountTooHigh();

https://github.com/code-423n4/2023-03-asymmetry/blob/44b5cd94ebedc187a08884a7f685e950e987261c/contracts/SafEth/SafEth.sol#L64

    error UnstakingIsPaused();
    error FailedToSendEther();

    function unstake(uint256 _safEthAmount) external {
        // @audit-ok [gas] - use custom errors rather than revert()/require() strings to save gas
        if(pauseStaking)
            revert UnstakingIsPaused();

https://github.com/code-423n4/2023-03-asymmetry/blob/44b5cd94ebedc187a08884a7f685e950e987261c/contracts/SafEth/SafEth.sol#L109

        if(!sent)
            revert FailedToSendEther();
        emit Unstaked(msg.sender, ethAmountToWithdraw, _safEthAmount);


https://github.com/code-423n4/2023-03-asymmetry/blob/44b5cd94ebedc187a08884a7f685e950e987261c/contracts/SafEth/SafEth.sol#L127

<br />

## ++i/i++ should be unchecked{++i}/unchecked{i++} when it is not possible for them to overflow, as is the case when used in for- and while-loops

The unchecked keyword is new in solidity version 0.8.0, so this only applies to that version or higher, which these instances are. This saves 30-40 gas per loop.

        // Getting underlying value in terms of ETH for each derivative
        for (uint i = 0; i < derivativeCount;){
            underlyingValue +=
                (derivatives[i].ethPerDerivative(derivatives[i].balance()) *
                    derivatives[i].balance()) /
                10 ** 18;

            unchecked {
                i++;
            }
        }

https://github.com/code-423n4/2023-03-asymmetry/blob/44b5cd94ebedc187a08884a7f685e950e987261c/contracts/SafEth/SafEth.sol#L84

<br />

## State variables should be cached in stack variables rather than re-reading them from storage

When a function in Solidity accesses a state variable, it typically reads the variable's value from storage, which is a costly operation in terms of gas. However, if the same variable is accessed multiple times within the same function, it can be cached in a local stack variable to avoid the additional gas cost of reading from storage. This is because accessing a local variable is much cheaper than accessing storage.

        // Getting underlying value in terms of ETH for each derivative
        for (uint i = 0; i < derivativeCount;){
            IDerivative derivative = derivatives[i];
            underlyingValue +=
                (derivative.ethPerDerivative(derivative.balance()) *
                    derivative.balance()) /
                10 ** 18;

            unchecked {
                i++;
            }
        }

https://github.com/code-423n4/2023-03-asymmetry/blob/44b5cd94ebedc187a08884a7f685e950e987261c/contracts/SafEth/SafEth.sol#L71
https://github.com/code-423n4/2023-03-asymmetry/blob/44b5cd94ebedc187a08884a7f685e950e987261c/contracts/SafEth/SafEth.sol#L113
