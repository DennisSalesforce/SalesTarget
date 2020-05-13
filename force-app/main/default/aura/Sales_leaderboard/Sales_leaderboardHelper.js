({
	doInitHelper : function(component, event) {
        var filterByTeam = component.get("v.filterByTeam");
        var sortBy = component.get("v.sortBy");
        var action = component.get("c.getAllSalesTargets");
        action.setParams({sortBy : sortBy, filterByTeam : filterByTeam});
        action.setCallback(this, function(response){
            component.set("v.SalesTarget", response.getReturnValue());
            component.set("v.loading", false);
        	console.log(response.getReturnValue());
        });
        $A.enqueueAction(action);

    },
    onRender: function (cmp) {
        // var interval = setInterval($A.getCallback(function () {
        //     var progress = cmp.get('v.progress');
        //     cmp.set('v.progress', progress === 100 ? clearInterval(interval) : progress + 10);
        // }), 200);
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

        component.set("v.filterByTeam", filter);
        component.set("v.loading", true);
        this.doInitHelper(component);
    },

    updateSort: function(component, event){
        var filter = event.getSource().get('v.value');

        component.set("v.sortBy", filter);
        component.set("v.loading", true);
        this.doInitHelper(component);
    },

    doInitGetSalesTeam: function(component, event) {
        var action = component.get("c.getSalesTeam");
        action.setCallback(this, function(response){
            component.set("v.SalesTeam", response.getReturnValue());
        	console.log(response.getReturnValue());
             });
            $A.enqueueAction(action);
    }
})