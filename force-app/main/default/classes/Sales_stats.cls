public class Sales_stats {
	@auraenabled
    public static list<sales_target__c> getSalesTarget(id userid){
        list<sales_target__c> ST = [SELECT Id, icon__c, Target_percentage__c,Sales_rep__r.Name, Name, Target_Q1__c, Target_Q2__c, Target_Q3__c, Target_Q4__c, Sales_to_date_this_quarter__c FROM Sales_target__c WHERE Sales_rep__c = :userid];

    	return ST;
        
    }
    
    
}