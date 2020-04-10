public class Sales_stats {
	@auraenabled
    public static list<sales_target__c> getSalesTarget(id userid){
        list<sales_target__c> ST = [SELECT Id, icon__c, of_sales_targets__c, Position__c,Target_this_quarter__c, Target_percentage__c,Sales_rep__r.Name, Name, Target_Q1__c, Target_Q2__c, Target_Q3__c, Target_Q4__c, Sales_to_date_this_quarter__c FROM Sales_target__c WHERE Sales_rep__c = :userid];
        system.debug('list ' + ST);
    	return ST;
        
    }
    @auraenabled
    public static list<sales_target__c> getAllSalesTargets(){
        list<sales_target__c> SalesTargets = [SELECT Id, icon__c,of_sales_targets__c,Position__c, Target_this_quarter__c, Target_percentage__c,Sales_rep__r.Name, Name, Target_Q1__c, Target_Q2__c, Target_Q3__c, Target_Q4__c, Sales_to_date_this_quarter__c FROM Sales_target__c];
        system.debug('list all' + SalesTargets);
    	return SalesTargets;
        
    }

    @auraenabled
    public static list<sales_target__c> filterSalesTargets(string filter){
        string filterString = filter;
        string querystr = '';
        querystr += 'SELECT Id, icon__c,of_sales_targets__c,Position__c, Target_this_quarter__c, Target_percentage__c,Sales_rep__r.Name, Name, Target_Q1__c, Target_Q2__c, Target_Q3__c, Target_Q4__c, Sales_to_date_this_quarter__c FROM Sales_target__c order by ';
        querystr += filterString;
        querystr += ' DESC';
        list<sales_target__c> filterST = database.query(querystr);
        system.debug('FILTER list all' + filterST);
    	return filterST;
        
    }

    @auraenabled
    public static integer daysLeftInQuarter(){
        date today = system.today();
        quarter__mdt Quarter = [select end_date__c from quarter__mdt where start_date__c < today and end_date__c > today];

        integer daysLeft = today.daysBetween(Quarter.end_date__c);

        return daysLeft;

    }

    @auraenabled
    public static list<sales_target__c> getTop(){
        list<sales_target__c> top3Sales = [SELECT Id, icon__c,of_sales_targets__c,Position__c, Target_this_quarter__c, Target_percentage__c,Sales_rep__r.Name, Name, Target_Q1__c, Target_Q2__c, Target_Q3__c, Target_Q4__c, Sales_to_date_this_quarter__c FROM Sales_target__c order by Sales_to_date_this_quarter__c DESC limit 3];
        system.debug('top 3 list' + top3Sales);
    	return top3Sales;
        
    }

}