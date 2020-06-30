@istest
public class SalesStatsTest {
    @istest
    public static void getLeaderboardStatsTestMonthly() {
        Sales_Target_Settings__c defaultSetting = DataFactory.setupTestDefaultSettingMonthly();
        
        sales_target__c ST = DataFactory.setupTestSalesTarget();
        test.starttest();
        list<object> result = Sales_stats.getLeaderboardStats('Sales_to_date_this_month__c', 'test team');
        test.stoptest();
        
        system.debug(result);

    }
    @istest
    public static void getLeaderboardStatsTestQuarterly() {
        Sales_Target_Settings__c defaultSetting = DataFactory.setupTestDefaultSettingQuarterly();
        
        sales_target__c ST = DataFactory.setupTestSalesTarget();
        test.starttest();
        object result = Sales_stats.getLeaderboardStats('Sales_to_date_this_quarter__c', 'test team');
        test.stoptest();
        
        system.debug(result);

    }

    @istest
    public static void daysLeftInQuarterMonthly(){
        Sales_Target_Settings__c defaultSetting = DataFactory.setupTestDefaultSettingMonthly();      
        test.starttest();
        integer daysLeft = Sales_stats.daysLeftInQuarter();
        test.stoptest();
        boolean result;
        if(daysLeft != null){
            result = true;
        } else {
            result = false;
        }

        system.debug(daysLeft);
        system.assertequals(true, result);
        
    }

    @istest
    public static void daysLeftInQuarterQuarter(){
        Sales_Target_Settings__c defaultSetting = DataFactory.setupTestDefaultSettingQuarterly();      
        test.starttest();
        integer daysLeft = Sales_stats.daysLeftInQuarter();
        test.stoptest();
        boolean result;
        if(daysLeft != null){
            result = true;
        } else {
            result = false;
        }

        system.debug(daysLeft);
        system.assertequals(true, result);
        
    }

    @istest
    public static void getPeriodTest(){
    Sales_Target_Settings__c defaultSetting = DataFactory.setupTestDefaultSettingMonthly();  
    test.starttest();
    string name = Sales_stats.getPeriod();
    test.stoptest();
    system.assertEquals('Month', name);
    }

    @istest
    public static void getSalesTargetTest(){
    Sales_Target_Settings__c defaultSetting = DataFactory.setupTestDefaultSettingMonthly();
    sales_target__c ST = DataFactory.setupTestSalesTarget(); 
    test.starttest();
    sales_target__c testTarget = Sales_stats.getSalesTarget(ST.sales_rep__c);
    test.stoptest();

    system.debug(testTarget);
    }

        test.stoptest();
        user u = [select id from user where username = 'standarduser34567890@testorg.com'];
        List < Sales_target__c > SalesTarget = [SELECT Id, icon__c, of_sales_targets__c, Position__c, Target_this_quarter__c, Target_percentage__c, Sales_rep__r.Name, Name, Target_Q1__c, Target_Q2__c, Target_Q3__c, Target_Q4__c, Sales_to_date_this_quarter__c FROM Sales_target__c WHERE Sales_rep__c =: u.id LIMIT 1];

    @istest
    public static void getTopTestQuarterly(){
    Sales_Target_Settings__c defaultSetting = DataFactory.setupTestDefaultSettingQuarterly(); 
    sales_target__c ST = DataFactory.setupTestSalesTarget();
    test.starttest();
    list<sales_target__c> testTargets = Sales_stats.getTop();
    test.stoptest();
    system.debug('TEST TARGETS' + testTargets);
    boolean result;
    if(!testTargets.isempty()){
        result = true;
    } else {
        result = false;
    }
    System.AssertEquals(true, result);
    }

    @istest
    public static void getSalesTeamTest(){
    DataFactory.setupTestTeam();    
    test.startTest();
    list<sales_team__c> testTeam = Sales_stats.getSalesTeam();
    test.stopTest();
    boolean result;
    if(!testTeam.isempty()){
        result = true;
    } else {
        result = false;
    }
    System.assertEquals(true, result);
    }

