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
      },
  });
  
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
      },
  });
}