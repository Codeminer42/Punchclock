const extractHolidays = function($el) {
  return $el.data('holidays');
}

const toPairMonthDay = function(date) { 
  return [date.getMonth() + 1, date.getDate()];
}

const isSamePair = function(date) {
  return function(holiday) {
    return holiday.month == date[0] && holiday.day == date[1]
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
  const defaultFormat = 'dd/mm/yy';
  const options = {
                    dateFormat: defaultFormat,
                    defaultOptions: defaultFormat,
                    beforeShowDay: noWeekendsOrHolidays
                  };
  $('input.datepicker').datepicker(options);
}
