pragma solidity ^0.4.8;

contract PowerDelivery {

    // Parties
	Node public feed_in;  				// Entity commited to feed into the grid
	Node public feed_out;				// Entity commited to take power of grid
	Node public product_owner;

	// Date/Times
	uint256 public time_start;				// starting time of delivery
	uint256 public time_end;				// end time of delivery

	// Regulation/Approvals
	Termination public Termination_owner;

	// Commitment
	uint256 public total_power;				// Total Power (Wh) covered by contract
	uint256 public peak_load;				// Maximum peak Load covered by contract (Max W)
	uint256 public min_load;				// Minimum Load covered by contract (Min W)

	uint256 public bid_in;					// Required amount of primary currency in order to close contract
	uint256 public ask_out;

	uint256 public delivered_in;
	uint256 public delivered_out;

	// Balancing
	SubBalance public subbalance_in;
	SubBalance public subbalance_out;
	bool public openedBalances;
	bool public closedBalances;
	bool haspeer;

	function PowerDelivery(bool _is_feedin,uint256 _time_start,uint256 _time_end,uint256 _total_power,uint256 _peak_load,uint256 _min_load,Termination _Termination_owner,uint256 _bid) {
		 if(_Termination_owner.nodes(msg.sender)!=1) throw;

		 if(_time_start>0) {
			 time_start=_time_start;
		} else { time_start=now +86400;}
		 if(_time_end>0) {
		 	time_end=_time_end;
		 } else {time_end=time_start+86400;}
		 total_power=_total_power;
		 peak_load=_peak_load;
		 min_load=_min_load;
		 product_owner=Node(msg.sender);
		 Termination_owner=_Termination_owner;
		 bid_in=_bid;
		 ask_out=_bid;
		 if(_is_feedin) {
			feed_in=Node(msg.sender);
			ask_out=_bid;

		} else {
			feed_out=Node(msg.sender);
			bid_in=_bid;
		 }
		 openedBalances=false;
		 closedBalances=false;
		 haspeer=false;
	 }


	 function sellFeedIn(uint256 _bid_in) {

		 if(time_start<now) throw;
		 if((feed_in==product_owner)&&(Node(msg.sender)!=product_owner)) throw;
		 if(!testTermination(Node(msg.sender))) throw;
		 if(_bid_in>ask_out) throw;

		  if(_bid_in<bid_in) {
				feed_in=Node(msg.sender);
				 bid_in=_bid_in;
				 haspeer=true;
			 } else {
				 throw;
			 }


	}

	function buyFeedOut(uint256 _ask_out) {
		if(time_start<now) throw;
		if((feed_out==product_owner)&&(Node(msg.sender)!=product_owner)) throw;
		if(!testTermination(Node(msg.sender)))throw;
		if(_ask_out<bid_in) throw;


		if(_ask_out>ask_out) {
				 feed_out=Node(msg.sender);
				 ask_out=_ask_out;
				 haspeer=true;
			} else {
				throw;
			}

	}

	function openSubBalance() {
		if((!openedBalances)&&(haspeer)) {
			if((now>=time_start)&&(now<=time_end)) {
				subbalance_in=feed_in.metering().openSubBalance(feed_in,this);
				subbalance_out=feed_out.metering().openSubBalance(feed_out,this);
				openedBalances=true;
			}
		}
	}

	function closeSubBalance() {
		if(!openedBalances) throw;
		if(time_end<=now) {
				feed_in.metering().closeSubBalance(subbalance_in);
				feed_out.metering().closeSubBalance(subbalance_out);
				closedBalances=true;
		}
	}

	function deliveredIn(uint256 _value) {
		if(SubBalance(msg.sender)!=subbalance_in) throw;
		delivered_in+=_value;
	}

	function deliveredOut(uint256 _value) {
		if(SubBalance(msg.sender)!=subbalance_out) throw;
		delivered_out+=_value;
	}


	function testTermination(Node a) returns(bool) {
		return Termination_owner.test(a);
	}

	function() {
		if(msg.value>0) {
			product_owner.send(msg.value);
		}
	}
}
