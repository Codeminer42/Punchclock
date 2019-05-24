var extractHolidays = function($el) {
  return $el.data('holidays');
}

var extractAllowOvertime = function($el) {
  return $el.data('allow-overtime');
}

var toPairMonthDay = function(date) {
  return [date.getMonth() + 1, date.getDate()];
}

var isSamePair = function(date) {
  return function(holiday) {
    return holiday.month == date[0] && holiday.day == date[1]
  }
}

function isHoliday(date) {
  var allHolidays = extractHolidays($('.datepicker'));
  var datePair = toPairMonthDay(date);
  return !allHolidays.find(isSamePair(datePair));
}

function noWeekendsOrHolidays(date) {
  var noWeekend = $.datepicker.noWeekends(date);
  if (noWeekend[0]) {
    return [isHoliday(date)];
  } else {
    return noWeekend;
  }
}

function setDatePicker() {
  var defaultFormat = 'dd/mm/yy';
  var allowOvertime = extractAllowOvertime($('.datepicker'));
  var options = allowOvertime ? { dateFormat: defaultFormat } : {
                    dateFormat: defaultFormat,
                    defaultOptions: defaultFormat,
                    beforeShowDay: noWeekendsOrHolidays
                  };

  $('input.datepicker').datepicker(options);
}
