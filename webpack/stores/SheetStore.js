import alt from '../alt';
import Immutable from 'immutable';
import SelectionStore from './SelectionStore';
import CalendarActions from '../actions/CalendarActions';
import ServerActions from '../actions/ServerActions';

const emptyMap = Immutable.Map();
const emptyList = Immutable.List();

function key(d) {
  return d.format('YYYY-MM-DD');
}

class SheetStore {
  constructor() {
    this.bindActions(CalendarActions);
    this.bindActions(ServerActions);
    this.exportPublicMethods({sheetFor: this.sheetFor.bind(this)});
    this.sheets = emptyMap;
    this.sheetsSaveds = emptyMap;
    this.deleteds = emptyList;
  }

  onSetTimeSheet(sheet) {
    SelectionStore.getSelecteds().forEach( (day)=> {
      this.sheets = this.sheets.set(key(day), sheet);
    });
  }

  onErase() {
    SelectionStore.getSelecteds().forEach( (day)=> {
      let _key = key(day)
      this.sheets = this.sheets.delete(_key);
      this.sheetsSaveds = this.sheetsSaveds.delete(_key);
      this.deleteds = this.deleteds.push(_key);
    });
  }

  onUpdateSheets(sheets) {
    this.sheetsSaveds = this.sheetsSaveds.merge(sheets);
  }

  sheetFor(d) {
    return this.sheets.get(key(d.day), null) ||
           this.sheetsSaveds.get(key(d.day), []);
  }
}

export default alt.createStore(SheetStore, 'SheetStore');
