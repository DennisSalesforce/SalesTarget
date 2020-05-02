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
    doInitDaysLeft : function(component, event) {      
        var action = component.get("c.daysLeftInQuarter");
        action.setCallback(this, function(response){
            component.set("v.daysLeftInQuarter", response.getReturnValue());
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

    getAwards : function(component, event) {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        
        var action = component.get("c.medalAwards");
        action.setParams({userid : userId});
        action.setCallback(this, function(response){
            component.set("v.awards", response.getReturnValue());
        	console.log(response.getReturnValue());
             });
    		$A.enqueueAction(action);

    },
    
    showAwards : function(component, event) {
		var action = component.get("c.currentAwardShowSetting");
		action.setCallback(this, function(response){
            component.set("v.showAwards", response.getReturnValue());
        	console.log(response.getReturnValue());
             });
    		$A.enqueueAction(action);
    },
    
    showWonAwardsHelper :  function(component, event) {
        var userid = $A.get("$SObjectType.CurrentUser.Id");
        var action = component.get("c.getWonAwards");
        action.setParams({userid : userid});
		action.setCallback(this, function(response){
            component.set("v.wonAwards", response.getReturnValue());
            component.set("v.showWonAwards", true);
        	console.log(response.getReturnValue());
             });
    		$A.enqueueAction(action);
    },
    closeShowWonAwardsHelper :  function(component, event) {
    
            component.set("v.showWonAwards", false);
          
    		$A.enqueueAction(action);
    },
    closeWonWonOppsHelper :  function(component, event) {
    
        component.set("v.showWonOpps", false);
      
        $A.enqueueAction(action);
    },
    
    getWonWonOppsHelper :  function(component, event) {
        var userid = $A.get("$SObjectType.CurrentUser.Id");
        var action = component.get("c.getWonOpps");
        action.setParams({userid : userid});
		action.setCallback(this, function(response){
            component.set("v.wonOpps", response.getReturnValue());
            component.set("v.showWonOpps", true);
        	console.log(response.getReturnValue());
             });
    		$A.enqueueAction(action);
    }
})