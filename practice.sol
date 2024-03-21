//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Datalocation{
    uint[] public arr;
    mapping(uint => address) map;
    struct MyStruct{
        uint foo;
    }
    mapping(uint => MyStruct) myStructs;
    function f() public{
        _f(arr,map,myStructs[1]);

        MyStruct storage myStruct = myStructs[1];
        myStruct memory myMemory = myStruct(0);
    }

    function _f(uint[] storage _arr, mapping(uint => address) storage _map, MyStruct storage _myStruct)internal {

    }
    function g(uint[] memory _arr) public returns(uint[] memory){}
    function h(uint[] calldata _arr) external{

    }


//function part 2

    function returnMany() public pure returns(
        uint,
        bool,
        uint
    ){
        return(1,true,2);
    }

    //return values can be named
    function named()public pure returns(uint x,bool b,uint y){
        return(2,true,54);
    }
    //return values can be assigned to their names
    //in this case the return value can be omitted
    function assigned() public pure returns(uint x, bool b,uint y){
        x=1;
        b=false;
        y = 345;
        return (x,b,y);
    }

    //using destructuring assignment when calling another function that returns multiple values.

    function destructuring() public pure returns(uint,bool,uint){
        (uint i,bool b, uint j) = returnMany();
        //values can be left out

        (uint x, uint y) = (4,5,6);

        return(i,b,j,x,y);
    }

    //cannot use mapping for input or output

    //can use array for input

    function arrayInput(uint[] memory _arr) public{}

    uint[] public arr;

    function arrayOutput()public pure returns(uint[] memory) {
        return arr;
        
    }
    //call func with key value input
    function manyInput(uint x,uint y,uint z, address a, bool b, string memory c)public pure returns(uint) {

        function callFunc()extenal pure returns(uint) {
           return manyInput(1,2,3,address(0),true,"c"); 
        }
       function cllFuncWithValue()external pure returns(uint) {
        return manyInput({a: address(0), b: true, c: "c",x:1,y: 2,z: 3}) 
       } 
    }

    //events
    //they are cheaper to store
    //upto 3 parameters can be indexed 
    //indexed params help you filter the log by the indexed parameter

    event log(address indexed sender, string message);
    event AnotherLog();
    function test() public {
        emit log(msg.sender, "hello there");
        emit log(msg.sender, "hello EVM");
        emit AnotherLog();
    }
//inheritance 
//fucntion that is going to be overriden by child contract has to be declared virtual
// func that is going to override the parent func must use override

//order is important


}
/* Graph of inheritance 
          A
        /  \
       B    C
     /  \   /  
    F    D,E 
*/
contract A{
    function foo() public pure virtual returns(string memory){
        return "a";
    }
}

contract B is A {
    function foo() public pure vitual override returns(string memory){
        return "b";
    }
}

contract C is A {
    function foo() public pure virtual override returns(string memory){
        return "C";
    }
    //contracts can inherit from multiple parent contracts 
    //when a function is called that is defined multiple times in different contracts parent contracts are searched from right to left and in depth first manner

    
}
contract D is B,C{
    //D.foo returns "c" 
    //since C is the right most parent contract with function foo(A)
   function foo() public pure override(B,C) returns(string memory){
    return super.foo();
   }
}

contract E is C,B{
    //E.foo returns "b
    //since B is the right most parent contract with function foo
function foo() public pure override(C,B) returns(string memory){
    return super.foo();
   }
}
//Inheritance must be ordered from "most base-like  to most derived 
//swapping the order of A and B will throw a compilation error

//Shadowing effect
//state var cannot be overriden in the child contract by redelcaring
//you have to reinitiaze them like using a constructor  


contract A{
    string public name = "saksham";
    function foo() public pure returns(string memory){
        return name;
    }
}

contract B is A{
    constructor(){
        name = "tomar";
    }
}

//interface 
//to interact between two contracts in sol
contract base{
    uint public count;
    function increment()external{
        count += 1;
    }
}

interface ICounter{
    function count() external view returns(uint);
    function increment() external;
}

contract myContract{
    function incrementCounter(address _counter) external{
        ICounter(_counter).increment();
    }

    function getCount(address _counter) external view returns(uint){
            return ICounter(_counter).count();
    }
}

//uniswap examples

interface UniswapV2Factory{
    function getPair(address tokenA, address tokenB)
    external view returns(address pair);
}
interface UniswapV2Pair{
    function getReserves()
    external view returns(
        uint112 reserve0;
        uint112 reserve1;
        uint32 blockTimestampLast;
    )
}

contract UniswapExample{
    address private factory = 0xh32j5h235jkl1k512ljk41jk24;
    address private dai = 0xh32j5h235jkl1k512ljjfjabnjk35h;
    address private weth = 0xh32j5h235jkl1k512l52j3h55413j;

    function getTokenReserves() external view returns(uint,uint){
        address pair = UniswapV2FAactory(factory).getPair(dai,weth);
        (uint reserve0, uint reserve1) = UniswapV2Pair(pair).getReserves();
        return (reserve0, reserve1);
    }
}

//payable --> makes contract able to receive ether
//payable address can receive ether

