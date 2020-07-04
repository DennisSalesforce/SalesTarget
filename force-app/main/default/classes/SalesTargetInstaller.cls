global class SalesTargetInstaller implements InstallHandler{

    global void onInstall(InstallContext context) {
        SalesTargetInstaller.cancellAllScheduledJobs();
        if(test.isRunningTest()){testHelper();} else {SalesTargetInstaller.scheduleJobs();}
    }

    public static List<CronTrigger> getAllDefinedJobs(){
        return [
            SELECT Id FROM CronTrigger
            WHERE CronJobDetail.Name LIKE 'ST-%'
        ];
    }

    public static void cancellAllScheduledJobs(){
        // Lookup of jobs defined here
        List<CronTrigger> triggers = getAllDefinedJobs();
        // Cancel jobs
        for(CronTrigger ct : triggers){
            System.abortJob(ct.Id);
        }
    }

    public static void testHelper(){
        if(Test.isRunningTest()){
            scheduleJobs();
        }
    }

    private static void scheduleJobs(){
        // Schedule set to run every hour
		string historyJob;
        string awardsJob;
        if(test.isRunningTest()){historyJob = 'testHistory';} else {historyJob = 'ST-SalesHistoryJob-Hourly';}
        if(test.isRunningTest()){awardsJob = 'testAwards';} else {awardsJob = 'ST-SalesAwardsJob-Daily';}
            System.schedule(
                historyJob,
                '0 0 * * * ?',
                new SalesHistoryJob()
            );
        // Schedule set to run every day at the end of the day
            System.schedule(
                awardsJob,
                '23 50 0 * * ?',
                new SalesAwardsJob()
            );   
    }

}