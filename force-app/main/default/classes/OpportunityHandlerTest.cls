@istest
public class OpportunityHandlerTest {

    @istest
    private static void makeData() {
        Opportunity o = new opportunity(
            name = 'test opp',
            closedate = date.today(),
            amount = 1000,
            ownerid = '0053X00000BSPfgQAH',
            stageName = 'Closed Won'
        );
        insert o;

        id userID = '0053X00000BSPfgQAH';
        decimal amount = 1000;
        id oppID = o.id;

        list < sobject > OpportunityTestAmount = new list < sobject > ();

        Sales_target__c SalesTarget = new Sales_target__c(
            name = 'SalesTarget',
            sales_rep__c = '0053X00000BSPfgQAH'
        );
        insert SalesTarget;



        test.starttest();
        Sales_Target_Settings__c STsetting = [select monthly__c from Sales_Target_Settings__c limit 1];
        test.stoptest();

        sales_target__c ST = [select Sales_to_date_this_quarter__c from sales_target__c where id =: SalesTarget.id];

        decimal OppAmount = ST.Sales_to_date_this_quarter__c;


        System.assertEquals(OppAmount, 1000);


    }
}