// Update opts

update [SELECT Id FROM Opportunity WHERE Owner.IsActive = TRUE];

opportunityHandler.updateSalesTarget('0053X00000BSPfgQAH');


Boolean endofQuarter = salesAwardQuarterly.isEndOfQuarter();
System.debug(endofQuarter);


SalesAwards task = new SalesAwards();

task.execute(null);