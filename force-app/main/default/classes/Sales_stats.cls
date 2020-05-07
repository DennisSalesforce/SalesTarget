public class Sales_stats {
    
    public class medals{
    @AuraEnabled public Decimal goldMedal = 0;
    @AuraEnabled public Decimal silverMedal = 0;
    @AuraEnabled public Decimal bronzeMedal = 0;
    @AuraEnabled public Decimal hundredMedal = 0;
}

public class wonAwards{
    @AuraEnabled public string icon;
    @AuraEnabled public string nameAward;
    @AuraEnabled public string nameAwardHistory;
}

	@auraenabled
    public static list<sales_target__c> getSalesTarget(id userid){
        list<sales_target__c> ST = [SELECT Id, icon__c, of_sales_targets__c, Position__c,Target_this_quarter__c, Target_percentage__c,Sales_rep__r.Name, Name, Target_Q1__c, Target_Q2__c, Target_Q3__c, Target_Q4__c, Sales_to_date_this_quarter__c FROM Sales_target__c WHERE Sales_rep__c = :userid];
        system.debug('list ' + ST);
    	return ST;
        
    }
    @auraenabled
    public static list<sales_target__c> getAllSalesTargets(string sortBy, string filterByTeam){
        

        string querystr = '';
        querystr += 'SELECT Id, Sales_Team__c, Sales_Team__r.Name, icon__c,of_sales_targets__c,Position__c, Target_this_quarter__c, Target_percentage__c,Sales_rep__r.Name,Sales_rep__r.Id, Name, Target_Q1__c, Target_Q2__c, Target_Q3__c, Target_Q4__c, Sales_to_date_this_quarter__c FROM Sales_target__c';
        if(filterByTeam != 'All'){
            querystr+= ' WHERE Sales_team__r.name = \'' + filterByTeam + '\'';
        }
        querystr += ' order by ' + sortBy + ' DESC';
        system.debug('string  --->> ' + querystr);
        list<sales_target__c> filterST = database.query(querystr);
    	return filterST;
        
    }


    @auraenabled
    public static integer daysLeftInQuarter(){
        period P = new period();
        date today = system.today();
        //quarter__mdt Quarter = [select end_date__c from quarter__mdt where start_date__c < today and end_date__c > today];

        Sales_Target_Settings__c STS = [select monthly__c from Sales_Target_Settings__c where name = 'Default setting'limit 1];

        if(STS.Monthly__c == TRUE){
            P = [select StartDate, EndDate, type from period where type = 'Month' and StartDate <= today and EndDate >= today ];
        } 
        if(STS.Monthly__c == FALSE){
            P = [select StartDate, EndDate, type from period where type = 'Quarter' and StartDate <= today and EndDate >= today ];
        }
        

        integer daysLeft = today.daysBetween(P.EndDate);

        return daysLeft;

    }

    @auraenabled
    public static list<sales_target__c> getTop(){
        list<sales_target__c> top3Sales = [SELECT Id, Sales_team__c, icon__c,of_sales_targets__c,Position__c, Target_this_quarter__c, Target_percentage__c,Sales_rep__r.Name, Name, Target_Q1__c, Target_Q2__c, Target_Q3__c, Target_Q4__c, Sales_to_date_this_quarter__c FROM Sales_target__c order by Sales_to_date_this_quarter__c DESC limit 3];
        system.debug('top 3 list' + top3Sales);
    	return top3Sales;
        
    }

    @auraenabled
    public static list<sales_team__c> getSalesTeam(){
        list<sales_team__c> SalesTeams = [SELECT Id, name FROM Sales_team__c order by name ASC];
        system.debug('Sales Teams' + SalesTeams);
        return SalesTeams;
        
    }    
    
    
    @AuraEnabled
    public static medals medalAwards(id userid){
        medals allMedals = new medals();
        list<AggregateResult> Medals = new list<AggregateResult>();
        Medals = [select count(id), Sales_award__r.Name from sales_award_history__c where User__c = :userid group by Sales_award__r.Name ];
        system.debug('MEDALS' + Medals);
        for(AggregateResult SAH : Medals){
            if(SAH.get('Name') == '1st Prize Sales - Monthly'){
                allMedals.goldMedal = (decimal)SAH.get('expr0');
            }
            if(SAH.get('Name') == '2nd Prize Sales - Monthly'){
                allMedals.silverMedal = (decimal)SAH.get('expr0');
            }
            if(SAH.get('Name') == '3th Prize Sales - Monthly'){
                allMedals.bronzeMedal = (decimal)SAH.get('expr0');
            }
            if(SAH.get('Name') == '100% Target Achievement'){
                allMedals.hundredMedal = (decimal)SAH.get('expr0');
            }

        }
        
        System.debug('Gold medal ---->>>'+ allMedals.goldMedal);
        System.debug('Silver medal ---->>>'+ allMedals.silverMedal);
        System.debug('Bronze medal ---->>>'+ allMedals.bronzeMedal);
        System.debug('Hundred medal ---->>>'+ allMedals.hundredMedal);
        System.debug('medals ---->>>'+ allMedals);
        return allMedals;
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
    public static list<object> getWonAwards(id userid){
        list<object> awardList = new list<object>();
        list<Sales_Award_History__c> wonAward = [select Sales_award__r.Name, Sales_award__r.icon__c, name, user__r.name from Sales_Award_History__c where user__c = :userid limit 5];
        
        for(Sales_Award_History__c SaAwHi : wonAward){
            wonAwards allMedals = new wonAwards();  
            allMedals.icon = SaAwHi.Sales_award__r.icon__c;
            allMedals.nameAward = SaAwHi.Sales_award__r.Name;
            allMedals.nameAwardHistory = SaAwHi.name;
            awardList.add(allMedals);
        }

        System.debug('SALES AWARD WON HISTORY' + awardList);
        return awardList;

    }

    @AuraEnabled
    public static list<opportunity> getWonOpps(id userid){
        
        list<opportunity> wonOpps = new list<opportunity>();
        Sales_Target_Settings__c STS = [select monthly__c from Sales_Target_Settings__c where name = 'Default setting'limit 1];

        if(STS.Monthly__c == TRUE){
            wonOpps = [select name, id, amount, stagename, closedate from opportunity where ownerid = :userid and StageName = 'Closed Won' and closeDate = THIS_MONTH limit 5];
        } 
        if(STS.Monthly__c == FALSE){
            wonOpps = [select name, id, amount, stagename, closedate from opportunity where ownerid = :userid and StageName = 'Closed Won' and closeDate = THIS_QUARTER limit 5];
        }

        System.debug('WON OPPS' + wonOpps);
        return wonOpps;

    }

}