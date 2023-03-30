# QA Report (low/non-critical)

##   Use custom errors rather than revert()/require() strings to save gas

<br />

Using 1 ether instead of 10 ** 18 makes it easier to read and write code. It also helps to avoid errors that can occur when working with large numbers, such as forgetting to include the correct number of zeros. Additionally, using 1 ether makes the code more readable and easier to understand for other developers who may not be as familiar with the intricacies of the Ethereum blockchain.

    (derivative.ethPerDerivative(derivative.balance()) *
        derivative.balance()) / 1 ether;

https://github.com/code-423n4/2023-03-asymmetry/blob/44b5cd94ebedc187a08884a7f685e950e987261c/contracts/SafEth/SafEth.sol#L75

    function initialize(
        string memory _tokenName,
        string memory _tokenSymbol
    ) external initializer {
        ERC20Upgradeable.__ERC20_init(_tokenName, _tokenSymbol);
        _transferOwnership(msg.sender);
        minAmount = 0.5 ether; // initializing with .5 ETH as minimum
        maxAmount = 200 ether; // initializing with 200 ETH as maximum
    }

https://github.com/code-423n4/2023-03-asymmetry/blob/44b5cd94ebedc187a08884a7f685e950e987261c/contracts/SafEth/SafEth.sol#L48