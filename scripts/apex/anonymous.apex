// Update opts and histories
update [SELECT Id FROM Opportunity WHERE Owner.IsActive = TRUE];
SalesHistoryJob.historySnapshot();

Boolean endofQuarter = salesAwardQuarterly.isEndOfQuarter();
System.debug(endofQuarter);

// Install code
new SalesTargetInstaller().onInstall(null);

SalesHistoryJob.historySnapshot();

SalesHistoryJob.sendEmail();


SalesAwards task = new SalesAwards();

task.execute(null);