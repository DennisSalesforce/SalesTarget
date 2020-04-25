({
    doInitHelper : function(component, event) {
        var userId = component.get("v.recordId");
        
        var action = component.get("c.medalAwards");
        action.setParams({userid : userId});
        action.setCallback(this, function(response){
            component.set("v.awards", response.getReturnValue());
        	console.log(response.getReturnValue());
             });
    		$A.enqueueAction(action);
    }
})
