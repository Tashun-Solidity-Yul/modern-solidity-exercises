pragma solidity ^0.6.0;

import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Callee.sol';
import '@uniswap/lib/contracts/libraries/Babylonian.sol';
import '@uniswap/lib/contracts/libraries/TransferHelper.sol';

import '@uniswap/v2-periphery/contracts/libraries/UniswapV2Library.sol';
import '@uniswap/v2-periphery/contracts/interfaces/V1/IUniswapV1Factory.sol';
import '@uniswap/v2-periphery/contracts/interfaces/V1/IUniswapV1Exchange.sol';
import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol';
import '@uniswap/v2-periphery/contracts/interfaces/IERC20.sol';
import '@uniswap/v2-periphery/contracts/interfaces/IWETH.sol';
import 'hardhat/console.sol';
import "../Problems/damnvulnerabledefi/utils/WETH9.sol";
import "@uniswap/v2-periphery/node_modules/@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
//import '@uniswap/v2-core/contracts/libraries/SafeMath.sol';

contract FreeRiderContractor is IUniswapV2Callee {
    using SafeMath  for uint;
    IUniswapV2Factory FACTORY;
    WETH9 WETH;
    uint256 balance0;
    uint256 balance1;
    uint112 _reserve0;
    uint112 _reserve1;
    uint32 a;


    event Log(string message, uint val);

    constructor(address _factory, address payable weth) public {
        FACTORY = IUniswapV2Factory(_factory);
        WETH = WETH9(weth);
    }

    // needs to accept ETH from any V1 exchange and WETH. ideally this could be enforced, as in the router,
    // but it's not possible because it requires a call to the v1 factory, which takes too much gas
    receive() external payable {}

    function doFlashSwap(address tokenBorrowed, uint256 amount) public {
        address pair = FACTORY.getPair(tokenBorrowed, address(WETH));
        require(pair != address(0), "Pair does not exist");

        address token0 = IUniswapV2Pair(pair).token0();
        address token1 = IUniswapV2Pair(pair).token1();

        uint256 amount0Out = (tokenBorrowed == token0) ? amount : 0;
        uint256 amount1Out = (tokenBorrowed == token1) ? amount : 0;

        bytes memory data = abi.encode(tokenBorrowed, amount);
        console.log("DONE123");
        IUniswapV2Pair(pair).swap(amount0Out, amount1Out, address(this), data);
        console.log("DONE");

    }

    function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external override {
        address token0 = IUniswapV2Pair(msg.sender).token0();
        address token1 = IUniswapV2Pair(msg.sender).token1();

        address pair = FACTORY.getPair(token0, token1);

        require(msg.sender == pair, "Pair is invalid");
        require(sender == address(this), "Address should be this contract");

        (address tokenBorrowed, uint256 amount) = abi.decode(data, (address, uint));

        //        uint256 fee = ((amount * 3) / 997) + 1;
        uint256 amountToRepay = amount;

        //        emit Log("Amount0", token0);
        //        emit Log("Amount1", token1);
        console.log("Amount", amount);
        console.log("amountToRepay", amountToRepay);
        console.log("tokenBorrowed", IERC20(tokenBorrowed).balanceOf(msg.sender));

        IERC20(tokenBorrowed).transfer(pair, amountToRepay);
        console.log("tokenBorrowed", IERC20(tokenBorrowed).balanceOf(msg.sender));

        balance0 = IERC20(token0).balanceOf(pair);
        balance1 = IERC20(token1).balanceOf(pair);
        (_reserve0, _reserve1, a) = IUniswapV2Pair(address(pair)).getReserves();

        uint amount0In = balance0 > _reserve0 - amount0 ? balance0 - (_reserve0 - amount0) : 0;
        uint amount1In = balance1 > _reserve1 - amount1 ? balance1 - (_reserve1 - amount1) : 0;
        require(amount0In > 0 || amount1In > 0, 'UniswapV2: INSUFFICIENT_INPUT_AMOUNT');
        uint balance0Adjusted = balance0.mul(1000).sub(amount0In.mul(3));
        uint balance1Adjusted = balance1.mul(1000).sub(amount1In.mul(3));
        console.log("_reserve0 ",_reserve0);
        console.log("_reserve1 ",_reserve1);
        console.log("balance0 ",balance0);
        console.log("balance1 ",balance1);
        console.log("amount0In ",amount0In);
        console.log("amount1In ",amount1In);
        console.log("balance0Adjusted ",balance0Adjusted);
        console.log("balance1Adjusted", balance1);
        console.log("balance1Adjusted", 15000 ether - balance1Adjusted);
        console.log(balance0Adjusted.mul(balance1Adjusted));
        console.log(uint(_reserve0).mul(_reserve1).mul(1000 ** 2));
        require(balance0Adjusted.mul(balance1Adjusted) >= uint(_reserve0).mul(_reserve1).mul(1000 ** 2), 'UniswapV2: K');

    }
}
