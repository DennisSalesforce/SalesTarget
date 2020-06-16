// Update opts and histories
update [SELECT Id FROM Opportunity WHERE Owner.IsActive = TRUE];
SalesHistoryJob.historySnapshot();

Boolean endofQuarter = salesAwardQuarterly.isEndOfQuarter();
System.debug(endofQuarter);

// Install code
SalesTargetInstaller.install();


SalesAwards task = new SalesAwards();

task.execute(null);