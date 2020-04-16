public class quarterClass {

    @AuraEnabled
    public static List < Period > getQuarters() {
        string typeValue;
        list < Sales_Target_Settings__c > STS = [select monthly__c from Sales_Target_Settings__c where name = 'default setting'
            limit 1
        ];

        for (Sales_Target_Settings__c SalesTarget: STS) {
            if (SalesTarget.monthly__c == TRUE) {
                typeValue = 'Month';
            } else {
                typeValue = 'Quarter';
            }
        }
        system.debug(typeValue);

        integer currentYear = date.today().year();
        string startYear = currentYear + '-01-01';
        string endYear = currentYear + '-12-31';

        date start = Date.valueOf(startYear);
        date last = Date.valueOf(endYear);
        System.debug(start);
        System.debug(last);
        list<period>Periods = [select type, StartDate, EndDate from Period where type =: typeValue and StartDate >=: start and EndDate <=: last order by StartDate ASC];
        System.debug(Periods);

        return Periods;
    }
}