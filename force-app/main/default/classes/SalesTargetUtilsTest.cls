@istest
public class SalesTargetUtilsTest {
    
    @istest
    public static void getSalesTargetPositionTest() {
        DataFactory.setupTestDefaultSettingMonthly();
        sales_target__c ST = DataFactory.setupTestSalesTarget();
        test.StartTest();
        integer positionMonth = SalesTargetUtils.getSalesTargetPosition(ST, 'Monthly');
        integer positionQuarter = SalesTargetUtils.getSalesTargetPosition(ST, 'Quarterly');
        //sales_target__c SalesTargetTest = SalesTargetUtils.getUserSTForThisYear(ST.sales_rep__c);
        test.StopTest();
        System.assertEquals(2, positionMonth);
        System.assertEquals(2, positionQuarter);
        //System.assertEquals('SalesTarget', SalesTargetTest.Name);
    }

    @istest
    public static void md5Test(){
        string input = 'testString';
        test.startTest();
        string result = SalesTargetUtils.md5(input);
        test.stopTest();

        boolean check;
        if(result == input){
            check = true;
        } else {
            check = false;
        }
        System.assertEquals(false, check);
    }

    @istest
    public static void getUserSTForThisYearTestMonth(){
        DataFactory.setupTestDefaultSettingMonthly();
        sales_target__c ST = DataFactory.setupTestSalesTarget();
        test.StartTest();
        sales_target__c SalesTargetTest = SalesTargetUtils.getUserSTForThisYear(ST.sales_rep__c);
        test.StopTest();
        System.assertEquals('SalesTarget', SalesTargetTest.Name);
    }

    @istest
    public static void getUserSTForThisYearTestQuarter(){
        DataFactory.setupTestDefaultSettingQuarterly();
        sales_target__c ST = DataFactory.setupTestSalesTarget();
        test.StartTest();
        sales_target__c SalesTargetTest = SalesTargetUtils.getUserSTForThisYear(ST.sales_rep__c);
        test.StopTest();
        System.assertEquals('SalesTarget', SalesTargetTest.Name);
    }
}