contract Payable{
    address public payable owner;
    //payable constructor can also recieve ether
    constructor payable(){
        owner = payable(msg.sender);
    }
    //func to deposit ether into this contract
    //call the function along with some ether
    //the balance of this contract will be automatically updated;
    function deposit(address _addr) public payable{

    }
    //non payable func
    function notPayable() public{}

    //func to withdraw all ether from this contract 
    function withdraw() public {
        uint amount = address(this).balance;
        //send all ether to owner 
        //owner can receive ether since the address of owner is payable

        (bool success,) = owner.call{value: amount}("");
        require(success, "Failed to send ether");
    }
    //function to transfer ether from this contract to address from input
    function transfer(address payable _to, uint _amount) public {
        (bool success, ) = owner.call{value: _amount}("");
        require(success, "failed to send ether");
    }

}

//ether transfering methods
//transfer(2300 gas, throws error)
// send(2300 gas, returns bool)
//call (forward all gas or set gas, returns bool)

contract RecieveEther{
    /*
    which function is called ,fallback()  or receive()

                    send Ether
                         |
                 msg.data is empty?
                        /   \
                       yes   no
                     /         \
        receive() exists?      fallback()  


    */

    //function to receive ether msg.data must be emoty

    receive() external payable{}
    //fallback func is called when msg.data is not empty
    function getBalace()public view returns(uint){
        return address(this).balance;
    }
}
contract sendEther{
    function sendViaTransfer(address payable _to) public payable {
        //this is no longer recommended
        _to.transfer(mgs.value);
    }

    function sendViaSend(address payable _to) public payable{
       
        //this func returns a bool value indicating success or failure
        //this is also not recommended
       bool sent = _to.send(msg.value);
       require(sent,"Filed to send ether);
    }

    function sendViaCall(address payable _to) public payable{
        //call returns a bool value indicating success or failure
        //this is recommended
        (bool sent, bytes memory data) = _to.call{value: msg.value}("");
        require(sent, "Failed to send ether");
    }
}

//fallback

contract fallback{
    event log(string func, uint gas);

    //fallback func must be declared as external
    fallback() external payable{
        //send / transfer (forward 2300 gas to this fallback function)
        //call (forwards all the gas)
        emit log("fallback", gasleft());
    }
    //receive is a variant of fallback which is triggered when the msg.data is empty

    receive() external payable{
        emit log("receive", gasleft());
    }
    //helper func to check the baclance of this contract 
    function getBalance() public view returns(uint){
        return address(this).balance;
    }

}
contract sendToFallback{
    function transferToFallback(address payable _to) public payable {
        _to.transfer(msg.value);
    }
    function callFallback(address payable _to)public payable{
        (bool sent,) = _to.call{value: msg.value}("");
        require(sent,"failed to send Ether");
    }
}
//call function
contract Receiver{
    event Received(address caller, uint amount, string message);

    fallback() external payable {
        emit Received(msg.sender, msg.value, "fallback was called");
    }
    function foo(string memeory  _message,uint _x )public payable returns(uint){
        emit Received(msg.sender, msg.value,_message);

        return _x +1;
    }
}

contract caller{
    event Response(bool success, bytes data);

    //lets imagine that the source caller doesnt have the souce code for the contract Receiver, but we dont know the address of contract receiver and the function to call

    function testCallFoo(address payable _addr)public payable{
        //you can send ether and specify a custom gas amount 

        (bool success, bytes memory data) = _addr.call{value: msg.value, gas: 5000}(abi.encodeWithSignature("foo(string,uint256)", "call foo",123));


        emit Response(success,data);
    }

    //calling a function that does not exist triggers the fallback function 
    function testCallDoesNotExist(address payable _addr)public payable{
        (bool success, bytes memory data) = _addr.call{value: msg.value}(
            abi.encodeWithSignature("doesNotExist()")
        );
        emit Response(success,data);
        )
    }
}
//delegatecall is a low-level Solidity function that allows a contract to execute code from another contract while maintaining the context of the calling contract. It is often used in advanced smart contract development scenarios such as proxy contracts, upgradable contracts, and libraries.


//delegate call
contract B{
    //storage layout must be same as contract A
    uint public num;
    address payable sender;
    uint public value;

    function setVars(uint _num) public payable{
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}


contract A{
    uint public num;
    address payable sendder;
    uint public value;

    function serVars(address _contract, uint _num)public payable{
        //A storage is set , B is not modified
        (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num);
        )
    }
}

//calling other contracts
contract Callee{
    uint public x;
    uint public value;

    function setX(uint _x) public returns(uint){
        x= _x;
        return x;
    }

    function setXandSendEther(uint _x)public payable returns(uint,uint){
        x=_x;
        value = msg.sender;
        return (x,value);
    }

}

contract Caller{
    function setX(Callee _callee, uint _x)public {
        uint x = _callee.setX(_x);

    }
    function setXFromAddress(address _addr, uint _x)public  {
        Callee callee = Callee(_addr) ;
        callee.setX(_x);
    }

    function setXandSendEther(Callee _callee, uint _x)public payable{
        (uint x, uint value) = _callee.setXandSendEther{value: msg.value}(_x);
    }
}




























