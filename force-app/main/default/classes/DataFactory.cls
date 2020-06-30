@istest
public class DataFactory {
    
    public static user setupTestUser() {
        profile p = [select id from profile where name = 'System Administrator'
            limit 1
        ];

        user u = new user(
            Alias = 'test',
            Email = 'test@myorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id,
            TimeZoneSidKey = 'America/New_York',
            UserName = 'test1233456@myorg.com'
        );
        insert u;
        return u;
    }

    public static Sales_Target_Settings__c setupTestDefaultSettingMonthly() {
        Sales_Target_Settings__c STS = new Sales_Target_Settings__c(
            name = 'Default setting',
            monthly__c = true,
            Show_awards__c = true,
            Store_awards__c = true
        );

        insert STS;
        return STS;
    }

    public static Sales_Target_Settings__c setupTestDefaultSettingQuarterly() {
        Sales_Target_Settings__c STS = new Sales_Target_Settings__c(
            name = 'Default setting',
            monthly__c = false,
            Show_awards__c = true
        );

        insert STS;
        return STS;
    }

    public static Sales_Team__c setupTestTeam(){
        Sales_Team__c ST = new Sales_Team__c(
            name = 'test team'
        );

        insert ST;
        return ST;
    }

    public static Sales_target__c setupTestSalesTarget() {
        user user = DataFactory.setupTestUser();
        Sales_Team__c team = DataFactory.setupTestTeam();
        Sales_target__c SalesTarget = new Sales_target__c(
            name = 'SalesTarget',
            sales_rep__c = user.id,
            year__c = '2020', 
            Sales_Team__c = team.id
        );
        insert SalesTarget;
        system.debug(SalesTarget);
        return SalesTarget;
    }
    public static Sales_target__c setupTestSalesTargetNoUser(id userid) {
        Sales_Team__c team = DataFactory.setupTestTeam();
        Sales_target__c SalesTarget = new Sales_target__c(
            name = 'SalesTarget',
            sales_rep__c = userid,
            year__c = '2020', 
            Sales_Team__c = team.id
        );
        insert SalesTarget;
        system.debug(SalesTarget);
        return SalesTarget;
    }

    public static opportunity setupTestOpportunity(id userid) {
        Opportunity o = new opportunity(
            name = 'test opp',
            closedate = date.today(),
            amount = 1000,
            ownerid = userid,
            stageName = 'Negotiation'
        );
        insert o;
        system.debug(o);
        return o;
    }

    public static opportunity setupTestWonOpportunity(id userid) {
        Opportunity o = new opportunity(
            name = 'test won opp',
            closedate = date.today(),
            amount = 1000,
            ownerid = userid,
            stageName = 'Closed Won'
        );
        insert o;
        system.debug(o);
        return o;
    }

    public static Sales_award_history__c setupTestAwardsHistory(id userid) {
        Sales_award__c GoldAward = new Sales_award__c(
            Name = '1st Prize Sales',
            Period__c = 'Monthly',
            Position__c = 1,
            Award_type__c = 'Rank'
        );
        insert GoldAward;
        Sales_award__c SilverAward = new Sales_award__c(
            Name = '2nd Prize Sales',
            Period__c = 'Monthly',
            Position__c = 1,
            Award_type__c = 'Rank'
        );
        insert SilverAward;
        Sales_award__c BronzeAward = new Sales_award__c(
            Name = '3th Prize Sales',
            Period__c = 'Monthly',
            Position__c = 1,
            Award_type__c = 'Rank'
        );
        insert BronzeAward;
        Sales_award__c HundredAward = new Sales_award__c(
            Name = '100% Target Achievement',
            Period__c = 'Monthly',
            Award_type__c = 'Completion'
        );
        insert HundredAward;

        Sales_award_history__c testHistory = new Sales_award_history__c(
            Name = 'Rank',
            user__c = userid,
            sales_award__c = GoldAward.id,
            Award_id__c = '1234'
        );
        insert testHistory;
        return testHistory;
    }

    public static sales_award__c testSetupRankAward(){
        Sales_award__c GoldAward = new Sales_award__c(
            Name = '1st Prize Sales',
            Period__c = 'Monthly',
            Position__c = 1,
            Award_type__c = 'Rank'
        );
        insert GoldAward;
        return GoldAward;
    }

    public static sales_award__c testSetupCompletionAward(){
        Sales_award__c GoldAward = new Sales_award__c(
            Name = 'Test',
            Period__c = 'Monthly',
            Position__c = 1,
            Award_type__c = 'Completion'
        );
        insert GoldAward;
        return GoldAward;
    }


}