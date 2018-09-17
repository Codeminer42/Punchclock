import Moment from 'moment';
import Immutable from 'immutable';
import * as Calendar from '../utils/calendar';
import { push } from 'react-router-redux';
import { fetchSheets, saveSheets } from '../api';

//calendar actions
export const INITIALIZE = 'calendar/initializeCalendar';
export const TOGGLE = 'calendar/toggle';
export const DESELECT = 'calendar/deselect';
export const SELECT_WEEK = 'calendar/selectWeek';
export const SET_TIME_SHEET = 'calendar/setTimeSheet';
export const SET_TIME_ON_SELECTEDS = 'calendar/setTimeSheetOnSelecteds';
export const ERASE = 'calendar/erase';
export const PREV = 'calendar/prev';
export const NEXT = 'calendar/next';

//server actions
export const UPDATE_SHEETS_SUCCESS = 'server/updateSheetsSucceded';
export const UPDATE_SHEETS_FAIL = 'server/updateSheetsFailed';
export const SAVE_SHEET_SUCCESS = 'server/saveSheetsSucceded';
export const SHEETS_SAVE_FAIL = 'server/saveSheetsFailed';

//setups
const emptyMap = Immutable.Map();
const emptySet = Immutable.Set();
const Punch = Immutable.Record({
  from: undefined,
  to: undefined,
  project_id: undefined,
  delta: 0,
});

const initialState = {
  base: null,
  start: false,
  hasNext: false,
  monthName: Immutable.List(),
  weeks: Immutable.List(),
  weekdays: Moment.weekdaysMin(),
  selecteds: emptySet,
  sheetsSaveds: emptyMap,
  sheets: emptyMap,
  deleteds: emptySet,
  changes: 0,
};

export default (state = initialState, action) => {
  switch (action.type) {
    case INITIALIZE:
      return {
        ...state,
        base: action.payload.base,
        start: action.payload.start,
        hasNext: action.payload.hasNext,
        monthName: action.payload.monthNames,
        weeks: action.payload.weeks,
      };
    case PREV:
      return {
        ...state,
        base: action.payload.base,
        start: action.payload.start,
        hasNext: action.payload.hasNext,
        monthName: action.payload.monthNames,
        weeks: action.payload.weeks,
        selecteds: emptySet,
      };
    case NEXT:
      return {
        ...state,
        base: action.payload.base,
        start: action.payload.start,
        hasNext: action.payload.hasNext,
        monthName: action.payload.monthNames,
        weeks: action.payload.weeks,
        selecteds: emptySet,
      };
    case SET_TIME_SHEET:
      return {
        ...state,
        selecteds: action.sheetsPayload.selecteds,
        sheets: action.sheetsPayload.sheets,
        deleteds: action.sheetsPayload.deleteds,
        changes: action.sheetsPayload.changes,
      };
    case ERASE:
      return {
        ...state,
        selecteds: action.sheetsPayload.selecteds,
        sheetsSaveds: action.sheetsPayload.sheetsSaveds,
        sheets: action.sheetsPayload.sheets,
        deleteds: action.sheetsPayload.deleteds,
        changes: action.sheetsPayload.changes,
      };
    case TOGGLE:
      return {
        ...state,
        selecteds: action.sheetsPayload.selecteds,
      };
    case SELECT_WEEK:
      return {
        ...state,
        selecteds: action.sheetsPayload.selecteds,
      };
    case DESELECT:
      return {
        ...state,
        selecteds: action.sheetsPayload.selecteds,
      };
    case UPDATE_SHEETS_SUCCESS:
      return {
        ...state,
        sheetsSaveds: action.sheetsPayload.sheetsSaveds,
      };
    case UPDATE_SHEETS_FAIL:
      return {
        ...state,
      };
    case SAVE_SHEET_SUCCESS:
      return {
        ...state,
        sheetsSaveds: action.sheetsPayload.sheetsSaveds,
        sheets: action.sheetsPayload.sheets,
        deleteds: action.sheetsPayload.deleteds,
        changes: action.sheetsPayload.changes,
      };
    case SHEETS_SAVE_FAIL:
      return {
        ...state,
      };
    default:
      return state;
  }
}

//export functions
export const getDays = (weeks) => {
  return weeks.flatMap(function(w){ return w.days; });
};

export const sheetFor = (d, sheets, sheetsSaveds) => {
  let dayString = d.day.format('YYYY-MM-DD');
  return (sheets.get(dayString, null) || sheetsSaveds.get(dayString, []));
}

export const isSelected = (selecteds, day) => {
  if(selecteds.size > 0){
    return selecteds.has(day);
  }
  return false;
};

//local functions
const redefine = (base) => {
  let range = Calendar.innerRange(base);
  return({
    base: base,
    start: Calendar.startDate(base),
    hasNext: (Moment().diff(range[1], 'day') >= 1),
    monthNames: Calendar.monthNames(range),
    weeks: Calendar.weeks(Calendar.startDate(base), range),
  });
};

