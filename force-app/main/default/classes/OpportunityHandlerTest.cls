@istest(seeAllData=true)
public class OpportunityHandlerTest {

    @istest
    private static void opportunityHandler() {
        Sales_target__c ST = DataFactory.setupTestSalesTarget();
        Opportunity o = DataFactory.setupTestOpportunity(ST.Sales_Rep__c);

        Test.starttest();
        o.StageName = 'Closed Won';
        update o;
        Test.stoptest();

        sales_target__c STtest = [
            SELECT Sales_to_date_this_month__c,Sales_to_date_this_quarter__c
            FROM sales_target__c where id =: ST.id
            LIMIT 1
        ];

        system.debug('DEBUG MONTH '+ STtest.Sales_to_date_this_month__c);

        System.assertEquals(1000,STtest.Sales_to_date_this_month__c);
        System.assertEquals(1000,STtest.Sales_to_date_this_quarter__c);

    }
}