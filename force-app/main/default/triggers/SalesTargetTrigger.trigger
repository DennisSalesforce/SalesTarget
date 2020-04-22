trigger SalesTargetTrigger on Sales_target__c (before insert, before update) {

    string userid;
  
    for(Sales_target__c ST : trigger.new){
        if(ST.icon__c == null){
            userid = ST.Sales_rep__c; 

            user u = [select SmallPhotoUrl from user where id = :userid limit 1];

    for(Sales_target__c STE : trigger.new){
        STE.icon__c = u.SmallPhotoUrl;
    }
        }
             
  
    }
    
}