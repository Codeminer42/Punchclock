import moment from 'moment';
import alt from '../alt';
import Immutable from 'immutable';
import CalendarActions from '../actions/CalendarActions';
import * as Calendar from '../utils/calendar';

class CalendarStore {
  constructor() {
    this.bindActions(CalendarActions);

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

  onPrev() {
    this.redefine(Calendar.prev(this.base));
  }

  onNext() {
    this.redefine(Calendar.next(this.base));
  }

  redefine(base) {
    this.base = base;
    let range = Calendar.innerRange(this.base);

    this.hasNext = range[1] < moment();
    this.start = Calendar.startDate(this.base);
    this.monthNames = Calendar.monthNames(range);
    this.weeks = Calendar.weeks(this.start, range);
  }
}

export default alt.createStore(CalendarStore, 'CalendarStore');
