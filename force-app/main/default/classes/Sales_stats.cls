public class Sales_stats {

    public class LeaderboardStats {
        @AuraEnabled public Boolean showAwards;
        @AuraEnabled public Medals medals;

        @AuraEnabled public String imageUrl;
        @AuraEnabled public String name;
        @AuraEnabled public String teamName;
        @AuraEnabled public String repId;
        @AuraEnabled public Decimal target;
        @AuraEnabled public Decimal targetThisMonth;
        @AuraEnabled public Decimal targetPercentage;
        @AuraEnabled public Decimal salesToDate;
    }

    public class Profile {
        @AuraEnabled public Medals medals;
        @AuraEnabled public WonAwards wonAwards;
    }

    public class hotOpportunity {
        @AuraEnabled public decimal currentScore;
        @AuraEnabled public decimal probability;
        @AuraEnabled public string opportunityName;
        @AuraEnabled public string id;
        @AuraEnabled public decimal amount;
    }

    public class Medals {
        @AuraEnabled public Decimal goldMedal = 0;
        @AuraEnabled public Decimal silverMedal = 0;
        @AuraEnabled public Decimal bronzeMedal = 0;
        @AuraEnabled public Decimal hundredMedal = 0;
    }

    public class WonAwards {
        @AuraEnabled public string icon;
        @AuraEnabled public string nameAward;
        @AuraEnabled public string nameAwardHistory;
    }

    @AuraEnabled
    public static Sales_target__c getSalesTarget(id userid) {
        return SalesTargetUtils.getUserSTForThisYear(userId);
    }
    @AuraEnabled
    public static string getPeriod() {
        return SalesTargetSettings.currentSettingName();
    }

    @auraenabled
    public static list < LeaderboardStats > getLeaderboardStats(string sortBy, string filterByTeam) {
        Boolean isMonthlyLeaderBoard = SalesTargetSettings.currentSetting();
        String querystr = '';
            querystr += 'SELECT Id, Target_percentage_this_month__c, Sales_Team__c, Sales_Team__r.Name, icon__c,of_sales_targets__c,Position__c, Target_this_quarter__c, Target_this_month__c, Target_percentage__c,Sales_rep__r.Name,Sales_rep__r.Id, Name, Q1__c, Q2__c, Q3__c, Q4__c, Sales_to_date_this_quarter__c, Sales_to_date_this_month__c FROM Sales_target__c';
            if (filterByTeam != 'All') {
                querystr += ' WHERE Sales_team__r.name = \'' + filterByTeam + '\'';
            }
        querystr += ' order by ' + sortBy + ' DESC';
        list < sales_target__c > filterST = database.query(querystr);

        List < LeaderboardStats > result = new List < LeaderboardStats > ();
        for (sales_target__c st: filterST) {
            LeaderboardStats stats = new LeaderboardStats();
            stats.imageUrl = st.icon__c;
            stats.name = st.Sales_rep__r.Name;
            stats.teamName = st.Sales_Team__r.Name;
            stats.repId = st.Sales_rep__r.Id;
            if(isMonthlyLeaderBoard == true){
                stats.salesToDate = st.Sales_to_date_this_month__c;
            } else {
                stats.salesToDate = st.Sales_to_date_this_quarter__c;
            }
            if(isMonthlyLeaderBoard == true){
                stats.targetThisMonth = st.Target_this_month__c;
            } else {
                stats.target = st.Target_this_quarter__c;
            }
            if(isMonthlyLeaderBoard == true){
                stats.targetPercentage = st.Target_percentage_this_month__c;
            } else {
                stats.targetPercentage = st.Target_percentage__c;
            }
            stats.showAwards = currentAwardShowSetting();
            stats.medals = medalAwards(stats.repId);

            result.add(stats);
        }

        return result;
    }

    // @auraenabled
    // public static list < sales_target__c > getAllSalesTargets(string sortBy, string filterByTeam) {
    //     String querystr = '';
    //     querystr += 'SELECT Id, Sales_Team__c, Sales_Team__r.Name, icon__c,of_sales_targets__c,Position__c, Target_this_quarter__c, Target_percentage__c,Sales_rep__r.Name,Sales_rep__r.Id, Name, Q1__c, Q2__c, Q3__c, Q4__c, Sales_to_date_this_quarter__c FROM Sales_target__c';
    //     if (filterByTeam != 'All') {
    //         querystr += ' WHERE Sales_team__r.name = \'' + filterByTeam + '\'';
    //     }
    //     querystr += ' order by ' + sortBy + ' DESC';
    //     system.debug('string  --->> ' + querystr);
    //     list < sales_target__c > filterST = database.query(querystr);
    //     return filterST;

    // }


    @auraenabled
    public static integer daysLeftInQuarter() {
        string period = SalesTargetSettings.currentSettingName();
        period P = new period();
        date today = system.today();

        if (period == 'Month') {
            P = [select StartDate, EndDate, type from period where type = 'Month'
                and StartDate <= today and EndDate >= today
            ];
        }
        if (period != 'Month') {
            P = [select StartDate, EndDate, type from period where type = 'Quarter'
                and StartDate <= today and EndDate >= today
            ];
        }


        integer daysLeft = today.daysBetween(P.EndDate);

        return daysLeft;

    }

    @AuraEnabled
    public static list < Sales_Target__c > getTop() {
        Boolean isMonthly = SalesTargetSettings.currentSetting();
        List<Sales_Target__c> top3Sales;

        if(isMonthly){
            top3Sales = [
                SELECT Id, Sales_team__c, icon__c, of_sales_targets__c, Position__c, Target_this_quarter__c, Target_percentage__c, Sales_rep__r.Name, Name, Q1__c, Q2__c, Q3__c, Q4__c, Sales_to_date_this_month__c
                FROM Sales_target__c
                ORDER BY Sales_to_date_this_month__c
                DESC LIMIT 10
            ];
        }else{
            top3Sales = [
                SELECT Id, Sales_team__c, icon__c, of_sales_targets__c, Position__c, Target_this_quarter__c, Target_percentage__c, Sales_rep__r.Name, Name, Q1__c, Q2__c, Q3__c, Q4__c, Sales_to_date_this_quarter__c
                FROM Sales_target__c
                ORDER BY Sales_to_date_this_quarter__c
                DESC LIMIT 10
            ];
        }


        return top3Sales;
    }

    @auraenabled
    public static list < sales_team__c > getSalesTeam() {
        list < sales_team__c > SalesTeams = [SELECT Id, name FROM Sales_team__c order by name ASC];
        system.debug('Sales Teams' + SalesTeams);
        return SalesTeams;

    }


    @AuraEnabled
    public static medals medalAwards(id userid) {
        medals allMedals = new medals();
        list < AggregateResult > Medals = new list < AggregateResult > ();
        Medals = [select count(id), Sales_award__r.Name from sales_award_history__c where User__c =: userid group by Sales_award__r.Name];
        system.debug('MEDALS' + Medals);
        for (AggregateResult SAH: Medals) {
            if (SAH.get('Name') == '1st Prize Sales') {
                allMedals.goldMedal = (decimal) SAH.get('expr0');
            }
            if (SAH.get('Name') == '2nd Prize Sales') {
                allMedals.silverMedal = (decimal) SAH.get('expr0');
            }
            if (SAH.get('Name') == '3th Prize Sales') {
                allMedals.bronzeMedal = (decimal) SAH.get('expr0');
            }
            if (SAH.get('Name') == '100% Target Achievement') {
                allMedals.hundredMedal = (decimal) SAH.get('expr0');
            }

        }

        System.debug('Gold medal ---->>>' + allMedals.goldMedal);
        System.debug('Silver medal ---->>>' + allMedals.silverMedal);
        System.debug('Bronze medal ---->>>' + allMedals.bronzeMedal);
        System.debug('Hundred medal ---->>>' + allMedals.hundredMedal);
        System.debug('medals ---->>>' + allMedals);
        return allMedals;
    }

    @AuraEnabled
    public static boolean currentAwardShowSetting() {
        Sales_Target_Settings__c STS = [
            SELECT Show_awards__c from Sales_Target_Settings__c where name = 'Default setting'
            limit 1
        ];
        return STS.Show_awards__c;
    }

    @AuraEnabled
    public static list < object > getWonAwards(id userid, string medal) {
        list < object > awardList = new list < object > ();
        system.debug(medal);
        list < Sales_Award_History__c > wonAward = new list < Sales_award_history__c > ();
        if (medal == 'Gold') {
            wonAward = [select Sales_award__r.Name, Sales_award__r.icon__c, name, user__r.name from Sales_Award_History__c where user__c =: userid and Sales_award__r.Name = '1st Prize Sales'
                limit 5
            ];
        }
        if (medal == 'Silver') {
            wonAward = [select Sales_award__r.Name, Sales_award__r.icon__c, name, user__r.name from Sales_Award_History__c where user__c =: userid and Sales_award__r.Name = '2nd Prize Sales'
                limit 5
            ];
        }
        if (medal == 'Bronze') {
            wonAward = [select Sales_award__r.Name, Sales_award__r.icon__c, name, user__r.name from Sales_Award_History__c where user__c =: userid and Sales_award__r.Name = '3th Prize Sales'
                limit 5
            ];
        }
        if (medal == 'Hundred') {
            wonAward = [select Sales_award__r.Name, Sales_award__r.icon__c, name, user__r.name from Sales_Award_History__c where user__c =: userid and Sales_award__r.Name = '100% Target Achievement'
                limit 5
            ];
        }

        for (Sales_Award_History__c SaAwHi: wonAward) {
            wonAwards allMedals = new wonAwards();
            allMedals.icon = SaAwHi.Sales_award__r.icon__c;
            allMedals.nameAward = SaAwHi.Sales_award__r.Name;
            allMedals.nameAwardHistory = SaAwHi.name;
            awardList.add(allMedals);
        }

        System.debug('SALES AWARD WON HISTORY' + awardList);
        return awardList;

    }

    @AuraEnabled
    public static list < opportunity > getWonOpps(id userid) {

        list < opportunity > wonOpps = new list < opportunity > ();
        Sales_Target_Settings__c STS = [select monthly__c from Sales_Target_Settings__c where name = 'Default setting'
            limit 1
        ];

        if (STS.Monthly__c == TRUE) {
            wonOpps = [select name, id, amount, stagename, closedate from opportunity where ownerid =: userid and StageName = 'Closed Won'
                and closeDate = THIS_MONTH limit 5
            ];
        }
        if (STS.Monthly__c == FALSE) {
            wonOpps = [select name, id, amount, stagename, closedate from opportunity where ownerid =: userid and StageName = 'Closed Won'
                and closeDate = THIS_QUARTER limit 5
            ];
        }

        System.debug('WON OPPS' + wonOpps);
        return wonOpps;

    }


    @AuraEnabled
    public static list<hotOpportunity> HotOpportunities(id userid) {
        datetime todayMinus90 = System.now().addDays(-90);
        list < opportunity > userOpportunities = new list < opportunity > ();
        //all opportunities modified in the last 90 days
        userOpportunities = [SELECT name, id, ExpectedRevenue, LastModifiedDate, Amount, Probability FROM opportunity
            WHERE LastModifiedDate >=: todayMinus90
            AND ownerId =: userid
            AND StageName NOT IN ('Closed Won','Closed Lost')
        ];

        list < hotOpportunity > showHotOpportunities = new list < hotOpportunity > ();

        double currentScore;

        for (opportunity o: userOpportunities) {
            hotOpportunity hotOpp = new hotOpportunity();
            hotOpp.currentScore = o.ExpectedRevenue * (0.5 + ((90 - (System.today().daysBetween(o.LastModifiedDate.date()))) / 90));
            hotOpp.opportunityName = o.name;
            hotOpp.id = o.id;
            hotOpp.amount = o.amount;
            hotOpp.probability = o.Probability;
            showHotOpportunities.add(hotOpp);
        }

        system.debug('hotopp ' + showHotOpportunities);
        return showHotOpportunities;

    }

}