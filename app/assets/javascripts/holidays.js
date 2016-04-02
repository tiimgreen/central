$('#datepicker.employee-termination-date').daterangepicker({
  locale: {
    format: 'DD/MM/YYYY'
  },
  'applyClass': 'btn-primary',
  singleDatePicker: true
});

$('#daterange').daterangepicker({
  locale: {
    format: 'DD/MM/YYYY'
  },
  'applyClass': 'btn-primary'
},
function(start, end, label) {
  var start_date = moment(start._d);
  var end_date = moment(end._d);
  var difference = end_date.diff(start_date, 'days');
});
