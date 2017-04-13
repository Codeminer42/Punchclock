import Immutable from 'immutable';
import moment from 'moment';
import getDays from './calendarReducer';
import { fetch, save } from '../api';
import {
SET_TIME_SHEET,
ERASE,
UPDATE_SHEETS,
SHEETS_FAILED,
SAVE_SUCCESS_SHEET,
SHEETS_SAVE_FAILED,
PREV,
NEXT,
} from '../utils/constants';

const emptyMap = Immutable.Map();
const emptySet = Immutable.Set();
const Punch = Immutable.Record({
  from: undefined,
  to: undefined,
  project_id: undefined,
  delta: 0,
});

const initialState = {
  sheetsSaveds: emptyMap,
  sheets: emptyMap,
  deleteds: emptySet,
  changes: 0,
  sum: 0,
};

export default (state = initialState, action) => {
  switch (action.type) {
    case SET_TIME_SHEET:
      return {
        ...state,
        sheets: action.payload.sheets,
        deleteds: action.payload.deleteds,
        changes: action.payload.changes,
        sum: action.payload.sum,
      };
    case ERASE:
      return {
        ...state,
        sheetsSaveds: action.payload.sheetsSaveds,
        sheets: action.payload.sheets,
        deleteds: action.payload.deleteds,
        changes: action.payload.changes,
        sum: action.payload.sum,
      };
    case UPDATE_SHEETS:
      return {
        ...state,
        sheetsSaveds: action.payload.sheetsSaveds,
        sum: action.payload.sum,
      };
    case SHEETS_FAILED:
      return {
        ...state,
      };
    case SAVE_SUCCESS_SHEET:
      return {
        ...state,
        sheetsSaveds: action.payload.sheetsSaveds,
        sheets: action.payload.sheets,
        deleteds: action.payload.deleteds,
        changes: action.payload.changes,
      };
    case SHEETS_SAVE_FAILED:
      return {
        ...state,
      };
    case PREV:
      return {
        ...state,
        sum: action.payload.sum,
      };
    case NEXT:
      return {
        ...state,
        sum: action.payload.sum,
      };

    default:
      return state;
  }
}

const createPunch = (dayString, sheet) => {
  return sheet.map( (p)=> {
    let from = moment.utc(`${dayString} ${p.from}`);
    let to = moment.utc(`${dayString} ${p.to}`);
    return new Punch({
      from: from,
      to: to,
      project_id: p.project_id,
      delta: to.diff(from, 'hour')
    });
  });
};

export const sumHours = (weeks) => {
  return getDays(weeks).reduce( (sum, d)=> {
    if(d.inner) {
      let _sheets = sheetFor(d);
      return sum + _sheets.reduce( ((s, p)=> s + p.get('delta')), 0);
    } else return sum;
  }, 0);
}

export const sheetFor = (d) => {
  let dayString = d.day.format('YYYY-MM-DD')
  return this.sheets.get(dayString, null) ||
         this.sheetsSaveds.get(dayString, []);
}

export const onSetTimeSheet = (selecteds, sheets, deleteds, week) => dispatch => {
  let newSheets = emptyMap;
  let newDeleteds = emptyMap;

  selecteds.forEach( (day)=> {
    let punch = createPunch(day, sheet);
    newSheets = sheets.set(day, Immutable.fromJS(punch));
    newDeleteds = deleteds.delete(day);
  });
  dispatch({
    type: SET_TIME_SHEET,
    payload:{
      sheets: newSheets,
      deleteds: newDeleteds,
      changes: newSheets.size + newDeleteds.size,
      sum: sumHours(week),
    },
  });
};

export const onErase = (selecteds, sheets, deleteds, sheetsSaveds, week) => dispatch => {
  let newSheets = emptyMap;
  let newDeleteds = emptyMap;
  let newSheetsSaveds = emptySet;

  selecteds.forEach( (day)=> {
    newSheets = sheets.delete(day);
    newSheetsSaveds = sheetsSaveds.delete(day);
    newDeleteds = deleteds.add(day);
  });
  dispatch({
    type: ERASE,
    payload:{
      sheetsSaveds: newSheetsSaveds,
      sheets: newSheets,
      deleteds: newDeleteds,
      changes: newSheets.size + newDeleteds.size,
      sum: sumHours(week),
    },
  });
};

export const fetchSheets = () => dispatch => {
  fetch().then((response) =>
    dispatch({
      type: UPDATE_SHEETS,
      payload:{
        sheetsSaveds: 'response.body',
        //sum: sumHours(week),
      },
    })
  )
  .catch((response) => {
    dispatch({
      type: SHEETS_FAILED,
    })
  });
};

export const onSaveSuccessSheets = (sheets, sheetsSaveds) => dispatch => {
  dispatch({
    type: SAVE_SUCCESS_SHEET,
    payload:{
      sheetsSaveds: sheetsSaveds.merge(sheets),
      sheets: emptyMap,
      deleteds: emptySet,
      changes: 0,
    },
  });
};

export const onSheetsSaveFailed = (sheets, sheetsSaveds) => dispatch => {
  alert('Ops...');
  dispatch({
    type: SHEETS_SAVE_FAILED
  });
};

export const onPrev = (week) => dispatch => {
  dispatch({
    type: PREV,
    payload:{
      sum: sumHours(week),
    },
  });
};

export const onNext = (week) => dispatch => {
  dispatch({
    type: NEXT,
    payload:{
      sum: sumHours(week),
    },
  });
};
