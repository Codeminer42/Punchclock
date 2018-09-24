const extractHolidays = function($el) {
  var nationalHolidays = $el.data('nationalHolidays');
  var regionalHolidays = $el.data('regionalHolidays');
  
  if (regionalHolidays == undefined || regionalHolidays == '') {
    return nationalHolidays;
  } else {
    return nationalHolidays.concat(regionalHolidays);;
  }
}

const toPairMonthDay = function(date) { 
  return [date.getMonth() + 1, date.getDate()];
}

const isSamePair = function(today) {
  return function(holiday) {
    return holiday[0] == today[0] && holiday[1] == today[1]
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
