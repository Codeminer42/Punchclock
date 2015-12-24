import alt from '../alt';

class CalendarActions {
  constructor(){
    this.generateActions(
      'initializeCalendar',
      'toggle',
      'deselect',
      'selectWeek',
      'setTimeSheet',
      'setTimeSheetOnSelecteds',
      'erase',
      'prev',
      'next'
    );
  }
}

export default alt.createActions(CalendarActions);
