trigger SalesTargetTrigger on Sales_target__c(before insert, before update) {
    Sales_Target_Settings__c getSetting = [select monthly__c
        from Sales_Target_Settings__c
        where name = 'Default setting'
        limit 1
    ];

    for (Sales_target__c ST: Trigger.new) {
        Id userId = ST.Sales_rep__c;
        user u = [select MediumPhotoUrl from user where id =: userid limit 1];
        ST.icon__c = u.MediumPhotoUrl;
    }

}