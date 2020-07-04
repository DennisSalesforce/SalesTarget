global class SalesAwardsJob implements Schedulable{

    public void execute(SchedulableContext sc) {
        try {
            SalesAwardsJob.generateAwards();
        } catch (Exception e) {
            SalesTargetUtils.sendEmail('SalesAwardsJob Failed', String.valueOf(e));
        }
    }

    public static Boolean isEndOfMonth(){
        // We run this on the first day of the month
        List<Period> period = [
            SELECT Id FROM Period
            WHERE EndDate = TODAY AND Type = 'Month'
        ];
        
        if(Test.isRunningTest()){
            return true;
        }
        return period.size() == 1;
        
    }

    public static Boolean isEndOfQuarter(){
        // We run this on the first day of the month
        List<Period> period = [
            SELECT Id FROM Period
            WHERE EndDate = TODAY AND Type = 'Quarter'
        ];
        
        if(Test.isRunningTest()){
            return true;
        }
        return period.size() == 1;
        
    }

    public static List<Sales_Target__c> getRankedSalesTargets(String rankBy){
        String query = 'SELECT Id, Sales_rep__c, Sales_rep__r.Name, Target_percentage_this_month__c, Target_percentage__c FROM Sales_target__c';

        if(!String.isBlank(rankBy)){
            query += ' ORDER BY '+rankBy+' DESC';
        }


        System.debug(Database.query(query));

        return Database.query(query);
    }

    public static String getAwardName(Sales_Award__c award, String salesRepName){
        Datetime now = System.now();
        String month = now.format('MMMM');
        String year = now.format('yyyy');

        if(award.Award_Type__c == 'Rank'){
            String ordinal = '';
            if(award.Position__c == 1) ordinal += '1st';
            if(award.Position__c == 2) ordinal += '2nd';
            if(award.Position__c == 3) ordinal += '3rd';
            if(award.Position__c >= 4) ordinal += award.Position__c+'th';
            return ordinal +' Prize Sales - ' + award.Period__c + ' - ' + month + ' ' + year;
        }

        if(award.Award_Type__c == 'Completion'){
            return '100% Target - ' + award.Period__c + ' - ' + month + ' ' + year + ' - ' + salesRepName;
        }

        return award.Award_Type__c;
    }

    public static String getAwardHistoryId(Sales_Award_History__c award){
        //TODO: investigate uniqueness
        return SalesTargetUtils.md5(award.Name);
    }

    public static void generateAwards(){
        // FIXME: Use the Sales History to know what happened instead of the current sales targets

        // List of awards to give at this moment
        List<Sales_Award__c> awardsToGive = new List<Sales_Award__c>();

        if(isEndOfMonth()){
            awardsToGive.addAll([
                SELECT Id, Position__c, Award_Type__c, Period__c
                FROM Sales_Award__c WHERE Period__c = 'Monthly'
            ]);
        }

        if(isEndOfQuarter()){
            awardsToGive.addAll([
                SELECT Id, Position__c, Award_Type__c, Period__c
                FROM Sales_Award__c WHERE Period__c = 'Quarterly'
            ]);
        }

        System.debug('AWARDS TO GIVE' + awardsToGive);

        List<Sales_Award_History__c> awarded = new List<Sales_Award_History__c>();

        for(Sales_Award__c award : awardsToGive){

            if(award.Award_Type__c == 'Rank'){
                // Ranked award type
                List<Sales_target__c> ranked = getRankedSalesTargets(
                    award.Period__c == 'Quarterly' ? 'Sales_to_date_this_quarter__c' : 'Sales_to_date_this_month__c'
                );

                // Check if we have a rank at that position
                if(ranked.size() >= award.Position__c){

                    Id awardedRepId = ranked.get(Math.round(award.Position__c)-1).Sales_rep__c;
                    String awardName = getAwardName(award, null);

                    Sales_Award_History__c newAward = new Sales_Award_History__c(
                        Name=awardName,
                        User__c=awardedRepId,
                        Sales_Award__c=award.id
                    );
                    newAward.Award_Id__c = getAwardHistoryId(newAward);

                    System.debug(newAward);
                    awarded.add(newAward);
                }

            }

            if(award.Award_Type__c == 'Completion'){
                // Completionist award
                List<Sales_target__c> salesTargets = getRankedSalesTargets('Sales_to_date_this_month__c');
			
                for(Sales_target__c st : salesTargets){
                    if(     (award.Period__c == 'Monthly'   &&  st.Target_percentage_this_month__c >= 100)
                         || (award.Period__c == 'Quarterly' &&  st.Target_percentage__c >= 100) ){
                        // Award for this award

                        Sales_Award_History__c newAward = new Sales_Award_History__c(
                            Name=getAwardName(award, st.Sales_rep__r.Name),
                            User__c=st.Sales_rep__c,
                            Sales_Award__c=award.id
                        );
                        newAward.Award_Id__c = getAwardHistoryId(newAward);

                        System.debug(newAward);
                        awarded.add(newAward);
                    }
                }

            }
        }

        // Upsert all created awards
        // insert awarded;
        Database.upsert(awarded, Sales_Award_History__c.Award_Id__c);
    }

}