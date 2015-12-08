$('input#employee_is_line_manager').change(function() {
  if ($(this).is(':checked')) {
    $('select#employee_line_manager_id').attr('disabled', 'disabled');
  } else {
    $('select#employee_line_manager_id').removeAttr('disabled');
  }
})
