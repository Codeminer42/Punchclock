function isHoliday(date) {
  const nationalHolidays = $('.datepicker').data('nationalHolidays');
  const regionalHolidays = $('.datepicker').data('regionalHolidays');
  const allHolidays = nationalHolidays.concat(regionalHolidays);

  date = [date.getMonth() + 1, date.getDate()];

  if (allHolidays.find(isSameDay, {date: date})) {
    return [false, ''];
  }

  return [true, ''];
}

function isSameDay(holiday) {
  return holiday[0] ===  this.date[0] && holiday[1] === this.date[1];
}

function noWeekendsOrHolidays(date) {
  const noWeekend = $.datepicker.noWeekends(date);
  if (noWeekend[0]) {
    return isHoliday(date);
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
