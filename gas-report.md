# Gas Optimization Report

##  Using calldata instead of memory for read-only arguments in external functions saves gas

When a function parameter is defined as **`calldata`**, it tells the EVM that the parameter is read-only and that the function will not modify the data stored at that memory location. This information allows the EVM to make optimizations, such as avoiding unnecessary memory copies when accessing the data.

The **`string`** parameter is defined as **`calldata`**, which allows the EVM to optimize the function's execution by avoiding the memory copy of the input data. On the other hand, when using **`string`** parameter as **`memory`**, which means that Solidity creates a new copy of the data in memory before executing the function, which leads to higher gas costs.

Therefore, using **`calldata`** for read-only parameters can lead to gas savings in Solidity.
