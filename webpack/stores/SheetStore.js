import alt from '../alt';
import SelectionStore from './SelectionStore';
import CalendarActions from '../actions/CalendarActions';

class SheetStore {
  constructor() {
    this.bindActions(CalendarActions);
    this.sheets = {};
  }

  onSetTimeSheet(sheet) {
    SelectionStore.getSelecteds().forEach( (day)=> {
      this.sheets[day.format()] = sheet;
    });
  }

  onErase() {
    SelectionStore.getSelecteds().forEach( (day)=> {
      this.sheets[day.format()] = null;
    });
  }
}

export default alt.createStore(SheetStore, 'SheetStore');
