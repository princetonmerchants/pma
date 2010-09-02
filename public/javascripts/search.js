$.ajax({
	url: "/members_auto_complete_data",
	dataType: "json",
	cache: true,
	success: function(data) {
	 $("#q").autocomplete({
      source: data,		
    	dataType: "json",
    	focus: function(item) {
    	 return false;
      },	
      select: function(event, ui) {
        location.href = ui.item.value;
        return false;
      }
    });
	}
});
