({
	doInit : function(cmp, event, helper) {
		helper.retrieveCities(cmp, event, helper);
	},

	searchKeyTerm : function(cmp, event, helper){
		helper.searchCity(cmp, event, helper);
	}
})