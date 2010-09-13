$.ajax({
	url: "/members_search_auto_complete_data",
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
    })
    .data("autocomplete")._renderItem = function(ul, item) {
			return $("<li></li>")
				.data("item.autocomplete", item)
				.append('<a>' + item.logo + '<h4>' + item.label + '</h4><small>' + item.description + '</small></a>')
				.appendTo( ul );
		};
	}
});

$("#q").focus();