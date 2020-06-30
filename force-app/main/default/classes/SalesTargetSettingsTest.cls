@istest
public class SalesTargetSettingsTest {
    @istest
    public static void currentAwardShowSettingTest() {
        DataFactory.setupTestDefaultSettingMonthly();
        test.startTest();
        boolean showAward = salesTargetSettings.currentAwardShowSetting();
        boolean storeAward = salesTargetSettings.currentAwardSetting(true);
        boolean updateSettingTrue = salesTargetSettings.updateMonthlySettings(true);
        boolean updateSettingFalse = salesTargetSettings.updateMonthlySettings(false);
        boolean updateShowAward = salesTargetSettings.updateShowAward(true);
        boolean updateStoreAward = salesTargetSettings.updateStoreAwards(true);
        boolean updateShowAwardFalse = salesTargetSettings.updateShowAward(false);
        boolean updateStoreAwardFalse = salesTargetSettings.updateStoreAwards(false);

        test.stopTest();
        System.assertEquals(true, showAward);
        System.assertEquals(true, storeAward);
        System.assertEquals(true, updateSettingTrue);
        System.assertEquals(false, updateSettingFalse);
        System.assertEquals(true, updateShowAward);
        System.assertEquals(true, updateStoreAward);
        System.assertEquals(false, updateShowAwardFalse);
        System.assertEquals(false, updateStoreAwardFalse);

    }

    @istest
    public static void updateSalesTargetAfterSettingTest(){
        DataFactory.setupTestDefaultSettingMonthly();
        sales_target__c ST = DataFactory.setupTestSalesTarget();
        opportunity o = DataFactory.setupTestWonOpportunity(ST.sales_rep__c);
        test.startTest();
        boolean resultTrue = salesTargetSettings.UpdateSalesTargetsAfterSetting(true);
        boolean resultFalse = salesTargetSettings.UpdateSalesTargetsAfterSetting(false);
        string name = salesTargetSettings.currentSettingName();
        test.stopTest();
        System.assertEquals(true, resultTrue);
        System.assertEquals(false, resultFalse);
        System.assertEquals('Month', name);
    }
}
