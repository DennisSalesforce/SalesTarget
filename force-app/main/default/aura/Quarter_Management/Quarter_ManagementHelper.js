({
	doInitHelper : function(component, event) {
		var action = component.get("c.getQuarterDates");
        action.setCallback(this, function(response){
			component.set("v.Quarter", response.getReturnValue());
        	console.log(response.getReturnValue());
             });
    		$A.enqueueAction(action);
	}
})