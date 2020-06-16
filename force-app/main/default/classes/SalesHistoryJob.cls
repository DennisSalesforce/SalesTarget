public class SalesHistoryJob implements Schedulable {

    public void execute(SchedulableContext sc) {
        historySnapshot();
    }

    public static void historySnapshot(){
        List<Sales_Target__c> SalesTargets = [
            SELECT sales_rep__c, Sales_rep__r.Name, Id, Sales_team__c, Target_this_quarter__c, Target_this_month__c
            , Sales_to_date_this_quarter__c, Sales_to_date_this_month__c
            FROM Sales_target__c
        ];

        String dateToday = System.now().format('yyyy-MM-dd');

        List<Sales_History__c> salesHistories = new List<Sales_History__c>();


        for (sales_target__c target: SalesTargets) {

            // Monthly
            Sales_History__c salesHistoryMonthly = new Sales_History__c(
                Name = dateToday + ' - Monthly - ' + target.Sales_rep__r.Name,
                History_Type__c='Monthly',
                Date__c = System.today(),
                Percentage_of_Target__c =  target.Sales_to_date_this_month__c / target.Target_this_month__c,
                Position__c = SalesTargetUtils.getSalesTargetPosition(target, 'Monthly'),
                Total_Sales__c = target.Sales_to_date_this_month__c,
                Sales_target__c = target.Target_this_month__c,
                User__c = target.sales_rep__c,
                Latest_History__c=true
            );
            salesHistoryMonthly.History_Id__c = SalesTargetUtils.md5(salesHistoryMonthly.Name);
            salesHistories.add(salesHistoryMonthly);

            // Quarterly
            Sales_History__c salesHistoryQuarterly = new Sales_History__c(
                Name = dateToday + ' - Quarterly - ' + target.Sales_rep__r.Name,
                History_Type__c='Quarterly',
                Date__c = System.today(),
                Percentage_of_Target__c =  target.Sales_to_date_this_quarter__c / target.Target_this_quarter__c,
                Position__c = SalesTargetUtils.getSalesTargetPosition(target, 'Quarterly'),
                Total_Sales__c = target.Sales_to_date_this_quarter__c,
                Sales_target__c = target.Target_this_quarter__c,
                User__c = target.sales_rep__c,
                Latest_History__c=true
            );
            salesHistoryQuarterly.History_Id__c = SalesTargetUtils.md5(salesHistoryQuarterly.Name);
            salesHistories.add(salesHistoryQuarterly);
        }

        // Mark old ones
        List<Sales_History__c> oldHistories = [SELECT Id FROM Sales_History__c WHERE Latest_History__c = TRUE];
        for(Sales_History__c sh : oldHistories) { sh.Latest_History__c = false; }
        update oldHistories;

        // Insert new ones
        Database.upsert(salesHistories, Sales_History__c.History_Id__c);
    }

}
