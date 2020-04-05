({
	doInitHelper : function(component, event) {      
        var action = component.get("c.getAllSalesTargets");
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