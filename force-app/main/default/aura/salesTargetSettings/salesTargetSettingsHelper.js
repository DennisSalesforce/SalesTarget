({
	doInitHelper : function(component, event) {
		var monthly = component.find("checkboxvalue").get("v.value");
		var action = component.get("c.currentSetting");
		action.setParams({monthly : monthly});
		action.setCallback(this, function(response){
            component.set("v.checkboxvalue", response.getReturnValue());
        	console.log(response.getReturnValue());
             });
    		$A.enqueueAction(action);
	},

	doInitShowAwardsHelper : function(component, event) {
		var action = component.get("c.currentAwardShowSetting");
		action.setCallback(this, function(response){
            component.set("v.showAwards", response.getReturnValue());
        	console.log(response.getReturnValue());
             });
    		$A.enqueueAction(action);
	},

	doInitAwardsHelper : function(component, event) {
		var storeAwards = component.find("storeAwards").get("v.value");
		var action = component.get("c.currentAwardSetting");
		action.setParams({storeAwards : storeAwards});
		action.setCallback(this, function(response){
            component.set("v.storeAwards", response.getReturnValue());
        	console.log(response.getReturnValue());
             });
    		$A.enqueueAction(action);
	},

	updateQuarterHelper : function(component, event) {
		var monthly = event.getSource().get('v.value');
		var action = component.get("c.UpdateSalesTargetsAfterSetting");
		action.setParams({updatedValue : monthly});
		action.setCallback(this, function(response){
			component.set("v.checkboxvalue", response.getReturnValue());
        	console.log(response.getReturnValue());
             });
    		$A.enqueueAction(action);
	},

	showAwardsHelper : function(component, event) {
		var showAwards = event.getSource().get('v.value');
		var action = component.get("c.updateShowAward");
		action.setParams({showAwards : showAwards});
		action.setCallback(this, function(response){
            component.set("v.showAwards", response.getReturnValue());
        	console.log(response.getReturnValue());
             });
			$A.enqueueAction(action);
	},

	setMonthYearHelper : function(component, event) {
		var monthly = event.getSource().get('v.value');
		var action = component.get("c.updateMonthlySettings");
		action.setParams({monthly : monthly});
		action.setCallback(this, function(response){
            component.set("v.checkboxvalue", response.getReturnValue());
        	console.log(response.getReturnValue());
             });
    		$A.enqueueAction(action);
	},

	storeAwardsYearHelper : function(component, event) {
		var storeAwards = event.getSource().get('v.value');
		var action = component.get("c.updateStoreAwards");
		action.setParams({storeAwards : storeAwards});
		action.setCallback(this, function(response){
            component.set("v.storeAwards", response.getReturnValue());
        	console.log(response.getReturnValue());
             });
    		$A.enqueueAction(action);
	}
})