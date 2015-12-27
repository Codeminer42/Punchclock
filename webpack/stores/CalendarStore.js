import moment from 'moment';
import alt from '../alt';
import Immutable from 'immutable';
import CalendarActions from '../actions/CalendarActions';
import * as Calendar from '../utils/calendar';

class CalendarStore {
  constructor() {
    this.bindActions(CalendarActions);
    this.exportPublicMethods({getDays: this.getDays.bind(this)});

    moment.locale('pt');

    this.base = null;
    this.start = null;
    this.hasNext = false;
    this.monthNames = Immutable.List();
    this.weeks = Immutable.List();
    this.weekdays = moment.weekdaysMin();
  }

  onInitializeCalendar(date) {
    this.redefine(moment(date));
  }

  onPrev(history) {
    this.redefine(Calendar.prev(this.base));
    history.push(this.base.format('YYYY/MM'));
  }

  onNext(history) {
    this.redefine(Calendar.next(this.base));
    history.push(this.base.format('YYYY/MM'));
  }

  redefine(base) {
    this.base = base;
    let range = Calendar.innerRange(this.base);


    this.hasNext = moment().diff(range[1], 'day') >= 1;
    this.start = Calendar.startDate(this.base);
    this.monthNames = Calendar.monthNames(range);
    this.weeks = Calendar.weeks(this.start, range);
  }

  getDays() {
    return this.weeks.flatMap(function(w){ return w.days; });
  }
}

export default alt.createStore(CalendarStore, 'CalendarStore');
