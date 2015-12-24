import _ from 'lodash';
import alt from '../alt';
import CalendarActions from '../actions/CalendarActions';

class SelectionStore {
  constructor() {
    this.bindActions(CalendarActions);
    this.exportPublicMethods({getSelecteds: this.getSelecteds.bind(this)});
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

  onSelectWeek(week) {
    week.days.forEach( (d)=> {
      let day = d.day;
      if(day.day() != 0 && day.day() != 6 && d.inner )
        this.selectedDays.push(day);
    });
  }

  onDeselect() {
    this.selectedDays = [];
  }

  getSelecteds() {
    return this.selectedDays;
  }
}

export default alt.createStore(SelectionStore, 'SelectionStore');
