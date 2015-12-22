import moment from 'moment';
import alt from '../alt';
import CalendarActions from '../actions/CalendarActions';
import * as Calendar from '../utils/calendar';

class CalendarStore {
  constructor() {
    this.bindActions(CalendarActions);

    moment.locale('pt');

    this.base = null;
    this.start = null;
    this.monthNames = [];
    this.weeks = [];
    this.weekdays = moment.weekdaysMin();
  }

  onInitializeCalendar(date) {
    this.base = moment(date);
    let range = Calendar.innerRange(this.base);

    this.start = Calendar.startDate(this.base);
    this.monthNames = Calendar.monthNames(range);
    this.weeks = Calendar.weeks(this.start, range);
  }
}

export default alt.createStore(CalendarStore, 'CalendarStore');
