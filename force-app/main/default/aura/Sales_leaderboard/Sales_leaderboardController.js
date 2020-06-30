({
  doInit: function (component, event, helper) {
    helper.doInitHelper(component, event);
    helper.doInitDaysLeft(component, event);
    helper.doInitGetSalesTeam(component, event);
  },
  loadProgress: function (component, event, helper) {
    helper.onRender(component, event);
  },
  updateFilter: function (component, event, helper) {
    helper.updateFilter(component, event);
  },
  updateSort: function (component, event, helper) {
    helper.updateSort(component, event);
  }
});