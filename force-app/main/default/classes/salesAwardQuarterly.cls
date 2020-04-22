global class salesAwardQuarterly implements Schedulable{
    public void execute(SchedulableContext sc) {
        list < sales_target__c > SalesTargetsTop3 = new list < sales_target__c > ();
    
        SalesTargetsTop3 = [SELECT Id, icon__c, of_sales_targets__c, Position__c, Target_this_quarter__c, Target_percentage__c, Sales_rep__c, Sales_rep__r.Name, Name, Target_Q1__c, Target_Q2__c, Target_Q3__c, Target_Q4__c, Sales_to_date_this_quarter__c FROM Sales_target__c order by Sales_to_date_this_quarter__c DESC limit 3];

        sales_award__c nr1 = [select id from sales_award__c where name = '1st Prize Sales - Quarterly'
            limit 1
        ];
        sales_award__c nr2 = [select id from sales_award__c where name = '2nd Prize Sales - Quarterly'
            limit 1
        ];
        sales_award__c nr3 = [select id from sales_award__c where name = '3th Prize Sales - Quarterly'
            limit 1
        ];

        list < Sales_Award_History__c > top3 = new list < Sales_Award_History__c > ();

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
}