import alt from '../alt';

class CalendarActions {
  constructor(){
    this.generateActions(
      'initializeCalendar',
      'toggle',
      'deselect',
      'setTimeSheet',
      'setTimeSheetOnSelecteds',
      'erase'
    );
  }
}

export default alt.createActions(CalendarActions);
