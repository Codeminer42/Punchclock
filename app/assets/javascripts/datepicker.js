const extractHolidays = $el =>
  $el.data('nationalHolidays').concat($el.data('regionalHolidays'));

const toPairMonthDay = date => [date.getMonth() + 1, date.getDate()];

const isSamePair = today => holiday => (
  holiday[0] == today[0] &&
  holiday[1] == today[1]
);

function isHoliday(date) {
  const allHolidays = extractHolidays($('.datepicker'));
  const datePair = toPairMonthDay(date);
  return !allHolidays.find(isSamePair(datePair));
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
