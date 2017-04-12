import moment from 'moment';
import Immutable from 'immutable';
import * as calendar from '../utils/calendar';
import {
  INITIALIZE,
  NEXT,
  PREV
} from '../utils/constants';

const initialState = {
  base: null,
  start: false,
  hasNext: false,
  monthName: Immutable.List(),
  weeks: Immutable.List(),
  weekdays: moment.weekdaysMin(),
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
      };
    case NEXT:
      return {
        ...state,
        base: action.payload.base,
        start: action.payload.start,
        hasNext: action.payload.hasNext,
        monthName: action.payload.monthNames,
        weeks: action.payload.weeks,
      };
    default:
      return state;
  }
}

export const redefine = (base) => {
  let range = calendar.innerRange(this.base);
  return({
    base: base,
    start: calendar.startDate(base),
    hasNext: (moment().diff(range[1], 'day') >= 1),
    monthNames: calendar.monthNames(range),
    weeks: calendar.weeks(this.start, range),
  });
};

export const onInitializecalendar = (date) => dispatch => {
  dispatch({
    type: INITIALIZE,
    payload: redefine(moment(date).weekdaysMin()),
  });
};

export const onPrev = (history, base) => dispatch => {
  dispatch({
    type: PREV,
    payload: redefine(calendar.prev(base)),
  });
  history.push(base.format('YYYY/MM'));
};

export const onNext = (history, base) => dispatch => {
  dispatch({
    type: NEXT,
    payload: redefine(calendar.next(base)),
  });
  history.push(base.format('YYYY/MM'));
};

export const getDays = (weeks) => {
    return weeks.flatMap(function(w){ return w.days; });
};
