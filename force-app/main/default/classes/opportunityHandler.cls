public class opportunityHandler {

    public static void updateSalesTarget(id userID, decimal amount, id oppID){
         
        list<Sales_target__c> ST = [select id, Target_percentage__c, Sales_to_date_this_quarter__c, Sales_rep__c from Sales_target__c where Sales_rep__c = :userID];
        list<sobject> opportunityAmount = [select sum(amount) total from opportunity where ownerid = :userID and StageName = 'Closed Won' and closeDate = THIS_QUARTER];

        decimal totalAmount = (decimal)opportunityAmount[0].get('total');
        
        for(Sales_target__c SalesTarget : ST){
           SalesTarget.Sales_to_date_this_quarter__c = totalAmount;
        }
   		update ST;
    
    }
    
}