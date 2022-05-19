pragma solidity ^0.8.13;

contract HelloWorld {
    string public yourName;
    int public price;

constructor() public {
        yourName = "No Bid Yet" ;
        price=0;
}

function setName(string memory nm,int  p) public{
    if(p>price){
        price=p;
        yourName = nm ;
    }
}
}