public class opportunityHandler {

    public static void updateSalesTarget(id userID, decimal amount, id oppID){
        list<sobject> opportunityAmount = new list<sobject>();
        boolean setting;
        
        Sales_Target_Settings__c STsetting = [select monthly__c from Sales_Target_Settings__c limit 1];

        setting = STsetting.monthly__c;
         
        IF (setting == TRUE){
            opportunityAmount = [select sum(amount) total from opportunity where ownerid = :userID and StageName = 'Closed Won' and closeDate = THIS_MONTH];
                            } else {
            opportunityAmount = [select sum(amount) total from opportunity where ownerid = :userID and StageName = 'Closed Won' and closeDate = THIS_QUARTER];                
                        }


        list<Sales_target__c> ST = [select id, Position__c, Target_percentage__c, Sales_to_date_this_quarter__c, Sales_rep__c from Sales_target__c where Sales_rep__c = :userID];
        //opportunityAmount = [select sum(amount) total from opportunity where ownerid = :userID and StageName = 'Closed Won' and closeDate = THIS_QUARTER];

        decimal totalAmount = (decimal)opportunityAmount[0].get('total');
        
        for(Sales_target__c SalesTarget : ST){
           SalesTarget.Sales_to_date_this_quarter__c = totalAmount;
        }
   		update ST;
    
    }
    
    public static void updatePosition(id userID, decimal amount, id oppID){
         
        integer position = 0;

        list<Sales_target__c> salesTargetForPosition = [select id,of_sales_targets__c, Position__c, Sales_to_date_this_quarter__c from Sales_target__c order by Sales_to_date_this_quarter__c DESC];
        
        for(Sales_target__c SalesTarget : salesTargetForPosition){
            position++;
            SalesTarget.Position__c = position;
            system.debug('position number: ' + SalesTarget.Position__c);
        }

        for(Sales_target__c SalesTargetTotal : salesTargetForPosition ){
        SalesTargetTotal.of_sales_targets__c = position;
    }

        System.debug(position);
   		update salesTargetForPosition;
    
    }   

}