import Immutable from 'immutable';
import alt from '../alt';
import CalendarActions from '../actions/CalendarActions';
import SheetStore from './SheetStore';

const initial = Immutable.Set();

class SelectionStore {
  constructor() {
    this.bindActions(CalendarActions);
    this.exportPublicMethods({getSelecteds: this.getSelecteds.bind(this)});
    this.selectedDays = initial;
  }

  onInitializeCalendar(date) {
    this.selectedDays = initial;
  }

  onSetTimeSheet(sheet) {
    this.waitFor([SheetStore]);
    this.selectedDays = initial;
  }

  onErase(sheet) {
    this.waitFor([SheetStore]);
    this.selectedDays = initial;
  }

  onToggle(day) {
    if(this.selectedDays.has(day)) {
      this.selectedDays = this.selectedDays.delete(day);
    } else {
      this.selectedDays = this.selectedDays.add(day);
    }
  }

  onSelectWeek(week) {
    week.days.forEach( (d)=> {
      let day = d.day;
      if(day.day() != 0 && day.day() != 6 && d.inner )
        this.selectedDays = this.selectedDays.add(day);
    });
  }

  onDeselect() {
    this.selectedDays = initial;
  }

  getSelecteds() {
    return this.selectedDays;
  }

  onNext() {
    this.onDeselect();
  }

  onPrev() {
    this.onDeselect();
  }
}

export default alt.createStore(SelectionStore, 'SelectionStore');
