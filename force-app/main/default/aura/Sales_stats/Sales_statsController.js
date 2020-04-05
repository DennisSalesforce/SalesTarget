({
	doInit : function(component, event, helper) {
		helper.doInitHelper(component, event);
		helper.doInitDaysLeft(component, event);
        
	},
    loadProgress : function(component,event,helper){
    	helper.onRender(component, event);
    
}
})