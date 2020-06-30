global class SalesTargetInstaller implements InstallHandler{

    global void onInstall(InstallContext context) {
        SalesTargetInstaller.scheduleHistoryJob();
        SalesTargetInstaller.scheduleAwardsJob();
    }

    private static void scheduleHistoryJob(){
        SalesHistoryJob shJob = new SalesHistoryJob();

        // Schedule set to run every hour
        String sch = '0 0 * * * ?';
        String jobID = system.schedule('SalesHistoryJob-Hourly', sch, shJob);

        System.debug(jobID);
    }

    private static void scheduleAwardsJob(){
        //TODO: figure the schedule for this
        // SalesHistoryJob shJob = new SalesAwardsJob();

        // // Schedule set to run every hour
        // String sch = '0 0 * * * ?';
        // String jobID = system.schedule('SalesAwardsJob-Hourly', sch, shJob);

        // System.debug(jobID);
    }

}
