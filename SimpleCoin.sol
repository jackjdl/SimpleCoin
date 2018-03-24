pragma solidity ^0.4.18;

contract SimpleCoin {

    /*
    Contract variables
    */

    mapping(address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
    string public name;
    string public symbol;
    uint public totalSupply;
    address public owner;
    address public newOwner;

    /*
    Events
    */

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event OwnershipTransferred(address indexed _from, address indexed _to);

    /*
    Constructor
    */

    // create token and give total supply to sender
    function SimpleCoin() public {
        name = "Simple Coin";
        symbol = "XSC";
        totalSupply = 1000000;
        owner = msg.sender;
        balances[owner] = totalSupply;
        emit Transfer(address(0), owner, totalSupply);
    }

    /*
    Modifier
    */

    // ensure the sender is the owner
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /*
    Getters
    */

    // getter for balance of specified owner
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    // getter for allowance of specified spender from specified owner
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    // getter for total supply, needs to be defined as is constant
    function totalSupply() public constant returns (uint) {
        return totalSupply - balances[address(0)];
    }

    /*
    Value transfer logic
    */

    // transfer value from sender to specified address
    function transfer(address _to, uint256 _value) public returns (bool success) {
        // ensure the sender has enough coins
        require(balances[msg.sender] >= _value);
        // reduce senders balance by value
        balances[msg.sender] -= _value;
        // increase receivers balance by value
        balances[_to] += _value;
        // log transfer of value
        emit Transfer(msg.sender, _to, _value);
        // success
        return true;
    }

    // transfer value from sender to specified address as a spender with given allowance
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        // get amount spender is allowed to spend
        uint256 remaining = allowed[_from][msg.sender];
        // ensure from account has enough coins and amount allowed to spend is more than value
        require(balances[_from] >= _value && remaining >= _value);
        // increase receivers balance by value
        balances[_to] += _value;
        // decrease from accounts balance by value
        balances[_from] -= _value;
        // decrease allowance by value
        allowed[_from][msg.sender] -= _value;
        // log transfer of value
        emit Transfer(_from, _to, _value);
        // success
        return true;
    }

    // approve specified address to spend the specified value on behalf of sender
    function approve(address _spender, uint256 _value) public returns (bool success) {
        // set allowance value
        allowed[msg.sender][_spender] = _value;
        // log approval
        emit Approval(msg.sender, _spender, _value);
        // success
        return true;
    }

    /*
    Ownership logic
    */

    // essentially send request to potential new owner for them to accept
    function transferOwnership(address _newOwner) public onlyOwner {
        // set potential new owner
        newOwner = _newOwner;
    }

    // as the new potential owner, accept ownership
    function acceptOwnership() public returns (bool success) {
        // ensure initiator is potential new owner
        require(msg.sender == newOwner);
        // change owner to new owner
        owner = newOwner;
        // set next potential new owner to zero-account
        newOwner = address(0);
        // log ownership transfer
        emit OwnershipTransferred(owner, newOwner);
        // success
        return true;
    }

}
