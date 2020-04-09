trigger opportunityTrigger on Opportunity (before insert, before update) {

    for(Opportunity opp : trigger.new){
        
        id oppID = opp.Id;
        id userID = opp.OwnerId;
        decimal amount = opp.Amount;
        if(opp.StageName == 'Closed Won'){
            
            opportunityHandler.updateSalesTarget(userID, amount, oppID);
            opportunityHandler.updatePosition(userID, amount, oppID);
        }
      

    }
    
}