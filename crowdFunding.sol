// SPDX-License-Identifier: gpl-3.0

pragma solidity >=0.7.0 <0.9.0;

contract CrowdFunding{

    enum State{Active, Inactive}
    
    struct Project{
        string id;
        string name;
        string description;
        address payable author;
        State state;
        uint funds;
        uint fundraisingGoal;
    }

    Project public project;


    event ProjectFunded(
        string projectId,
        uint value
    );

    event ProjectStateChanged(
        string id,
        State state
    );

    constructor(string memory _id, string memory _name, string memory _description, uint _fundraisingGoal){
        
        project = Project(_id, _name, _description, payable(msg.sender), State.Active, 0, _fundraisingGoal);

    }

    modifier isAuthor(){
        require(
            msg.sender == project.author,
            "No eres el autor del projecto."
        );
        _;
    }

    modifier isNotAuthor(){
        require(
            msg.sender != project.author,
            "No puedes transferirte a vos mismo."
        );
        _;
    }

    function fundProject() public payable isNotAuthor{

        require(project.state != State.Inactive, "El projecto ya no recibe fondos.");
        require(msg.value > 0, "Los fondos invertidos deben ser mayor a 0.");

        project.author.transfer(msg.value);
        project.funds += msg.value;
        emit ProjectFunded(project.id, msg.value);
    }

    function changeProjectState(State newState) public isAuthor{

        require(project.state != newState, "El projecto ya se encuentra en ese estado.");

        project.state = newState;
        emit ProjectStateChanged(project.id, newState);
    }
}
