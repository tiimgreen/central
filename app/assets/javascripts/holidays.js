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

  // for (var i = 0; i < difference; i++) {
  //   var new_date = start_date.add(i + 1, 'days');
  //   console.log(i + 1, new_date);
  // }

  // console.log(start_date.isoWeekday(), end_date.isoWeekday());
  // $('.remaining-days').html('test');
});
