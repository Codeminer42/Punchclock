import Immutable from 'immutable';
import moment from 'moment';
import alt from '../alt';
import CalendarActions from '../actions/CalendarActions';
import SheetStore from './SheetStore';

const initial = Immutable.Set();

function key(d) {
  return d.format('YYYY-MM-DD');
}

class SelectionStore {
  constructor() {
    this.bindActions(CalendarActions);
    this.exportPublicMethods({isSelected: this.isSelected.bind(this)});
    this.selecteds = initial;
  }

  onInitializeCalendar(date) {
    this.selecteds = initial.add(key(moment()));
  }

  onSetTimeSheet(sheet) {
    this.waitFor([SheetStore]);
    this.selecteds = initial;
  }

  onErase(sheet) {
    this.waitFor([SheetStore]);
    this.selecteds = initial;
  }

  onToggle(day) {
    if(this.isSelected(day)) {
      this.selecteds = this.selecteds.delete(key(day));
    } else {
      this.selecteds = this.selecteds.add(key(day));
    }
  }

  onSelectWeek(week) {
    week.days.forEach( (d)=> {
      let { day, inner } = d;
      if(day.day() != 0 && day.day() != 6 && inner )
        this.selecteds = this.selecteds.add(key(day));
    });
  }

  onDeselect() {
    this.selecteds = initial;
  }

  onNext() {
    this.onDeselect();
  }

  onPrev() {
    this.onDeselect();
  }

  isSelected(day) {
    return this.selecteds.has(key(day));
  }
}

export default alt.createStore(SelectionStore, 'SelectionStore');
