import moment from 'moment';
import _ from 'lodash';
import alt from '../alt';
import CalendarActions from '../actions/CalendarActions';

const daysPerWeek = 7;
const weeksInCalendar = 5;

class CalendarStore {
  constructor() {
    moment.locale('pt');

    this.base = null;
    this.start = null;
    this.monthNames = [];
    this.weeks = [];
    this.weekdays = moment.weekdaysMin();
    this.selectedDays = [];

    this.bindListeners({
      handleInitializeCalendar: CalendarActions.INITIALIZE_CALENDAR,
      handleSelect: CalendarActions.SELECT,
      handleDeselect: CalendarActions.DESELECT
    });
  }

  handleInitializeCalendar(date) {
    this.base = moment(date);
    let range = innerRange(this.base);

    this.start = startDate(this.base);
    this.monthNames = monthNames(range);
    this.weeks = weeks(this.start, range);
    this.selectedDays = [];
  }

  handleSelect(day) {
    if(_.contains(this.selectedDays, day)) {
      this.selectedDays = _.without(this.selectedDays, day);
    } else {
      this.selectedDays.push(day);
    }
  }

  handleDeselect() {
    this.selectedDays = [];
  }
}

function week(date, range){
  return _.range(daysPerWeek).map((i)=> {
    let day = date.clone().add(i, 'day');
    let [from, to] = range;
    return {day: day, inner: day.isBetween(from, to, 'day')};
  });
}

function weeks(start, range){
  return _.range(weeksInCalendar).map((i)=> {
    return {days: week(start.clone().add(i, 'week'), range)};
  });
}

function innerRange(base){
  return [base.clone().date(-base.date()), base.clone().add(1, 'day')];
}

function monthNames(range){
  let [from, to] = range;
  return [from.format('MMM'), to.format('MMM')];
}

function startDate(base){
  return base.clone().date(-base.date()).day(0);
}

export default alt.createStore(CalendarStore, 'CalendarStore');
