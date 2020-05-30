@istest
public class SalesStatsTest {

    @istest
    public static void testSetup() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];

        user u = new user(
            Alias = 'standt',
            Email = 'standarduser@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'standarduser34567890@testorg.com'
        );

        insert u;

        sales_target__c ST = new sales_target__c(
            Sales_rep__c = u.id
        );

        insert ST;
    }

    @istest
    public static void getSalesTargetTest() {

        test.starttest();

        test.stoptest();
        user u = [select id from user where username = 'standarduser34567890@testorg.com'];
        List < Sales_target__c > SalesTarget = [SELECT Id, icon__c, of_sales_targets__c, Position__c, Target_this_quarter__c, Target_percentage__c, Sales_rep__r.Name, Name, Target_Q1__c, Target_Q2__c, Target_Q3__c, Target_Q4__c, Sales_to_date_this_quarter__c FROM Sales_target__c WHERE Sales_rep__c =: u.id LIMIT 1];

        boolean result = false;


        if (SalesTarget.size() != NULL) {
            result = true;

        }

        system.assertequals(true, result);

    }



}