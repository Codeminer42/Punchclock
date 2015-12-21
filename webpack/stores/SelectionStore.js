import _ from 'lodash';
import alt from '../alt';
import CalendarActions from '../actions/CalendarActions';

class SelectionStore {
  constructor() {
    this.bindActions(CalendarActions);
    this.selectedDays = [];
  }

  onInitializeCalendar(date) {
    this.selectedDays = [];
  }

  onToggle(day) {
    if(_.contains(this.selectedDays, day)) {
      this.selectedDays = _.without(this.selectedDays, day);
    } else {
      this.selectedDays.push(day);
    }
  }

  onDeselect() {
    this.selectedDays = [];
  }
}

export default alt.createStore(SelectionStore, 'SelectionStore');
