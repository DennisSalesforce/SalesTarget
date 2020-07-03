// Update opts and histories
update [SELECT Id FROM Opportunity WHERE Owner.IsActive = TRUE];
SalesHistoryJob.historySnapshot();

delete [SELECT Id FROM Sales_Award_History__c];

// Install code
for(CronTrigger ct : [SELECT Id FROM CronTrigger]){
    System.abortJob(ct.Id);
}
new SalesTargetInstaller().onInstall(null);

// TEST Jobs

delete [SELECT Id FROM Sales_Award_History__c];
SalesAwardsJob.generateAwards();

SalesHistoryJob.historySnapshot();
SalesHistoryJob.sendEmail();


SalesAwards task = new SalesAwards();

task.execute(null);