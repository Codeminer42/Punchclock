import _ from 'lodash';

const daysPerWeek = 7;
const weeksInCalendar = 5;

export function week(date, range){
  return _.range(daysPerWeek).map((i)=> {
    let day = date.clone().add(i, 'day');
    let [from, to] = range;
    return {day: day, inner: day.isBetween(from, to, 'day')};
  });
}

export function weeks(start, range){
  return _.range(weeksInCalendar).map((i)=> {
    return {days: week(start.clone().add(i, 'week'), range)};
  });
}

export function innerRange(base){
  return [base.clone().date(-base.date()), base.clone().add(1, 'day')];
}

export function monthNames(range){
  let [from, to] = range;
  return [from.format('MMM'), to.format('MMM')];
}

export function startDate(base){
  return base.clone().date(-base.date()).day(0);
}

