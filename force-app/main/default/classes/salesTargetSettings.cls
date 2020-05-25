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
    public static boolean currentAwardShowSetting(){
        boolean setting;
        Sales_Target_Settings__c STS = [select Show_awards__c from Sales_Target_Settings__c where name = 'Default setting'
        limit 1
    ];
        
            setting = STS.Show_awards__c;

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
        System.debug('MONTHLY'+ monthly);
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
    public static boolean updateShowAward(boolean showAwards){
        System.debug('value before query '+ showAwards);
        list <Sales_Target_Settings__c> STS = [select Show_awards__c from Sales_Target_Settings__c where name = 'Default setting'
        limit 1
    ];
        boolean updatedValue;
    for(Sales_Target_Settings__c SA : STS){
        if(showAwards == TRUE){
            SA.Show_awards__c = TRUE;
            updatedValue = TRUE;

        } else {
            SA.Show_awards__c = FALSE;
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
        
        for(sales_target__c S : toBeUpdateST){
            S.Sales_to_date_this_quarter__c = 0;
        }
        update toBeUpdateST;

        IF (updatedValue == TRUE){
        toBeUpdateOpps = [select sum(amount), ownerid from opportunity 
                            WHERE StageName = 'Closed Won'  
                            AND closeDate = THIS_MONTH
                            group by ownerid];
                        } 
        IF (updatedValue == FALSE){
        toBeUpdateOpps = [select sum(amount), ownerid from opportunity 
                        WHERE StageName = 'Closed Won'  
                        AND closeDate = THIS_QUARTER
                        group by ownerid];                 
                    }
                    System.debug('opps list' + toBeUpdateOpps);
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
                System.debug('STFINAL' + STfinal);
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
        
        System.debug('STMAP' + STMap);
        System.debug('OPPMAP' + OppMap);
        return updatedValue;
    }

}