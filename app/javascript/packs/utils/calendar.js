import Immutable from 'immutable';
import moment from 'moment';

const daysPerWeek = 7;
const Day = Immutable.Record({day: undefined, inner: undefined, today: false});
const Week = Immutable.Record({days: Immutable.List()});

export function prev(base){
  return base.clone().subtract(1, 'M').date(base.date());
}

export function next(base){
  return base.clone().add(1, 'M').date(base.date());
}

export function week(date, range){
  return Immutable.Range(0, daysPerWeek).map((i)=> {
    let day = date.clone().add(i, 'd');
    let [from, to] = range;
    let inner = day.isBetween(from, to, 'day');
    let today = day.isSame(moment(), 'day');
    return new Day({ day: day, inner: inner, today: today });
  });
}

export function weeks(start, range){
  const weeksToShow = 5;
  return Immutable.Range(0, weeksToShow).map((i)=> {
    return new Week({days: week(start.clone().add(i, 'w'), range)});
  });
}

export function innerRange(base){
  return [base.clone().subtract(1, 'M').date(base.date()),
          moment.min(base.clone().add(1, 'd'), moment().add(1, 'd'))];
}

export function monthNames(range){
  let [from, to] = range;

  if(from.year() != to.year()) {
    return [from.format('MMM YYYY'), to.format('MMM YYYY')].join(' / ');
  } else if(from.month() == to.month()) {
    return from.format('MMMM YYYY');
  }

  return [from.format('MMM'), to.format('MMM')].join(' / ') + to.format(' YYYY');
}

export function startDate(base){
  return base.clone().subtract(1, 'M').date(base.date()).add(1, 'day').day(0);
}

export function current() {
  return moment().add(1, 'M');
}

export function constraintMonth(year, month) {
  return parseInt(current().format('YYYYMM')) < parseInt(`${year}${month}`);
}

export const isHoliday = (selecteds, day, holidays) => {
  return holidays.findIndex((element) => ((element.month === (day.month() + 1))
    && (element.day === day.date()))) >= 0
    && !overtimeAllowed()
}

export const overtimeAllowed = () => {
  return OvertimeAllowed
}

export const getHolidaysFromState = (getState) => {
  const { calendarReducer: { holidays } } = getState();
  return holidays;
}

export const compareHours = ({ date = new Date(), firstHour, secondHour }) => {
  const onlyDate = moment(date).format('YYYY-MM-DD');

  return Date.parse(`${onlyDate} ${firstHour}`) < Date.parse(`${onlyDate} ${secondHour}`)
}
