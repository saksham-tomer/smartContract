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
