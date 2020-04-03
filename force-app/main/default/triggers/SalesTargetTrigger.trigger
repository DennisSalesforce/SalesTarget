trigger SalesTargetTrigger on Sales_target__c (before insert, before update) {
    id user = userInfo.getUserId();
    user u = [select SmallPhotoUrl from user where id = :user limit 1];   
    for(Sales_target__c ST : trigger.new){
               
       ST.icon__c = u.SmallPhotoUrl;
  
    }
}