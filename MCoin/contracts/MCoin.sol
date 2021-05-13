//CdBy mand0mb3
pragma solidity >=0.4.22 <0.9.0;

import "./IERC20.sol";
import {base} from "./Math.sol";

contract MCoin is IERC20{

    using base for uint256;

    uint256 private coinTotalSupply;
    bytes8 private coinName;                   
    uint8 private coinDecimals;                
    bytes4 private coinSymbol;
    uint private limitTime;
    uint8 private donateBalance;

    struct Account{
        uint32 id;
        string name;
        uint256 balance;
    }

    mapping(address=>Account) private proprietarios;
    mapping(address=>mapping(address=>uint256)) private allowed; 

    modifier someOneReal(address someone){
        require(someone!=address(0), "Endereco Invalido!");
        _;
    }
    modifier onlyReal(){
        require(msg.sender!=address(0), "Endereco Invalido!");
        _;
    }
    modifier onlyExchange(){
        require(proprietarios[msg.sender].id==0, "Endereco Invalido!");
        _;
    }
    modifier onlyRealAccount(){
        require(msg.sender!=address(0), "Endereco Invalido!");
        require(proprietarios[msg.sender].id==0, "Conta Invalido!");
        _;
    }

    constructor(bytes8 _name, uint8 _decimal, bytes4 _symbol, uint8 _donateBalance) public{
        coinName = _name;
        coinDecimals = _decimal;
        coinSymbol = _symbol;
        limitTime = block.timestamp;
        donateBalance = _donateBalance;
    }

    function donateCoin(uint32 _id, string memory _name) public onlyReal returns(bool){
        require(proprietarios[msg.sender].id==0, "Conta Ja Existente!");
        require(block.timestamp <= limitTime + 2 hours, "Tempo Esgotado!");
        proprietarios[msg.sender]=Account({id:_id, name:_name, balance:donateBalance});
        return true;
    }


    function name()  public  view returns (bytes8){
        return coinName;
    }
    function symbol() public  view returns (bytes4){
        return coinSymbol;
    }
    function decimals() public  view returns (uint8){
        return coinDecimals;
    }

    function totalSupply() public view  returns (uint256){
        return coinTotalSupply;
    }
    function balanceOf(address account) public  view someOneReal(account) returns (uint256){
        return proprietarios[account].balance;
    }
//    function transfer(address recipient, uint256 amount) public onlyExchange returns (bool){}
    function allowance(address owner, address spender) public  view someOneReal(owner) someOneReal(spender) returns (uint256){
        return allowed[owner][spender];
    }
    function approve(address spender, uint256 amount) public  onlyRealAccount returns (bool){
        allowed[msg.sender][spender] = amount;
        return true;
    }
    function transferFrom(address sender, address recipient, uint256 amount) public  onlyExchange returns (bool){
        uint256 allowedValue = allowed[sender][msg.sender];
        require(proprietarios[sender].balance >= amount && allowedValue>=amount, "Impossivel efectuar a transacao, valor insuficiente");
        proprietarios[sender].balance -= amount;
        proprietarios[recipient].balance += amount;
        allowed[sender][msg.sender] -= amount;

        return true;
    }
}