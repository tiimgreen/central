// Initialise popovers
$(function () {
  $('[data-toggle="popover"]').popover();
});

// Initialise tooltips
$(function () {
  $('[data-toggle="tooltip"]').tooltip()
})

$('.table-check-in-times__time.-link').on('click', function(e) {
  e.preventDefault(); // prevents normal events fired when link is clicked

  $('.popover').popover('hide'); // hide all popovers
  $(this).popover('show'); // show popover for current element

  // finds ID of visible popover
  var popover_identifier = '#' + $(this).attr('aria-describedby') + ' .popover-content';

  // finds ID of form relating to currently clicked time
  var form_identifier ='.hidden-time-form.' + $(this).attr('data-check-in-id') + '-' + $(this).attr('data-check-in-type');

  // set the popover content to the html form
  $(popover_identifier).html($(form_identifier).html());

  // add an 'x' to the title, which will close the popover when clicked
  $('.popover .popover-title').append('<span class="pull-right popover-close">&times;</span>');
});

// Scopes through the document as the .popover-close element is dynamically added
$(document).on('click', '.popover-close', function() {
  $('.popover').popover('hide');
})
