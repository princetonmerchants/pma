$(document).ready(function () { 
  init_quicksearch();
  if($('#message_body').length > 0) { 
    init_wall();
  }
  $.localScroll();
  $('.tabs').tabs();
  $('.accordion').accordion({autoHeight:false, collapsible:true, navigation:true});
  $('a.button').button();
  $('abbr.timeago').timeago();
  $('textarea[class!=manualgrow]').autogrow();  
  $('.expandable').expander({
    slicePoint: 200, 
    expandText: 'Read More', 
    collapseTimer: 0, 
    userCollapseText: 'Read Less'
  });
  load_notifications();
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
        $('#message_body').css('height', '30px');
        $('#messages a.button').button();
        $('#messages abbr.timeago').timeago();
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
        function(arr, $form, options) {
          if($form.find('#message_response_body').val() == "") {
            return false;
          }
        },
      success: 
        function(responseText, statusText, xhr, $form) { 
          $(responseText).insertBefore($form.parentsUntil('.message').find('.responses .new')).hide().show("blind");
          $form.find('#message_response_body').css('height', '20px');
          $('a.button').button();
          $('abbr.timeago').timeago();
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
  	url: "/members_at_auto_complete_json",
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
  
  auto_load_more_messages = true;
  $(window).scroll(function(){
    if(auto_load_more_messages && more_messages_exist &&
    ($(window).scrollTop() >= $(document).height() - $(window).height() - 400) && 
    ($(window).scrollTop() <= $(document).height() - $(window).height())) {
      auto_load_more_messages = false; 
      load_more_messages();
    }
  });
  
  $('#more-messages').click(function() {
    load_more_messages();
    return false;
  });
  
  function load_more_messages() {
    $('#more-messages').hide('blind');
    $('#loading').show('blind');
    page += 1;
    $.ajax({
    	url: (current_member['id'] == member_id ? "/account_more_messages" : "/others_more_messages"),
    	cache: false,
    	data: 'id=' + member_id + '&page=' + page,
    	success: function(data) {
        $('#messages').append(data);
        $('#messages a.button').button();
        $('#messages abbr.timeago').timeago();
        init_responses();
    	}
    });
  }
}

function load_notifications() {
  $.ajax({
  	url: "/notifications",
  	cache: false,
  	success: function(data) {
      $('#notifications').html(data);
      $('#notifications abbr.timeago').timeago();
  	}
  });
}