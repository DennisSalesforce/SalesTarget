({
	doInit : function(component, event, helper) {
		helper.doInitHelper(component, event);
		helper.doInitDaysLeft(component, event);
		helper.showAwards(component, event);
		helper.getAwards(component, event);
	},

    loadProgress : function(component,event,helper){
    	helper.onRender(component, event);
	},

	onClick : function(component,event,helper){	
		helper.showWonAwardsHelper(component, event); 
	},

	onClickClose : function(component,event,helper){	
		helper.closeShowWonAwardsHelper(component, event); 
	},
	
	onClickShowOpps : function(component,event,helper){	
		helper.getWonWonOppsHelper(component, event); 
	},

	closeShowOpps : function(component,event,helper){	
		helper.closeWonWonOppsHelper(component, event); 
	}

})