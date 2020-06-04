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

        // Get this Quarter's ammount
        List<sObject> opportunityAmountQuarter = [
            SELECT SUM(amount) total from opportunity where ownerid =: userId
            AND StageName = 'Closed Won'
            AND closeDate = THIS_QUARTER
        ];
        decimal totalQuarterAmount = (decimal) opportunityAmountQuarter[0].get('total');

        // Update user's sales target
        Sales_target__c userSalesTarget = SalesTargetUtils.getUserSTForThisYear(userId);

        if(userSalesTarget != null){
            userSalesTarget.Sales_to_date_this_quarter__c = totalQuarterAmount == null ? 0 : totalQuarterAmount;
            userSalesTarget.Sales_to_date_this_month__c = totalMonthAmount == null ? 0 : totalMonthAmount;

            update userSalesTarget;
        }

    }

    public static void updatePosition(id userID, decimal amount, id oppID) {
        // FIXME: this needs to be gone forever and rebuilt according to
        // the month/quarter in the Aura Component controllers

        integer position = 0;

        List<Sales_target__c> salesTargetForPosition = [
            SELECT id, of_sales_targets__c, Position__c, Sales_to_date_this_quarter__c
            FROM Sales_target__c order by Sales_to_date_this_quarter__c
            DESC
        ];

        for (Sales_target__c SalesTarget: salesTargetForPosition) {
            position++;
            SalesTarget.Position__c = position;
        }

        for (Sales_target__c SalesTargetTotal: salesTargetForPosition) {
            SalesTargetTotal.of_sales_targets__c = position;
        }

        update salesTargetForPosition;
    }

}