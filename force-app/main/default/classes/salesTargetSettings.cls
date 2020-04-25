public class salesTargetSettings {
    @AuraEnabled
    public static boolean currentSetting(boolean monthly){
        boolean setting;
        Sales_Target_Settings__c STS = [select monthly__c from Sales_Target_Settings__c where name = 'Default setting'
        limit 1
    ];
        
            setting = STS.monthly__c;

            return setting;

    }

    @AuraEnabled
    public static boolean currentAwardSetting(boolean storeAwards){
        boolean setting;
        Sales_Target_Settings__c STS = [select Store_awards__c from Sales_Target_Settings__c where name = 'Default setting'
        limit 1
    ];
        
            setting = STS.Store_awards__c;

            return setting;

    }

    @AuraEnabled
    public static boolean updateMonthlySettings(boolean monthly){
        list <Sales_Target_Settings__c> STS = [select monthly__c from Sales_Target_Settings__c where name = 'Default setting'
        limit 1
    ];
        boolean updatedValue;
    for(Sales_Target_Settings__c Salestarget : STS){
        if(monthly == TRUE){
            Salestarget.monthly__c = TRUE;
            updatedValue = TRUE;

        } else {
            Salestarget.monthly__c = FALSE;
            updatedValue = FALSE;
        }
    }
        System.debug(STS);
        update STS;
        return updatedValue;
    }

    @AuraEnabled
    public static boolean updateStoreAwards(boolean storeAwards){
        list <Sales_Target_Settings__c> STS = [select Store_awards__c from Sales_Target_Settings__c where name = 'Default setting'
        limit 1
    ];
        boolean updatedValue;
    for(Sales_Target_Settings__c Salestarget : STS){
        if(storeAwards == TRUE){
            Salestarget.Store_awards__c = TRUE;
            updatedValue = TRUE;


        } else {
            Salestarget.Store_awards__c = FALSE;
            updatedValue = FALSE;
        }
    }
        System.debug(STS);
        update STS;

        return updatedValue;
    }

    @AuraEnabled
    public static boolean UpdateSalesTargetsAfterSetting(boolean updatedValue){
        
        list<AggregateResult> toBeUpdateOpps = new list<AggregateResult>();
        list<sales_target__c> toBeUpdateST = new list<sales_target__c>();
        toBeUpdateST = [select id, Sales_to_date_this_quarter__c, Sales_rep__c, Target_preferences__c from Sales_target__c];
        
        IF (updatedValue == TRUE){
        toBeUpdateOpps = [select sum(amount), ownerid from opportunity 
                            WHERE StageName = 'Closed Won'  
                            AND closeDate = THIS_MONTH
                            group by ownerid];
                        } else {
        toBeUpdateOpps = [select sum(amount), ownerid from opportunity 
                        WHERE StageName = 'Closed Won'  
                        AND closeDate = THIS_QUARTER
                        group by ownerid];                 
                    }

        map<id, Decimal> OppMap = new map<id, Decimal>();
        map<id, sales_target__c> STMap = new map<id,sales_target__c>();

        for(sales_target__c ST : toBeUpdateST){
            STMap.put(
                (id)ST.get('Sales_rep__c'),
                 ST)
            ; }
         
        IF (updatedValue == TRUE){    
            for(AggregateResult arr : toBeUpdateOpps){
                id ownerid = (id)arr.get('ownerid');
                decimal totalAmount = (Decimal)arr.get('expr0');
                sales_target__c STfinal = (sales_target__c)STMap.get(ownerid);
                STfinal.Sales_to_date_this_quarter__c = totalAmount;
                STfinal.Target_preferences__c = 'Monthly';
            }
         }else{
            for(AggregateResult arr : toBeUpdateOpps){
                id ownerid = (id)arr.get('ownerid');
                decimal totalAmount = (Decimal)arr.get('expr0');
                sales_target__c STfinal = (sales_target__c)STMap.get(ownerid);
                STfinal.Sales_to_date_this_quarter__c = totalAmount;
                STfinal.Target_preferences__c = 'Quarterly';}
        }

        update STMap.values();
        
        System.debug(STMap);
        System.debug(OppMap);
        return updatedValue;
    }

}
