import alt from '../alt';

class CalendarActions {
  initializeCalendar(dateBase) {
    this.dispatch(dateBase);
  }

  select(day) {
    this.dispatch(day);
  }

  deselect() {
    this.dispatch();
  }
}

export default alt.createActions(CalendarActions);
