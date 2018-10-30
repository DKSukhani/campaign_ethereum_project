pragma solidity ^0.4.25;

contract CampaignFactory {
    // declaring the storage varaibles
    address[] public demployedCampaigns;

    // creating the function, which will deploy a new instance of the CampaignContract
    function createCampagin(uint minimumContribution) public {
        address newCampaign = new Campaign(minimumContribution, msg.sender);
        // specifying the above msg.sender will be used in passing the person's address who wants a new Campaign contract to be created to be passed to the Campaign Contract
        // the assignment is to store the address of the new Campaign Contract only


        demployedCampaigns.push(newCampaign);
        // pushing the address of the new Campaign contract to our array of all contracts
    }

    function deployedCampaigns() public view returns(address[]){
        return demployedCampaigns;
        // getting the entire array in one go

    }
}


contract Campaign {
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        // we will be only counting the yes votes
        mapping (address=>bool) accountsThatApproved;
    }
    
    
    // declaring the storage variables
    address public campaignCreator;
    uint public minimumContribution;
    mapping (address=>bool) public approvers;  
        // the 'approvers' field could be an array, but it would cost a hell lot more to search through the array to find out the addresses which are in the approver
    uint public totalNumberofContributers;

    Request[] public requests; 
        // in this line, we are specifing that an array of the name 'requests' be created and all the items in the array will be of the type 'Request' (which is a struct)  that means that each item of the array will have the fields that are specified in the struct

    uint public totalPoolSize;
    
    
    
    // it is typical to specify your key modifier function before the constructor function

    
    constructor (uint minimum, address creator) public {
    minimumContribution = minimum; campaignCreator = creator;
    }
        //when this contstructor function is executed, it receives the minimum amount from the CampaignFactory contract (above) and also receives the 'msg.sender' field.  The msg.sender is then referred to as the 'creator' variable over here. 'creator' is the local/memory variable over here.  creator(aka the msg.sender is then passed on to the storage variable campaignCreator.  campaignCreator is used in the modified function)


    modifier restricted()  {
        require(msg.sender == campaignCreator);
        _;
    }
    
    function contribute() public payable {
        require(msg.value >= minimumContribution);
        
        // dipesh to edit this - to see if there is way to call the below function only upon receiving the mined tx hash 
        approvers[msg.sender] = true;
        // had the approvers variable been an array, we would have done approvers.push(msg.sender)
        
        // dipesh to edit this - to see if there is way to call the below function only upon receiving the mined tx hash
        totalPoolSize = totalPoolSize + msg.value;
        totalNumberofContributers++;
        
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
            complete: false,
            approvalCount: 0
        });
        
        requests.push(newRequest);
    }
        


    function approveRequest (uint index) public {
        // this is a local variable only to make the code look neater and smaller
        Request storage localRequestVaraible = requests[index];
        // the first 'Request' is to provide a type of the local variable that we are creating
        // the reason to make this as a 'storage' variable is because through the variable we want to access the actual request[index] and not a copy of it that would be created if we would have used a 'memory' variable

        require(approvers[msg.sender]);

        require(!localRequestVaraible.accountsThatApproved[msg.sender]);

        localRequestVaraible.accountsThatApproved[msg.sender] = true;

        localRequestVaraible.approvalCount ++;
        
    } 

    function finalizeRequest(uint index) public restricted {
        Request storage localRequestVaraible = requests[index];
        require(!localRequestVaraible.complete);
        require(localRequestVaraible.approvalCount >= (totalNumberofContributers/2) + 1);
        localRequestVaraible.recipient.transfer(localRequestVaraible.value);

        
        localRequestVaraible.complete = true;
    }

    
}