({
	doInit : function(component, event, helper) {
		helper.doInitHelper(component, event);
		helper.doInitDaysLeft(component, event);
		helper.showAwards(component, event);
		helper.getAwards(component, event);
		helper.getHotOpportunities(component, event);
	},

    loadProgress : function(component,event,helper){
    	helper.onRender(component, event);
	},

	onClickGold : function(component,event,helper){
		helper.showWonAwardsGoldHelper(component, event);
	},
	onClickSilver : function(component,event,helper){
		helper.showWonAwardsSilverHelper(component, event);
	},
	onClickBronze : function(component,event,helper){
		helper.showWonAwardsBronzeHelper(component, event);
	},
	onClickHundred : function(component,event,helper){
		helper.showWonAwardsHundredHelper(component, event);
	},

	onClickClose : function(component,event,helper){
		helper.closeShowWonAwardsHelper(component, event);
	},

	toggleHotOpportunities : function(component, event, helper){
		var currentValue = component.get('v.showHotOpportunties')
		component.set('v.showHotOpportunties', !currentValue);
	},

	onClickShowOpps : function(component,event,helper){
		helper.getWonWonOppsHelper(component, event);
	},

	closeShowOpps : function(component,event,helper){
		helper.closeWonWonOppsHelper(component, event);
	}

})