trigger accountTrigger on Account (before insert, before update) {
    
    for(Account A : trigger.new){
        
        list<opportunity> Opps = [select id, amount, name from opportunity where accountId = :a.id];
        
        for (opportunity O : Opps){
            
            O.Description = 'New Opportunity';
            
        }
        update Opps;
    }
    
}