import _ from 'lodash';
import moment from 'moment';

const daysPerWeek = 7;
const weeksInCalendar = 6;

export function prev(base){
  return base.clone().subtract(1, 'M').date(base.date());
}

export function next(base){
  return base.clone().add(1, 'M').date(base.date());
}

export function week(date, range){
  return _.range(daysPerWeek).map((i)=> {
    let day = date.clone().add(i, 'd');
    let [from, to] = range;
    return {day: day, inner: day.isBetween(from, to, 'day')};
  });
}

export function weeks(start, range){
  return _.range(weeksInCalendar).map((i)=> {
    return {days: week(start.clone().add(i, 'w'), range)};
  });
}

export function innerRange(base){
  return [base.clone().subtract(1, 'M').date(base.date()),
          moment.min(base.clone().add(1, 'd'), moment())];
}

export function monthNames(range){
  let [from, to] = range;
  if(from.year() != to.year())
    return [from.format('MMM YYYY'), to.format('MMM YYYY')].join(' / ')
  return [from.format('MMM'), to.format('MMM')].join(' / ') + to.format(' YYYY');
}

export function startDate(base){
  return base.clone().subtract(1, 'M').date(base.date()).day(0);
}

