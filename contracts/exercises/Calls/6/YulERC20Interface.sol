interface IERC20InYul {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from,address to,uint256 amount) external returns (bool);
    function increaseAllowance(address,uint256) external;
    function decreaseAllowance(address,uint256) external;
    function mint(address,uint256) external;
}


contract ProxyForYulContract {
    IERC20InYul target;
    constructor(IERC20InYul _target) {
        target = _target;
    }

    function getName() external view returns (string memory){
        return target.name();
    }
    function getSymbol() external view returns (string memory){
        return target.symbol();
    }
    function getDecimals() external view returns (uint256){
        return target.decimals();
    }
    function getTotalSupply() external view returns (uint256){
        return target.totalSupply();   
    }
    function getBalanceOf(address addr) external view returns (uint256){
        return target.balanceOf(addr);  
    }
    function doTransfer(address addr, uint256 amount) external returns (bool){
        target.transfer(addr, amount);
    }
    function getAllowance(address addr1, address addr2) external view returns (uint256){
        return target.allowance(addr1, addr2);
    }
    function doApprove(address addr ,uint256 amount) external returns (bool){
        target.approve(addr, amount);
    }
    function doTransferFrom(address addr1, address addr2 ,uint256 amount) external returns (bool){
        target.transferFrom(addr1, addr2, amount);
    }
    function doIncreaseAllowance(address addr, uint256 amount) external{
        target.increaseAllowance(addr, amount);
    }
    function doDecreaseAllowance(address addr, uint256 amount) external{
        target.decreaseAllowance(addr, amount);
    }
    function doMint(address addr, uint256 amount) external {
        target.mint(addr, amount);
    }
}