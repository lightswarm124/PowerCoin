contract Termination {
	address public owner;
	//Termination[] public peers;
    address[] public peers;
    mapping (address => uint) public nodes;
	mapping (address => uint) public meterings;
	event TestTermination (address _sender,address _target);

	function Termination () {
		owner = msg.sender;
	}

	function addPeer (address _peer) {
		if (msg.sender != owner) throw;
		peers.push(_peer);
	}

	function removePeer (address _peer) {
		if (msg.sender!=owner) throw;
		for (uint i = 0 ; i < peers.length ; i++) {
			if (peers[i] == _peer) {
				delete peers[i];
			}
		}
	}

    // @Dev rename param
    function addMetering (address a) {
        if (msg.sender != owner) throw;
        meterings[a] = 1;
    }
/*

	function removeMetering(address a) {
		if(msg.sender!=owner) throw;
		meterings[a]=2;
	}

	function addNode(Node _node) {
		if(msg.sender!=owner) throw;
		if(meterings[_node.metering()]!=1) throw;
		_node.transferTermination(this);
		nodes[_node]=1;
	}

	function removeNode(Node _node) {
		if(msg.sender!=owner) throw;
		nodes[_node]=2;
	}

	function test(Node d) returns(bool) {
		return test(d,this);
	}

	function test(Node _delivery,Termination callstack) returns (bool) {
		TestTermination(msg.sender,_delivery);
		if(nodes[_delivery]==1) return true;

		for(uint i=0;i<peers.length;i++) {
				if(peers[i].test(_delivery,this)) return true;
		}
		return false;
	}
*/

	function () {
		if (msg.value>0) {
			owner.send(msg.value);
		}
	}
}
