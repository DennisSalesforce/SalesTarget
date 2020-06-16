public class SalesTargetInstaller {

    public static void install() {
        scheduleHistoryJob();
    }

    public static void scheduleHistoryJob(){
        SalesHistoryJob shJob = new SalesHistoryJob();
        String sch = '0 0 * * * ?';
        String jobID = system.schedule('SalesHistoryJob-Daily', sch, shJob);
        System.debug(jobID);
    }

}
