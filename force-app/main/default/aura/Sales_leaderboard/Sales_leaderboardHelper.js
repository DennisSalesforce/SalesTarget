({
  doInitHelper: function (component, event) {

    // First run the getPeriod function to init that variable
    this.getPeriod(component, event, function(){
      // On the callback, call the getLeaderboard stats
      var filterByTeam = component.get("v.filterByTeam");
      var sortBy = component.get("v.sortBy");

      var getLeaderboardAction = component.get("c.getLeaderboardStats");
      getLeaderboardAction.setParams({
        sortBy: sortBy,
        filterByTeam: filterByTeam
      });
      getLeaderboardAction.setCallback(this, function (response) {
        component.set("v.LeaderboardStats", response.getReturnValue());
        component.set("v.loading", false);
      });

      $A.enqueueAction(getLeaderboardAction);

    });
  },

  getPeriod: function (component, event, callback) {
    var getPeriodAction = component.get("c.getPeriod");

    getPeriodAction.setCallback(this, function (response) {
      component.set("v.periodName", response.getReturnValue());

      if (response.getReturnValue() == "Month") {
        component.set("v.sortBy", "Target_percentage_this_month__c");
      } else {
        component.set("v.sortBy", "Target_percentage__c");
      }

      if(callback != null) callback();
    });

    $A.enqueueAction(getPeriodAction);
  },

  onRender: function (cmp) {
    // var interval = setInterval($A.getCallback(function () {
    //     var progress = cmp.get('v.progress');
    //     cmp.set('v.progress', progress === 100 ? clearInterval(interval) : progress + 10);
    // }), 200);
  },

  doInitDaysLeft: function (component, event) {
    var action = component.get("c.daysLeftInQuarter");
    action.setCallback(this, function (response) {
      component.set("v.daysLeftInQuarter", response.getReturnValue());
      console.log(response.getReturnValue());
    });
    $A.enqueueAction(action);
  },

  updateFilter: function (component, event) {
    var filter = event.getSource().get("v.value");

    component.set("v.filterByTeam", filter);
    component.set("v.loading", true);
    this.doInitHelper(component);
  },

  updateSort: function (component, event) {
    var filter = event.getSource().get("v.value");

    component.set("v.sortBy", filter);
    component.set("v.loading", true);
    this.doInitHelper(component);
  },

  doInitGetSalesTeam: function (component, event) {
    var action = component.get("c.getSalesTeam");
    action.setCallback(this, function (response) {
      component.set("v.SalesTeam", response.getReturnValue());
      console.log(response.getReturnValue());
    });
    $A.enqueueAction(action);
  }
});