public class opportunityHandler {

    // @future
    public static void updateSalesTarget(Id userId) {
        // Get this months ammount
        List<sObject> opportunityAmountMonth = [
            SELECT SUM(amount) total from opportunity where ownerid =: userId
            AND StageName = 'Closed Won'
            AND closeDate = THIS_MONTH
        ];
        decimal totalMonthAmount = (decimal) opportunityAmountMonth[0].get('total');
		system.debug('TotalMonthAmount'+ totalMonthAmount);
        // Get this Quarter's ammount
        List<sObject> opportunityAmountQuarter = [
            SELECT SUM(amount) total from opportunity where ownerid =: userId
            AND StageName = 'Closed Won'
            AND closeDate = THIS_QUARTER
        ];
        decimal totalQuarterAmount = (decimal) opportunityAmountQuarter[0].get('total');
		system.debug('TotalQuarterAmount'+ totalQuarterAmount);
        // Update user's sales target
        Sales_target__c userSalesTarget = SalesTargetUtils.getUserSTForThisYear(userId);
		system.debug('UserSalesTarget'+ userSalesTarget);
        
        if(userSalesTarget != null){
            userSalesTarget.Sales_to_date_this_quarter__c = totalQuarterAmount == null ? 0 : totalQuarterAmount;
            userSalesTarget.Sales_to_date_this_month__c = totalMonthAmount == null ? 0 : totalMonthAmount;

            update userSalesTarget;
            system.debug('SalesTarget AFTER update' + userSalesTarget);
        }

    }
}