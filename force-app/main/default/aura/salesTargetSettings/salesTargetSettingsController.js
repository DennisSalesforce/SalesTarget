({
	doInit:function(component,event,helper){
		helper.doInitHelper(component, event);
		helper.doInitAwardsHelper(component, event);
		helper.doInitShowAwardsHelper(component, event);
	},

    setMonthYear:function(component,event,helper){
		helper.updateQuarterHelper(component, event);
		helper.setMonthYearHelper(component, event);
	},

	storeAwards:function(component,event,helper){
        helper.storeAwardsYearHelper(component, event);
	},

	showAwards:function(component,event,helper){
        helper.showAwardsHelper(component, event);
	}
 })