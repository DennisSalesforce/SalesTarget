({
	doInit : function(component, event, helper) {
		helper.doInitHelper(component, event);
		helper.doInitDaysLeft(component, event);
		helper.getAwards(component, event);
        
	},
    loadProgress : function(component,event,helper){
    	helper.onRender(component, event);
    
}
})