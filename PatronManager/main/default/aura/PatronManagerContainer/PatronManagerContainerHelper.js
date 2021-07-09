({
	retrieveCities : function(cmp, event, helper) {
		cmp.set("v.isLoading", true);
        let action = cmp.get("c.getCities");
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
               	cmp.set("v.listOfCities",response.getReturnValue());
				cmp.set("v.isLoading", false);
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
						helper.fireToastMessage(cmp, errors);
                    }
                } else {
                    console.log("Unknown error");
                }
				cmp.set("v.isLoading", false);
            }
			

        });
		
        $A.enqueueAction(action);
	},

	searchCity : function(cmp, event, helper){
		cmp.set("v.isLoading", true);
		let termValue = cmp.get("v.searchKeyWord");
		let action = cmp.get("c.searchCity");
		action.setParams({keyTerm : termValue});

        action.setCallback(this, function(response) {
			debugger;
            let state = response.getState();
            if (state === "SUCCESS") {
				//refresh component
               	helper.retrieveCities(cmp,event,helper);
				cmp.set("v.isLoading", false);
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.fireToastMessage(cmp, errors);
                    }
                } else {
                    console.log("Unknown error");
                }
				cmp.set("v.isLoading", false);
            }
			
        });
		
        $A.enqueueAction(action);
		
	},

	fireToastMessage: function(cmp, errors){
		let toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							"type": "Error",
							"title": "Error!",
							"message": errors[0].message
						});
						toastEvent.fire();
	}
})