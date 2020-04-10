({
	doInitHelper : function(component, event) {   
       // var filter = component.get("v.filters");   
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
    },

    doInitDaysLeft : function(component, event) {      
        var action = component.get("c.daysLeftInQuarter");
        action.setCallback(this, function(response){
            component.set("v.daysLeftInQuarter", response.getReturnValue());
        	console.log(response.getReturnValue());
             });
    		$A.enqueueAction(action);
        
    },

    updateFilter: function(component, event){
        var filter = event.getSource().get('v.value');

        var action = component.get("c.filterSalesTargets");
        action.setParams({filter : filter});
        action.setCallback(this, function(response){
            component.set("v.SalesTarget", response.getReturnValue());
        	console.log(response.getReturnValue());
             });
    		$A.enqueueAction(action);
        
    }
})