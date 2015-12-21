import alt from '../alt';

class CalendarActions {
  constructor(){
    this.generateActions('initializeCalendar', 'toggle', 'deselect');
  }
}

export default alt.createActions(CalendarActions);
