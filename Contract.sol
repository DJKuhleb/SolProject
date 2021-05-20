pragma solidity ^0.8.4;
pragma experimental ABIEncoderV2;
import "github.com/Uniswap/uniswap-v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router02.sol";
import "github.com/Uniswap/uniswap-v2-core/blob/master/contracts/interfaces/IUniswapV2Factory.sol";
import "github.com/Uniswap/uniswap-v2-core/blob/master/contracts/interfaces/IUniswapV2Pair.sol";
/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
 
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

/**
 * Vivety
 * 
 * 
 */
contract Vivety {
    
    using SafeMath for uint256;
    
    mapping(address=>bool) private _whitelist;
    mapping(address=>uint256) public balances;
    
    
    
    struct BlockPurchase {
        uint256[] timestamp;
        uint256 t;
        uint256[] amount;
    }
    
    mapping(address=> BlockPurchase) public _blockPurchases;
    
    mapping(address=> mapping(address=> uint256)) public _allowances;
    //Owner -> {spender -> amount can spend},..,..,..
    uint256 public _totalSupply = 1000000000000000;
    string public _name = "Contract";
    string public _symbol = "CRT";
    uint8 public _decimals = 18;
    
    uint8 private constant baseTimeBalanceTax = 25;
    uint8 private constant baseTax = 5;
    
    string public _version = "0.8.4";
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    address _contractOwner;
    address _previousOwner;
    address public _contract;
    uint256 _lockTime;
    
    
    IUniswapV2Router02 public immutable uniV2Router;
    address public immutable uniswapV2Pair;
    
    
    constructor() public {
        _contractOwner = msg.sender;
        _contract = address(this);
        balances[_contractOwner] = _totalSupply;
        
        _addBlockPurchase(_contractOwner,_totalSupply);
        
        // Uniswap (Kovan): 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
        // PancakeSwap (Testnet): 0xD99D1c33F9fC3444f8101754aBC46c52416550D1
        // Pancakeswap v2 (Mainnet): 0x10ED43C718714eb63d5aA57B78B54704E256024E
        
        IUniswapV2Router02 _uniV2Router = IUniswapV2Router02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
        uniswapV2Pair = IUniswapV2Factory(_uniV2Router.factory()).createPair(address(this),_uniV2Router.WETH());
        uniV2Router = _uniV2Router;
        
        
         _whitelist[_contract] = true;
         _whitelist[_contractOwner] = true;
         emit Transfer(address(0), _contractOwner,_totalSupply);
    }
    
    
    function _addBlockPurchase(address to, uint256 amount) private returns(bool){
        require(to != address(0), 'Zero Address');
        require(amount > 0, 'Zero Amount');
        
        if(_blockPurchases[to].t == 0){
            BlockPurchase memory b;
            b.t = 1;
            _blockPurchases[to] = b;
        }
        
        if(_blockPurchases[to].t > 0){
            _blockPurchases[to].timestamp.push(block.timestamp);
            _blockPurchases[to].amount.push(amount);
        }
        
        return true;
    }
    
    modifier onlyOwner() {
        require(_contractOwner == msg.sender,'Ownable - Caller not owner.');
        _;
    }
    
    function getBlockPurchases() public view returns(uint256){
        address caller = msg.sender;
        
        BlockPurchase memory blocks = _blockPurchases[caller];
        return blocks.timestamp[0];
    }
    
    
    function balanceOf(address owner) public view returns(uint256) {
        return balances[owner];
    }
    
    function allowance(address owner, address spender) public view returns(uint256){
        return _allowances[owner][spender];
    }
    
    
    //Transfer the balance from owner's account to another account
    function transfer(address to, uint256 value) public returns(bool){
        address owner = msg.sender;
        require(value > 0, 'Why tho. You cant transfer zero');
        require(balanceOf(owner) >= value,'balance of sender too low');
        balances[to] += value;
        balances[owner] -= value;
        emit Transfer(owner,to,value);
        return true;
    }
    
    /**
     * used for a withdraw workflow, 
     * allowing contracts to send tokens on your behalf, for example to "deposit" to a 
     * contract address and/or to charge fees in sub-currencies
     */
    function transferFrom(address from, address to, uint256 value) public returns(bool){
        address owner = msg.sender;
        require(balanceOf(from) >= value,'balance too low');
        require(_allowances[from][owner] >= value,'allowance too low');
        balances[to] += value;
        balances[from] -= value;
        emit Transfer(from, to, value);
        _approve(from,owner,_allowances[from][owner].sub(value,"Transfer amount exceeds allowance"));
        return true;
    }
    
    
    function _transfer(address from, address to, uint256 amount) private {
        require(from != address(0), 'Zero Address');
        require(to != address(0), 'Zero Address');
        require(amount > 0, 'Transfer must be greater than zero!');
        
        
    }
    
    
    /**
     * Uniswap code & distribute method
     */

    receive() external payable {}
    
    
    function approve(address spender, uint256 value) public returns(bool) {
        address owner = msg.sender;
        _approve(owner,spender,value);
        return true;
    }
    
    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "zero address");
        require(spender != address(0), "zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    
    function transferOwnership(address newOwner) public onlyOwner {
        address caller = msg.sender;
        require(caller != address(0), 'Ownable - Address is Zero');
        emit OwnershipTransferred(_contractOwner,newOwner);
        _whitelist[_contractOwner] = false;
        _whitelist[newOwner] = true;
        _contractOwner = newOwner;
    }
    
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_contractOwner, address(0));
        _whitelist[_contractOwner] = false;
        _contractOwner = address(0);
    }
    
    function lockContract(uint256 time) public onlyOwner {
        _previousOwner = _contractOwner;
         emit OwnershipTransferred(_contractOwner, address(0));
        _whitelist[_contractOwner] = false;
        _contractOwner = address(0);
        _lockTime = block.timestamp + time;
    }
    
    function unlockContract() public {
        require(_previousOwner == msg.sender,"You shall not pass.");
        uint256 timePassed = _lockTime - block.timestamp;
        require(block.timestamp > _lockTime, string(abi.encodePacked('Contract is locked for ', uint2str(timePassed))));
        emit OwnershipTransferred(_contractOwner,_previousOwner);
        _contractOwner = _previousOwner;
        _whitelist[_contractOwner] = true;
    }
    
    
    function decimals() public view returns(uint8){
        return _decimals;
    }
    
    function owner() public view returns(address){
        return _contractOwner;
    }
    
    function name() public view returns(string memory){
       return _name;
    }
    
    function symbol() public view returns(string memory){
        return _symbol;
    }
    
    function totalSupply() public view returns(uint256){
        return _totalSupply;
    }
    
    function version() public view returns(string memory){
        return _version;
    }
    
    function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
    
}