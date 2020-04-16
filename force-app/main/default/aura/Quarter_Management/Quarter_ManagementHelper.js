({
	doInitHelper : function(component, event) {
		var action = component.get("c.getQuarters");
        action.setCallback(this, function(response){
			component.set("v.Period", response.getReturnValue());
        	console.log(response.getReturnValue());
             });
    		$A.enqueueAction(action);
	},

	getQuartersHelper : function(component, event) {
		var action = component.get("c.getQuarters");
        action.setCallback(this, function(response){
			component.set("v.Period", response.getReturnValue());
        	console.log(response.getReturnValue());
             });
    		$A.enqueueAction(action);
	}
})