function isHoliday(date) {
  const nationalHolidays = $('.datepicker').data('nationalHolidays');
  const regionalHolidays = $('.datepicker').data('regionalHolidays');
  const allHolidays = nationalHolidays.concat(regionalHolidays);

  const toPairMonthDay = date => [date.getMonth() + 1, date.getDate()];
  const datePair = toPairMonthDay(date);

  const isSamePair = today => holiday => (
    holiday[0] == today[0] &&
    holiday[1] == today[1]
  );

  if (allHolidays.find(isSamePair(datePair))) {
    return false;
  }

  return true;
}

function noWeekendsOrHolidays(date) {
  const noWeekend = $.datepicker.noWeekends(date);
  if (noWeekend[0]) {
    return [isHoliday(date)];
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
