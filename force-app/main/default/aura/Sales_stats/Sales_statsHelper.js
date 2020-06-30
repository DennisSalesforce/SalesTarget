({
    doInitHelper: function (component, event) {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set("v.runningUserId", userId);

        var action = component.get("c.getSalesTarget");
        action.setParams({
            userid: userId
        });
        action.setCallback(this, function (response) {
            component.set("v.Sales", response.getReturnValue());
            console.log(response.getReturnValue());
        });
        $A.enqueueAction(action);

    },
    doInitDaysLeft: function (component, event) {
        var action = component.get("c.daysLeftInQuarter");
        action.setCallback(this, function (response) {
            component.set("v.daysLeftInQuarter", response.getReturnValue());
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

    getAwards: function (component, event) {
        var userId = $A.get("$SObjectType.CurrentUser.Id");

        var action = component.get("c.medalAwards");
        action.setParams({
            userid: userId
        });
        action.setCallback(this, function (response) {
            component.set("v.awards", response.getReturnValue());
            console.log(response.getReturnValue());
        });
        $A.enqueueAction(action);

    },

    showAwards: function (component, event) {
        var action = component.get("c.currentAwardShowSetting");
        action.setCallback(this, function (response) {
            component.set("v.showAwards", response.getReturnValue());
            console.log(response.getReturnValue());
        });
        $A.enqueueAction(action);
    },

    showWonAwardsHundredHelper: function (component, event) {
        var userid = $A.get("$SObjectType.CurrentUser.Id");
        var medal = "Hundred";
        var action = component.get("c.getWonAwards");
        action.setParams({
            userid: userid,
            medal : medal
        });
        action.setCallback(this, function (response) {
            component.set("v.wonAwards", response.getReturnValue());
            component.set("v.showWonAwards", true);
            console.log(response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    showWonAwardsGoldHelper: function (component, event) {
        var userid = $A.get("$SObjectType.CurrentUser.Id");
        var medal = "Gold";
        var action = component.get("c.getWonAwards");
        action.setParams({
            userid: userid,
            medal : medal
        });
        action.setCallback(this, function (response) {
            component.set("v.wonAwards", response.getReturnValue());
            component.set("v.showWonAwards", true);
            console.log(response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    showWonAwardsSilverHelper: function (component, event) {
        var userid = $A.get("$SObjectType.CurrentUser.Id");
        var medal = "Silver";
        var action = component.get("c.getWonAwards");
        action.setParams({
            userid: userid,
            medal : medal
        });
        action.setCallback(this, function (response) {
            component.set("v.wonAwards", response.getReturnValue());
            component.set("v.showWonAwards", true);
            console.log(response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    showWonAwardsBronzeHelper: function (component, event) {
        var userid = $A.get("$SObjectType.CurrentUser.Id");
        var medal = "Bronze";
        var action = component.get("c.getWonAwards");
        action.setParams({
            userid: userid,
            medal : medal
        });
        action.setCallback(this, function (response) {
            component.set("v.wonAwards", response.getReturnValue());
            component.set("v.showWonAwards", true);
            console.log(response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    closeShowWonAwardsHelper: function (component, event) {

        component.set("v.showWonAwards", false);

        $A.enqueueAction(action);
    },
    closeWonWonOppsHelper: function (component, event) {

        component.set("v.showWonOpps", false);

        $A.enqueueAction(action);
    },

    getWonWonOppsHelper: function (component, event) {
        var userid = $A.get("$SObjectType.CurrentUser.Id");
        var action = component.get("c.getWonOpps");
        action.setParams({
            userid: userid
        });
        action.setCallback(this, function (response) {
            component.set("v.wonOpps", response.getReturnValue());
            component.set("v.showWonOpps", true);
            console.log(response.getReturnValue());
        });
        $A.enqueueAction(action);
    },

    getHotOpportunities: function (component, event) {
        var userid = $A.get("$SObjectType.CurrentUser.Id");
        var action = component.get("c.HotOpportunities");

        action.setParams({
            userid: userid
        });

        action.setCallback(this, function (response) {
            var list = response.getReturnValue();
            // Round scores
            list = list.map(function (item) {
                item.currentScore = Math.round(item.currentScore);
                return item
            })
            // Sort by score
            list.sort( function (a, b) { return b.currentScore - a.currentScore } );

            component.set("v.hotOpportunities", list);
            console.log(response.getReturnValue());
        });

        $A.enqueueAction(action);
    }
})