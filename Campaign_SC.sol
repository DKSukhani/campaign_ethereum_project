pragma solidity ^0.4.25;

contract Campaign {
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
    }
    
    address public manager;
    uint public minimumContribution;
    address[] public approvers;
    Request[] public requests; // in this line, we are specifing that an array of the name 'requests' be created and all the items in the array will be of the type 'Request'
    uint public pool;
    
    
    modifier restricted()  {
        require(msg.sender == manager);
        _;
    }
    
    constructor (uint minimum) public {
    manager = msg.sender;
    minimumContribution = minimum;
    }
    
    function contribute() public payable {
        require(msg.value >= minimumContribution);
        approvers.push(msg.sender);
        pool = pool + msg.value;
    }
    
    
    function createRequest(string description, uint value, address recipient) 
        public restricted 
    {
        // the first word 'Request' is only to mention the type of the variable
        // 'newRequest' is the name of the variable
        // the variable is being assigned an object which is based on the strcut 'Request'

        Request memory newRequest = Request({
            description: description,
            value: value,
            recipient: recipient,
            complete: false
        });
        
        requests.push(newRequest);
    }
        

    
}