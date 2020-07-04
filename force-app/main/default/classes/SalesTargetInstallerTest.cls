@istest
public class SalesTargetInstallerTest {
    
    @istest
    public static void cancelJobTest(){
        test.startTest();
        SalesTargetInstaller.cancellAllScheduledJobs();
        test.stopTest();
    }
    
    @istest
    public static void scheduleJobTest(){
        test.startTest();
        SalesTargetInstaller.testHelper();		 
        test.stopTest();
    }

}