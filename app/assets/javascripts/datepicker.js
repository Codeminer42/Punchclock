
// DISABLE FOR NOW
const extractHolidays = function($el) {
  return $el.data('nationalHolidays').concat($el.data('regionalHolidays'));
}

const toPairMonthDay = function(date) { return [date.getMonth() + 1, date.getDate()]; }

const isSamePair = function(today) {
  return function(holiday) {
    return holiday[0] == today[0] &&
      holiday[1] == today[1]
  }
}

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
  var defaultOptions = { dateFormat: 'dd/mm/yy' };
  const allowOvertime = $(".datepicker").data("allowOvertime");
  const options = allowOvertime
    ? defaultOptions
    : { defaultOptions: defaultOptions, beforeShowDay: noWeekendsOrHolidays };

  $('input.datepicker').datepicker(defaultOptions);
}