const createPunch = (dayString, sheet) => {
  return sheet.map((p)=> {
    let from = Moment.utc(`${dayString} ${p.from}`);
    let to = Moment.utc(`${dayString} ${p.to}`);
    return new Punch({
      from: from,
      to: to,
      project_id: p.project_id,
      delta: Moment.duration(to.diff(from)).asHours()
    });
  });
};

export const sumHours = (weeks, sheets, sheetsSaveds) => {
  return getDays(weeks).reduce( (sum, d)=> {
    if(d.inner) {
      let _sheets = sheetFor(d, sheets, sheetsSaveds);
      return sum + _sheets.reduce( ((s, p)=> s + p.delta), 0);
    } else return sum;
  }, 0);
}

//actions
export const onInitializeCalendar = (dispatch) => (date = '') => {
  dispatch({
    type: INITIALIZE,
    payload: redefine(Moment(date)),
  });
};

export const onPrev = (dispatch) => (base) => {
  dispatch({
    type: PREV,
    payload: redefine(Calendar.prev(base)),
  });
  dispatch(push('/'+Calendar.prev(base).format('YYYY/MM')));
};

export const onNext = (dispatch) => (base) => {
  dispatch({
    type: NEXT,
    payload: redefine(Calendar.next(base)),
  });
  dispatch(push('/'+Calendar.next(base).format('YYYY/MM')));
};

export const onSetTimeSheet = (dispatch) => (sheet, selecteds, sheets, deleteds) => {
  let newSheets = sheets;
  let newDeleteds = deleteds;

  selecteds.forEach( (day)=> {
    let dayString = day.format('YYYY-MM-DD');
    let punch = createPunch(dayString, sheet);
    newSheets = newSheets.set(dayString, Immutable.fromJS(punch));
    newDeleteds = deleteds.delete(dayString);
  });

  dispatch({
    type: SET_TIME_SHEET,
    sheetsPayload:{
      selecteds: emptySet,
      sheets: newSheets,
      deleteds: newDeleteds,
      changes: newSheets.size + newDeleteds.size,
    },
  });
};

export const onErase = (dispatch) => (selecteds, sheets, deleteds, sheetsSaveds) => {
  let newSheets = sheets;
  let newDeleteds = deleteds;
  let newSheetsSaveds = sheetsSaveds;

  selecteds.forEach((day)=> {
    let dayString = day.format('YYYY-MM-DD');
    newSheets = newSheets.delete(dayString);
    newSheetsSaveds = newSheetsSaveds.delete(dayString);
    newDeleteds = newDeleteds.add(dayString);
  });

  dispatch({
    type: ERASE,
    sheetsPayload:{
      selecteds: emptySet,
      sheetsSaveds: newSheetsSaveds,
      sheets: newSheets,
      deleteds: newDeleteds,
      changes: newSheets.size + newDeleteds.size,
    },
  });
};

export const onToggle = (dispatch) => (day, selecteds) => {
  let newSelecteds = selecteds;
  if(isSelected(selecteds, day)) {
    newSelecteds = newSelecteds.delete(day);
  } else {
    newSelecteds = newSelecteds.add(day);
  }

  dispatch({
    type: TOGGLE,
    sheetsPayload:{
      selecteds: newSelecteds,
    },
  });
};

export const onSelectWeek = (dispatch) => (week, selecteds) => {
  let newSelecteds = selecteds;
  week.days.forEach( (d) => {
    let { day, inner } = d;
    if(day.day() != 0 && day.day() != 6 && inner) {
      newSelecteds = newSelecteds.add(day);
    }
  });

  dispatch({
    type: SELECT_WEEK,
    sheetsPayload: {
      selecteds: newSelecteds
    },
  });
};

export const onDeselect = (dispatch) => () => {
  dispatch({
    type: DESELECT,
    sheetsPayload: {
      selecteds: emptySet
    },
  });
};

export const onFetchSheets = (dispatch) => () => {
  fetchSheets().then((response) =>
    dispatch({
      type: UPDATE_SHEETS_SUCCESS,
      sheetsPayload:{
        sheetsSaveds: Immutable.Map(response.body),
      },
    })
  )
  .catch((response) => {
    dispatch({
      type: UPDATE_SHEETS_FAIL,
    })
  });
};

export const onSaveSheets = (dispatch) => (deleteds, sheets, sheetsSaveds) => {
  saveSheets(deleteds, sheets).then((response) =>
    dispatch({
      type: SAVE_SHEET_SUCCESS,
      sheetsPayload:{
        sheetsSaveds: sheetsSaveds.merge(sheets),
        sheets: emptyMap,
        deleteds: emptySet,
        changes: 0,
      },
    })
  )
  .catch((response) => {
    alert('Ops...');
    dispatch({
      type: SHEETS_SAVE_FAIL
    });
  });
};