   /*  @istest(seeAllData=true)
    public static void medalAwardsTest(){
    sales_target__c ST = DataFactory.setupTestSalesTarget();
    test.startTest();
    Medals Medal = Sales_stats.medalAwards('0053X00000BSPfuQAH');
    test.stopTest();
    system.debug('MEDALS TEST' + Medal);
    } */

    @istest
    public static void CurrentAwardShowSettingTest(){
        Sales_Target_Settings__c defaultSetting = DataFactory.setupTestDefaultSettingMonthly(); 

        test.startTest();
        boolean setting = Sales_stats.currentAwardShowSetting();
        test.stopTest();

        System.assertEquals(true, setting);
    }

    @istest
    public static void getWonAwardsTest(){
        user user = DataFactory.setupTestUser();
        sales_award_history__c testHistory = DataFactory.setupTestAwardsHistory(user.id);
        list<object> allMedals = new list<object>();
        test.startTest();
        list<object> Goldmedals = Sales_stats.getWonAwards(user.id,'Gold');
        list<object> Silvermedals = Sales_stats.getWonAwards(user.id,'Silver');
        list<object> Bronzemedals = Sales_stats.getWonAwards(user.id,'Bronze');
        list<object> Hundredmedals = Sales_stats.getWonAwards(user.id,'Hundred');
        test.stopTest();  
        allMedals.add(Goldmedals);
        allMedals.add(Silvermedals);
        allMedals.add(Bronzemedals);
        allMedals.add(Hundredmedals);
        
        boolean result;

        if(!allMedals.isempty()){
            result = true;
        } else {
            result = false;
        }
        System.assertEquals(true, result);
    }

    @istest
    public static void getWonOppsTestMonthly(){
        Sales_Target_Settings__c defaultSetting = DataFactory.setupTestDefaultSettingMonthly(); 
        user user = DataFactory.setupTestUser();
        opportunity o = DataFactory.setupTestWonOpportunity(user.id); 
        test.starttest();
        list<opportunity> opps = Sales_stats.getWonOpps(user.id);
        test.stoptest();

        boolean result;
        if(!opps.isempty()){
            result = true;
        } else {
            result = false;
        }
        System.assertEquals(true, result);
    }
    @istest
    public static void getWonOppsTestQuarterly(){
        Sales_Target_Settings__c defaultSetting = DataFactory.setupTestDefaultSettingQuarterly(); 
        user user = DataFactory.setupTestUser();
        opportunity o = DataFactory.setupTestWonOpportunity(user.id); 
        test.starttest();
        list<opportunity> opps = Sales_stats.getWonOpps(user.id);
        test.stoptest();

        boolean result;
        if(!opps.isempty()){
            result = true;
        } else {
            result = false;
        }
        System.assertEquals(true, result);
    }

    @istest
    public static void SalesHistorySnapshotTest(){
    Sales_Target_Settings__c defaultSetting = DataFactory.setupTestDefaultSettingQuarterly();
    sales_target__c ST = DataFactory.setupTestSalesTarget();
    test.startTest();
    Sales_stats.SalesHistorySnapshot();
    test.stopTest();
    list<Sales_History__c> History = [SELECT id FROM Sales_History__c];
    boolean result = false;
    if(!History.isempty()){
        result = true;
    } 
    System.assertEquals(true, result);
    }

    @istest
    public static void HotOpportunitiesTest(){
        user u = DataFactory.setupTestUser();
        opportunity o = DataFactory.setupTestOpportunity(u.id);
        test.startTest();
        list<object> hotOpps = Sales_stats.HotOpportunities(u.id);
        test.stopTest();
        boolean result = false;
        if(!hotOpps.isempty()){
            result = true;
        }
        System.assertEquals(true,result);
    }

}