public class quarterClass {
    @AuraEnabled
    public static List<Quarter__mdt> getQuarterDates() {

        list<Quarter__mdt> QuarterData = [select id, Start_date__c, End_date__c, DeveloperName from Quarter__mdt order by DeveloperName ASC];

        return QuarterData;

    }
}