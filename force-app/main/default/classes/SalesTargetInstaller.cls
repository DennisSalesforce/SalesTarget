global class SalesTargetInstaller implements InstallHandler{

    global void onInstall(InstallContext context) {
        SalesTargetInstaller.scheduleHistoryJob();
    }

    private static void scheduleHistoryJob(){
        SalesHistoryJob shJob = new SalesHistoryJob();

        // Schedule set to run every hour
        String sch = '0 0 * * * ?';
        String jobID = system.schedule('SalesHistoryJob-Daily', sch, shJob);

        System.debug(jobID);
    }

}
