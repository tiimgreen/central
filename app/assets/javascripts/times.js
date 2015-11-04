$(function () {
  $('[data-toggle="popover"]').popover();
});

$('.table-check-in-times__link').on('click', function(e) {
  e.preventDefault();

  $('.popover').popover('hide'); // hide all popovers
  $(this).popover('show'); // show popover for current element

  var popover_identifier = '#' + $(this).attr('aria-describedby') + ' .popover-content';
  var form_identifier =
    '.hidden-time-form.' + $(this).attr('data-check-in-id') + '-' + $(this).attr('data-check-in-type');

  $(popover_identifier).html($(form_identifier).html());
  $('.popover .popover-title').append('<span class="pull-right popover-close">&times;</span>');
});

// Scopes through the document as the .popover-close element is dynamically added
$(document).on('click', '.popover-close', function() {
  $('.popover').popover('hide');
})
