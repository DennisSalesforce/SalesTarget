trigger SalesTargetTrigger on Sales_target__c (before insert, before update) {
    //id user = userInfo.getUserId();
    string userid;
    //user u = [select SmallPhotoUrl from user where id = :user limit 1];   
    for(Sales_target__c ST : trigger.new){
       userid = ST.Sales_rep__c;       
       //ST.icon__c = u.SmallPhotoUrl;
  
    }
    user u = [select SmallPhotoUrl from user where id = :userid limit 1];

    for(Sales_target__c ST : trigger.new){
        ST.icon__c = u.SmallPhotoUrl;
    }
}