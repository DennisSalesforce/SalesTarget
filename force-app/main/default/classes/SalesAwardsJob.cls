global class SalesAwardsJob implements Schedulable{

    public void execute(SchedulableContext sc) {
        SalesAwardsJob.generateAwards();
    }

    public static Boolean isEndOfQuarter(){
        // We run this on the first day of the month
        List<Period> period = [SELECT Id FROM Period
            WHERE StartDate = TODAY AND Type = 'Quarter'
        ];
        return period.size() == 1;
    }

    public static List<Sales_Target__c> getRankedSalesTargets(String rankBy){
        String query = 'SELECT Id, icon__c, of_sales_targets__c, Position__c, Target_this_quarter__c, Target_percentage__c, Target_percentage_this_month__c, Sales_rep__c, Sales_rep__r.Name, Name, Target_Q1__c, Target_Q2__c, Target_Q3__c, Target_Q4__c, Sales_to_date_this_quarter__c, Sales_to_date_this_month__c FROM Sales_target__c';

        if(!String.isBlank(rankBy)){
            query += ' ORDER BY '+rankBy+' DESC';
        }

        return Database.query(query);
    }

    public static String getAwardName(Sales_Award__c award){
        Datetime now = System.now();
        String month = now.format('MMMM');
        String year = now.format('yyyy');

        if(award.Award_Type__c == 'Rank'){
            String ordinal = '';
            if(award.Position__c == 1) ordinal += '1st';
            if(award.Position__c == 2) ordinal += '2nd';
            if(award.Position__c == 3) ordinal += '3rd';
            if(award.Position__c >= 4) ordinal += award.Position__c+'th';
            return ordinal +' Prize Sales - ' + month + ' ' + year;
        }

        if(award.Award_Type__c == 'Completion'){
            return '100% Target - ' + month + ' ' + year;
        }

        return award.Award_Type__c;
    }

    public static String getAwardHistoryId(Sales_Award_History__c award){
        //TODO: investigate uniqueness
        return SalesTargetUtils.md5(award.Name);
    }

    public static void awardsCodeDennis(){
        list <Sales_Target__c> SalesTargetsTop3 = new List<Sales_target__c>();

        SalesTargetsTop3 = [SELECT Id, icon__c, of_sales_targets__c, Position__c, Target_this_quarter__c, Target_percentage__c, Sales_rep__c, Sales_rep__r.Name, Name, Target_Q1__c, Target_Q2__c, Target_Q3__c, Target_Q4__c, Sales_to_date_this_quarter__c FROM Sales_target__c order by Sales_to_date_this_quarter__c DESC limit 3];

        sales_award__c nr1 = [SELECT id from sales_award__c where name = '1st Prize Sales' limit 1 ];
        sales_award__c nr2 = [SELECT id from sales_award__c where name = '2nd Prize Sales' limit 1 ];
        sales_award__c nr3 = [SELECT id from sales_award__c where name = '3th Prize Sales' limit 1 ];

        List<Sales_Award_History__c> top3 = new list <Sales_Award_History__c> ();

        integer i = 0;
        for (sales_target__c STTOP3: SalesTargetsTop3) {
            Sales_Award_History__c SAHTOP3 = new Sales_Award_History__c();
            SAHTOP3.name = 'April 2020';
            SAHTOP3.User__c = STTOP3.Sales_rep__c;
            if (i == 0) {
                SAHTOP3.Sales_Award__c = nr1.id;
                System.debug(SAHTOP3.Sales_Award__c + 'SAHTOP3.Sales_Award__c');
            }
            if (i == 1) {
                SAHTOP3.Sales_Award__c = nr2.id;
                System.debug(SAHTOP3.Sales_Award__c + 'SAHTOP3.Sales_Award__c');
            }
            if (i == 2) {
                SAHTOP3.Sales_Award__c = nr3.id;
                System.debug(SAHTOP3.Sales_Award__c + 'SAHTOP3.Sales_Award__c');
            }


            top3.add(SAHTOP3);
            i++;
        }

        insert top3;
    }

    public static void generateAwards(){
        // FIXME: Use the Sales History to know what happened instead of the current sales targets

        // List of awards to give at this moment
        List<Sales_Award__c> awardsToGive = new List<Sales_Award__c>();
        Boolean isEndOfQuarter = isEndOfQuarter();

        System.debug('isEndOfQuarter ' +isEndOfQuarter);

        awardsToGive.addAll([
            SELECT Id, Position__c, Award_Type__c, Period__c
            FROM Sales_Award__c WHERE Period__c = 'Monthly'
        ]);

        if(isEndOfQuarter){
            awardsToGive.addAll([
                SELECT Id, Position__c, Award_Type__c, Period__c
                FROM Sales_Award__c WHERE Period__c = 'Quaterly'
            ]);
        }

        System.debug(awardsToGive);

        List<Sales_Award_History__c> awarded = new List<Sales_Award_History__c>();

        for(Sales_Award__c award : awardsToGive){

            if(award.Award_Type__c == 'Rank'){
                // Ranked award type
                List<Sales_target__c> ranked = getRankedSalesTargets(
                    isEndOfQuarter ? 'Sales_to_date_this_quarter__c' : 'Sales_to_date_this_month__c'
                );

                // Check if we have a rank at that position
                if(ranked.size() >= award.Position__c){

                    Id awardedRepId = ranked.get(Integer.valueOf(award.Position__c)).Sales_Rep__c;
                    String awardName = getAwardName(award);

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

            // if(award.Award_Type__c == 'Completion'){
            //     // Completionist award
            //     List<Sales_target__c> salesTargets = getRankedSalesTargets();

            // }
        }

        System.debug(awarded);

        // Upsert all created awards
        insert awarded;
        // Database.upsert(awarded, Sales_Award_History__c.Award_Id__c);
    }

}
