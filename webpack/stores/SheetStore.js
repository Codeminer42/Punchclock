import alt from '../alt';
import Immutable from 'immutable';
import moment from 'moment';
import SelectionStore from './SelectionStore';
import CalendarStore from './CalendarStore';
import CalendarActions from '../actions/CalendarActions';
import ServerActions from '../actions/ServerActions';

const emptyMap = Immutable.Map();
const emptySet = Immutable.Set();
const Punch = Immutable.Record({
  from: undefined,
  to: undefined,
  project_id: undefined,
  delta: 0
});

function createPunch(dayString, sheet) {
  return sheet.map( (p)=> {
    let from = moment(`${dayString} ${p.from}`);
    let to = moment(`${dayString} ${p.to}`);
    return new Punch({
      from: from,
      to: to,
      project_id: p.project_id,
      delta: to.diff(from, 'hour')
    });
  });
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
    SelectionStore.getState().selecteds.forEach( (day)=> {
      let punch = createPunch(day, sheet);
      this.sheets = this.sheets.set(day, Immutable.fromJS(punch));
      this.deleteds = this.deleteds.delete(day);
    });
    this.changes = this.sheets.size + this.deleteds.size;
    this.sum = this.sumHours();
  }

  onErase() {
    SelectionStore.getState().selecteds.forEach( (day)=> {
      this.sheets = this.sheets.delete(day);
      this.sheetsSaveds = this.sheetsSaveds.delete(day);
      this.deleteds = this.deleteds.add(day);
    });
    this.changes = this.sheets.size + this.deleteds.size;
    this.sum = this.sumHours();
  }

  onUpdateSheets(sheets) {
    this.sheetsSaveds = this.sheetsSaveds.merge(sheets);
    this.sum = this.sumHours();
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

  onPrev() {
    this.onNavigate();
  }

  onNext() {
    this.onNavigate();
  }

  onNavigate() {
    this.waitFor([CalendarStore]);
    this.sum = this.sumHours();
  }

  sheetFor(d) {
    let dayString = d.day.format('YYYY-MM-DD')
    return this.sheets.get(dayString, null) ||
           this.sheetsSaveds.get(dayString, []);
  }

  sumHours() {
    return CalendarStore.getDays().reduce( (sum, d)=> {
      if(d.inner) {
        let _sheets = this.sheetFor(d);
        return sum + _sheets.reduce( ((s, p)=> s + p.get('delta')), 0);
      } else return sum;
    }, 0);
  }
}

export default alt.createStore(SheetStore, 'SheetStore');
