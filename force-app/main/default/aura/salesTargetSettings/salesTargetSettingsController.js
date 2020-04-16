({
    setMonthYear:function(component,event,helper){
		helper.updateQuarterHelper(component, event);
		helper.setMonthYearHelper(component, event);
		
	},

	storeAwards:function(component,event,helper){
        helper.storeAwardsYearHelper(component, event);
	},
	
	doInit:function(component,event,helper){
		helper.doInitHelper(component, event);
		helper.doInitAwardsHelper(component, event);
    }
 })