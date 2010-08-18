$(document).ready(function () {  
  $('#message_body').focus(function() {
    $('#message_body').autogrow();
    if($('#message_body').val() == "What's your company up to?" ||
    $('#message_body').val() == "Write something...") {
      original_val = $('#message_body').val();
      $('#message_body').val("");
    }
  });
  
  $('#message_body').blur(function() {
    if($('#message_body').val() == "") {
      $('#message_body').val(original_val);
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
        $('#messages').prepend(responseText);
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
        $(responseText).insertBefore($form.parentsUntil('.message').find('.responses .new'));
      },
  });
});