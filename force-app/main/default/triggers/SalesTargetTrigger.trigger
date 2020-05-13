trigger SalesTargetTrigger on Sales_target__c (before insert, before update) {
    Sales_Target_Settings__c getSetting = [select monthly__c 
                                                    from Sales_Target_Settings__c 
                                                    where name = 'Default setting'
                                                    limit 1];
    string userid;
  
    for(sales_target__c SalesTarget : trigger.new){
        if(getSetting.monthly__c == TRUE){
            SalesTarget.target_preferences__c = 'Monthly';
        } else {
            SalesTarget.target_preferences__c = 'Quarterly';
        }
        
    }

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