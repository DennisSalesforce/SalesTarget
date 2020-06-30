@istest(seeAllData=true)
public class OpportunityHandlerTest {

    @istest
    private static void opportunityHandler() { 
        user u = DataFactory.setupTestUser();
        sales_target__c ST = DataFactory.setupTestSalesTarget(u.id);
        opportunity o = DataFactory.setupTestOpportunity(u.id);
        test.starttest();
        o.StageName = 'Closed Won';
        update o;
        test.stoptest();
        sales_target__c STtest = [select Sales_to_date_this_month__c,Sales_to_date_this_quarter__c  from sales_target__c where id =: ST.id limit 1];

        system.debug('DEBUG MONTH '+ STtest.Sales_to_date_this_month__c);

        System.assertEquals(1000,STtest.Sales_to_date_this_month__c);
        System.assertEquals(1000,STtest.Sales_to_date_this_quarter__c);

    }
}