public class SalesTargetUtils {

    public static Sales_target__c getUserSTForThisYear(String userId){
        Boolean isMonthly = salesTargetSettings.currentSetting();
        String thisYear = String.valueOf(System.now().year());
        Sales_target__c userSalesTarget;

        try {
            userSalesTarget = [
                SELECT Id, icon__c, of_sales_targets__c, Position__c, Target_this_quarter__c, Target_percentage__c, Sales_rep__r.Name, Name, Q1__c, Q2__c, Q3__c, Q4__c,
                    Sales_to_date_this_quarter__c, Sales_to_date_this_month__c
                FROM Sales_target__c
                WHERE Sales_rep__c =: userid
                AND Year__c = :thisYear
                LIMIT 1
            ];
        } catch (Exception e) {
            return null;
        }

        if(isMonthly){
            List<Sales_target__c> stsAboveUs = [SELECT Id FROM Sales_target__c WHERE Sales_to_date_this_month__c > :userSalesTarget.Sales_to_date_this_month__c];
            userSalesTarget.Position__c = stsAboveUs.size() + 1;
        }else{
            List<Sales_target__c> stsAboveUs = [SELECT Id FROM Sales_target__c WHERE Sales_to_date_this_quarter__c > :userSalesTarget.Sales_to_date_this_quarter__c];
            userSalesTarget.Position__c = stsAboveUs.size() + 1;
        }

        return userSalesTarget;
    }

    public static Integer getSalesTargetPosition(Sales_Target__c target, String type){
        if(type == 'Monthly'){
            List<Sales_target__c> stsAboveUs = [SELECT Id FROM Sales_target__c WHERE Sales_to_date_this_month__c > :target.Sales_to_date_this_month__c];
            return stsAboveUs.size() + 1;
        }else{
            List<Sales_target__c> stsAboveUs = [SELECT Id FROM Sales_target__c WHERE Sales_to_date_this_quarter__c > :target.Sales_to_date_this_quarter__c];
            return stsAboveUs.size() + 1;
        }
    }

    public static String md5(String input){
        return EncodingUtil.base64Encode(Crypto.generateDigest('MD5', Blob.valueOf(input)));
    }

}