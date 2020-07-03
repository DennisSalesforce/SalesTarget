global class SalesTargetInstaller implements InstallHandler{

    global void onInstall(InstallContext context) {
        SalesTargetInstaller.cancellAllScheduledJobs();
        SalesTargetInstaller.scheduleJobs();
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

    private static void scheduleJobs(){
        // Schedule set to run every hour
        System.schedule(
            'ST-SalesHistoryJob-Hourly',
            '0 0 * * * ?',
            new SalesHistoryJob()
        );
        // Schedule set to run every day at the end of the day

        System.schedule(
            'ST-SalesAwardsJob-Daily',
            '23 50 0 * * ?',
            new SalesAwardsJob()
        );
    }

}
