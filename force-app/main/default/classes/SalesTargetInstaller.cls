global class SalesTargetInstaller implements InstallHandler{

    global void onInstall(InstallContext context) {
        scheduleHistoryJob();
    }

    public static void scheduleHistoryJob(){
        SalesHistoryJob shJob = new SalesHistoryJob();
        String sch = '0 0 * * * ?';
        String jobID = system.schedule('SalesHistoryJob-Daily', sch, shJob);
        System.debug(jobID);
    }

}
