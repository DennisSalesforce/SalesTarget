({
	doInitHelper : function(component, event) {      
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set("v.runningUserId", userId);
        
        var action = component.get("c.getSalesTarget");
        action.setParams({userid : userId});
        action.setCallback(this, function(response){
            component.set("v.SalesTarget", response.getReturnValue());
        	console.log(response.getReturnValue());
             });
    		$A.enqueueAction(action);
        
	},   
    onRender: function (cmp) {
        var interval = setInterval($A.getCallback(function () {
            var progress = cmp.get('v.progress');
            cmp.set('v.progress', progress === 100 ? clearInterval(interval) : progress + 10);
        }), 200);
    }
})