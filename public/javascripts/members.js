$(document).ready(function () { 
  init_quicksearch();
  init_wall();
});

function init_quicksearch() {
  init_qs_msg = $('#qs').val();
  
  $('#qs').focus(function() {
    $('#qs').val('');
  });

  $('#qs').keyup(function() {
    if(($('#qs').val() == '' || $('#qs').val() == init_qs_msg) && $('#index').is(':hidden')) {
      $('#index').show();
      $('#clear').hide();
    }
    if(($('#qs').val() != '' && $('#qs').val() != init_qs_msg) && $('#index').is(':visible')) {
      $('#index').hide();
      $('#clear').show();
    }
  });
  
  $('#qs').keyup();
  
  $('#qs').blur(function() {
    if($('#qs').val() == '') {
      $('#index').show();
      $('#clear').hide();
      $('#qs').val(init_qs_msg);
    }
  });
  
  $('#clear').click(function() {
    $('#qs').val('');
    $('#qs').keyup();
    $('#qs').val(init_qs_msg);
  });
  
  $('#qs').quicksearch('#members li', {'noResults':'#no-results'});
}

function init_wall() {
  $('#message_body').focus(function() {
    $('#message_body').autogrow();
    if($('#message_body').val() == "What's your company up to?" ||
    $('#message_body').val() == "Write something...") {
      init_wall_msg = $('#message_body').val();
      $('#message_body').val("");
    }
  });
  
  $('#message_body').blur(function() {
    if($('#message_body').val() == "") {
      $('#message_body').val(init_wall_msg);
    }
  });

  $('#new-message').ajaxForm({ 
    target: null,
    resetForm: true,
    beforeSubmit: 
      function() {
        if($('#message_body').val() == "" ||
        $('#message_body').val() == "What's your company up to?" ||
        $('#message_body').val() == "Write something...") {
          return false;
        }
      },
    success: 
      function(responseText, statusText, xhr, $form)  { 
        $(responseText).prependTo('#messages').hide().show("blind");
        $('a.button').button();
        init_responses();
      },
  });
  
  init_responses();
  function init_responses() {  
    $('.message a.comment').live('click', function() {
      $('li.new').hide();
      $(this).parentsUntil('.message').find('li.new').show().find('textarea').focus().autogrow();
    });
  
    $('.new-response').ajaxForm({ 
      target: null,
      resetForm: true,
      beforeSubmit: 
        function() {
          if($(this).find('#message_response_body').val() == "") {
            return false;
          }
        },
      success: 
        function(responseText, statusText, xhr, $form) { 
          $(responseText).insertBefore($form.parentsUntil('.message').find('.responses .new')).hide().show("blind");
          $('a.button').button();
        },
    });
  }
  
  function extractCurrent() {
    var start = $("#message_body").caret().start;
    for(i=start; i >= 0; i--) {
      if($("#message_body").val()[i] == '@') {
        return $("#message_body").val().substr(i+1, start-i-1);
      }
    }
    return false;
  }
  
  function extractCurrentStart() {
    var start = $("#message_body").caret().start;
    for(i=start; i >= 0; i--) {
      if($("#message_body").val()[i] == '@') {
        return i;
      } 
    }
    return false;
  }
  
  
  $("#message_body").keydown(function(event) {
    var isOpen = $(this).autocomplete("widget").is(":visible");
    var keyCode = $.ui.keyCode;
    if(!isOpen && (event.keyCode == keyCode.UP || event.keyCode == keyCode.DOWN)) {
      event.stopImmediatePropagation();
    }
  });
  
  $.ajax({
  	url: "/members_at_auto_complete_data",
  	dataType: "json",
  	cache: true,
  	success: function(data) {
  	  $("#message_body").autocomplete({
      	dataType: "json",
      	source: function(request, response) {
  				response($.ui.autocomplete.filter(data, extractCurrent()));
  			},
      	search: function(event, ui) {
      	 return extractCurrent();
      	},
      	focus: function(item) {
      	 return false;
        },
        select: function(event, ui) {
          $(this).val(
            $(this).val().substr(0, extractCurrentStart()) + 
            ui.item.value +
            $(this).val().substr($(this).caret().start)
          );
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
}