import Immutable from 'immutable';
import moment from 'moment';
import {
  INITIALIZE,
  SET_TIME_SHEET,
  ERASE,
  TOGGLE,
  SELECT_WEEK,
  DESELECT,
  PREV,
  NEXT
} from '../utils/constants';

const initial = Immutable.Set();

const initialState = {
  selected: initial,
};

export default (state = initialState, action) => {
  switch (action.type) {
    case INITIALIZE:
    case SET_TIME_SHEET:
    case ERASE:
    case TOGGLE:
    case SELECT_WEEK:
    case DESELECT:
    case PREV:
    case NEXT:
      return {
        ...state,
        selected: action.selecteds,
      };
    default:
      return state;
  }
}

export const isSelected = (day) => {
  return this.selecteds.has(key(day));
};

export const onInitializecalendar = () => dispatch => {
  dispatch({
    type: INITIALIZE,
    selecteds: initial,
  });
};

export const onSetTimeSheet = (sheet) => dispatch => {
  this.waitFor([SheetStore]);
  dispatch({
    type: SET_TIME_SHEET,
    selecteds: initial,
  });
};

export const onErase = (sheet) => dispatch => {
  this.waitFor([SheetStore]);
  dispatch({
    type: ERASE,
    selecteds: initial,
  });
};

export const onToggle = (day, selecteds) => dispatch => {
  let newSelecteds = null;
  if(isSelected(day)) {
    newSelecteds = selecteds.delete(key(day));
  } else {
    newSelecteds = selecteds.add(key(day));
  }

  dispatch({
    type: TOGGLE,
    selecteds: newSelecteds,
  });
};

export const onSelectWeek = (week, selecteds) => dispatch => {
  let newSelecteds = null;
  week.days.forEach( (d) => {
    let { day, inner } = d;
    if(day.day() != 0 && day.day() != 6 && inner) {
      newSelecteds = selecteds.add(key(day));
    }
  });

  dispatch({
    type: SELECT_WEEK,
    selecteds: newSelecteds,
  });
};

export const onDeselect = () => dispatch => {
  dispatch({
    type: DESELECT,
    selecteds: initial,
  });
};

export const onPrev = () => dispatch => {
  dispatch({
    type: PREV,
    selecteds: initial,
  });
};

export const onNext = () => dispatch => {
  dispatch({
    type: NEXT,
    selecteds: initial,
  });
};
