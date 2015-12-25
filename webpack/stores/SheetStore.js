import alt from '../alt';
import Immutable from 'immutable';
import SelectionStore from './SelectionStore';
import CalendarActions from '../actions/CalendarActions';
import ServerActions from '../actions/ServerActions';

const initial = Immutable.Map();

class SheetStore {
  constructor() {
    this.bindActions(CalendarActions);
    this.bindActions(ServerActions);
    this.exportPublicMethods({sheetFor: this.sheetFor.bind(this)});
    this.sheets = initial;
  }

  onSetTimeSheet(sheet) {
    SelectionStore.getSelecteds().forEach( (day)=> {
      this.sheets = this.sheets.set(day.format('YYYY-MM-DD'), sheet);
    });
  }

  onErase() {
    SelectionStore.getSelecteds().forEach( (day)=> {
      this.sheets = this.sheets.delete(day.format('YYYY-MM-DD'),  null);
    });
  }

  onUpdateSheets(sheets) {
    this.sheets = this.sheets.merge(sheets);
  }

  sheetFor(d) {
    return this.sheets.get(d.day.format('YYYY-MM-DD'), []);
  }
}

export default alt.createStore(SheetStore, 'SheetStore');
