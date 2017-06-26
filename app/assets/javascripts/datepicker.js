function nationalDays(date) {
  nationalHolidays = $('.datepicker').data('nationalHolidays');

  for (i = 0; i < nationalHolidays.length; i++) {
    if (date.getMonth() == nationalHolidays[i][0] - 1 && date.getDate() == nationalHolidays[i][1]) {
     return [false, ''];
    }
  }
  return [true, ''];
}

function noWeekendsOrHolidays(date) {
  var noWeekend = $.datepicker.noWeekends(date);
  if (noWeekend[0]) {
    return nationalDays(date);
  } else {
    return noWeekend;
  }
}

function setDatePicker() {
  const defaultOptions = { dateFormat: 'yy-mm-dd' };
  const allowOvertime = $(".datepicker").data("allowOvertime");
  const options = allowOvertime
    ? defaultOptions
    : { defaultOptions, beforeShowDay: noWeekendsOrHolidays };
  $('input.datepicker').datepicker(options);
}
