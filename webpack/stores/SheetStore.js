import alt from '../alt';
import Immutable from 'immutable';
import SelectionStore from './SelectionStore';
import CalendarActions from '../actions/CalendarActions';
import ServerActions from '../actions/ServerActions';

const emptyMap = Immutable.Map();
const emptySet = Immutable.Set();

function key(d) {
  return d.format('YYYY-MM-DD');
}

class SheetStore {
  constructor() {
    this.sheetsSaveds = emptyMap;
    this.sheets = emptyMap;
    this.deleteds = emptySet;
    this.changes = this.sheets.size + this.deleteds.size;

    this.bindActions(CalendarActions);
    this.bindActions(ServerActions);
    this.exportPublicMethods({sheetFor: this.sheetFor.bind(this)});
  }

  onSetTimeSheet(sheet) {
    SelectionStore.getSelecteds().forEach( (day)=> {
      let _key = key(day);
      this.sheets = this.sheets.set(_key, sheet);
      this.deleteds = this.deleteds.delete(_key);
    });
    this.changes = this.sheets.size + this.deleteds.size;
  }

  onErase() {
    SelectionStore.getSelecteds().forEach( (day)=> {
      let _key = key(day);
      this.sheets = this.sheets.delete(_key);
      this.sheetsSaveds = this.sheetsSaveds.delete(_key);
      this.deleteds = this.deleteds.add(_key);
    });
    this.changes = this.sheets.size + this.deleteds.size;
  }

  onUpdateSheets(sheets) {
    this.sheetsSaveds = this.sheetsSaveds.merge(sheets);
  }

  onSaveSuccessSheets() {
    this.sheetsSaveds = this.sheetsSaveds.merge(this.sheets);
    this.sheets = emptyMap;
    this.deleteds = emptySet;
    this.changes = this.sheets.size + this.deleteds.size;
  }

  onSheetsSaveFailed() {
    alert('Ops...'); //IMPROVEME!
  }

  sheetFor(d) {
    return this.sheets.get(key(d.day), null) ||
           this.sheetsSaveds.get(key(d.day), []);
  }
}

export default alt.createStore(SheetStore, 'SheetStore');
