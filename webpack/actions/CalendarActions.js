import alt from '../alt';

class CalendarActions {
  initializeCalendar(dateBase) {
    this.dispatch(dateBase);
  }
}

export default alt.createActions(CalendarActions);
