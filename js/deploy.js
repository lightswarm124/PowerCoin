var safemathContract = web3.eth.contract([]);
var safemath = safemathContract.new(
   {
     from: web3.eth.accounts[0],
     data: '0x6060604052346000575b60358060166000396000f30060606040525b60005600a165627a7a723058207d80d5390a5d795721e10218bd380d3b46f8f9d50de79b6b2a97a0db6abe86fb0029',
     gas: '4700000'
   }, function (e, contract){
    console.log(e, contract);
    if (typeof contract.address !== 'undefined') {
         console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
    }
 })
