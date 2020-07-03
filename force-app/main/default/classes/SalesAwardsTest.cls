@istest
public class SalesAwardsTest {
    @istest
    public static void isEndOfQuarterTest() {
        test.startTest();
        boolean endOfQuarter = SalesAwardsJob.isEndOfQuarter();
        test.stopTest();
        System.assertEquals(False, endOfQuarter);
    }
    @istest
    public static void rankedSalesTargetsTest() {
        DataFactory.setupTestDefaultSettingMonthly();
        Sales_target__c ST = DataFactory.setupTestSalesTarget();
        test.startTest();
        list<sales_target__c> TargetTest = SalesAwardsJob.getRankedSalesTargets('Sales_to_date_this_month__c');
        test.stopTest();
        boolean result = false;
        if(TargetTest.size()>0){
            result = true;
        }
        System.assertEquals(true, result);
    }

    @istest
    public static void getAwardRankName(){
        sales_award__c award = DataFactory.testSetupRankAward();
        test.startTest();
        string awardTest = SalesAwardsJob.getAwardName(award);
        test.stopTest();
        system.debug(awardTest);
        System.AssertEquals('1st Prize Sales - July 2020',awardTest);
    }

    @istest
    public static void testSetupCompletionAward(){
        sales_award__c award = DataFactory.testSetupCompletionAward();
        test.startTest();
        string awardTest = SalesAwardsJob.getAwardName(award);
        test.stopTest();
        system.debug(awardTest);
        System.AssertEquals('100% Target - July 2020',awardTest);
    }

    @istest
    public static void testSetupAwardHistoryId(){
        DataFactory.setupTestDefaultSettingMonthly();
        sales_target__c target = DataFactory.setupTestSalesTarget();
        sales_award_history__c history = DataFactory.setupTestAwardsHistory(target.sales_rep__c);
        test.startTest();
        string uniqueId = SalesAwardsJob.getawardHistoryId(history);
        test.stopTest();
        System.assertEquals('Ah2hsg9z3CUjYaVNgEl+8w==', uniqueId);
    }

    // @istest
    // public static void testAwardCodeDennis(){
    //     DataFactory.setupTestDefaultSettingMonthly();
    //     sales_target__c target = DataFactory.setupTestSalesTarget();
    //     Sales_award_history__c history = DataFactory.setupTestAwardsHistory(target.sales_rep__c);
    //     test.startTest();
    //     SalesAwardsJob.awardsCodeDennis();
    //     test.stopTest();
    // }
}