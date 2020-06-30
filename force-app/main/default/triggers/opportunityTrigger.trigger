trigger opportunityTrigger on Opportunity (after insert, after update) {

    Set<Id> usersToUpdate = new Set<Id>();

    for(Opportunity opp : Trigger.new){
        if(opp.StageName == 'Closed Won'){
            usersToUpdate.add(opp.OwnerId);
        }
    }

    for(Id userId : usersToUpdate){
        opportunityHandler.updateSalesTarget(userID);
    }

}