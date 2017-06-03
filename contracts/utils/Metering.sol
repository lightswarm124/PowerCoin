pragma solidity ^0.4.8;

contract Metering {
	address public owner;
	mapping (address => Meter) public meters;
	mapping (address => Node) public nodes;
//	SubBalance[] subbalances;


	function Metering () {
		owner = msg.sender;
	}
/*
	function addMeter(Meter meter,Node _node) {
		if(msg.sender!=owner) throw;
		meters[_node]=meter;
		nodes[meter]=_node;
	}

	function openSubBalance(Node n,PowerDelivery pd) returns (SubBalance) {
		if(n.metering()!=this) throw;
		// TODO Add Trigger Que for start/stop reading
		SubBalance sb = new SubBalance(n,pd);
		subbalances.push(sb);
		return sb;
	}

	function closeSubBalance(SubBalance sb) {
		if(sb.node().metering()!=this) throw;
		for(var i=0;i<subbalances.length;i++) {
			if(subbalances[i]==sb) {
				// if there is still something due we have to add it here
				uint256 add_debit = subbalances[i].closeBalance();
				Meter m = Meter(meters[sb.node()]);
				m.addPDclosingDebit(add_debit);
				delete subbalances[i];
			}
		}
	}

	function updateReading(Meter m,uint256 reading_time,uint256 reading_value) {
		if(msg.sender!=owner) throw;
		if(nodes[m].metering()!=this) throw;
		// do clearing
		Node n= nodes[m];
		uint256 add_credit=0;
		uint256 add_debit=0;
		uint256 last_value=m.last_reading_value();
		uint256 last_time=m.last_reading_time();
		if(reading_time==0)reading_time=now;
		uint256 balancable=reading_value-last_value;
		for(var i=0;((i<subbalances.length)&&(balancable>0));i++) {
				if(subbalances[i].node()==n) {
					if(m.feed_in()==subbalances[i].isFeedin()) {
						balancable-=subbalances[i].applyBalance(balancable);
					}
				}
		}
		add_credit=(reading_value-last_value)-balancable;
		add_debit=balancable;
		m.updateReading(reading_value,reading_time,add_debit,add_credit);
	}

	function() {
		if(msg.value>0) {
			owner.send(msg.value);
		}
	}
*/
}
