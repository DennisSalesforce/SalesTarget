({
	doInitHelper : function(component, event) {    
		var action = component.get("c.getTop");

		action.setCallback(this, function(response){
			component.set("v.SalesTarget", response.getReturnValue());
			console.log(response.getReturnValue());
			 });
			$A.enqueueAction(action);
		
	},

	doInitGetPeriod : function(component, event) {
        var action = component.get("c.getPeriod");
        action.setCallback(this, function(response){
            component.set("v.periodName", response.getReturnValue());
        });
        $A.enqueueAction(action);

    }
})