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
<<<<<<< HEAD
		system.debug('TotalMonthAmount'+ totalMonthAmount);
=======

>>>>>>> 86f45d21fc1869192be2086cae3dfeb41cbf73d3
        // Get this Quarter's ammount
        List<sObject> opportunityAmountQuarter = [
            SELECT SUM(amount) total from opportunity where ownerid =: userId
            AND StageName = 'Closed Won'
            AND closeDate = THIS_QUARTER
        ];
        decimal totalQuarterAmount = (decimal) opportunityAmountQuarter[0].get('total');
<<<<<<< HEAD
		system.debug('TotalQuarterAmount'+ totalQuarterAmount);
        // Update user's sales target
        Sales_target__c userSalesTarget = SalesTargetUtils.getUserSTForThisYear(userId);
		system.debug('UserSalesTarget'+ userSalesTarget);
        
=======

        // Update user's sales target
        Sales_target__c userSalesTarget = SalesTargetUtils.getUserSTForThisYear(userId);

>>>>>>> 86f45d21fc1869192be2086cae3dfeb41cbf73d3
        if(userSalesTarget != null){
            userSalesTarget.Sales_to_date_this_quarter__c = totalQuarterAmount == null ? 0 : totalQuarterAmount;
            userSalesTarget.Sales_to_date_this_month__c = totalMonthAmount == null ? 0 : totalMonthAmount;

            update userSalesTarget;
        }

    }
}