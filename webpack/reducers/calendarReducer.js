import moment from 'moment';
import Immutable from 'immutable';
import * as Calendar from '../utils/calendar';

const INITIALIZE = 'calendar/initializeCalendar';
const TOGGLE = 'calendar/toggle';
const DESELECT = 'calendar/deselect';
const SELECT = 'calendar/selectWeek';
const SET_TIME = 'calendar/setTimeSheet';
const SET_TIME_ON_SELECTEDS = 'calendar/setTimeSheetOnSelecteds';
const ERASE = 'calendar/erase';
const PREV = 'calendar/prev';
const NEXT = 'calendar/next';

const initialState = {
  base: null,
  start: false,
  hasNext: false,
  monthName: Immutable.List(),
  weeks: Immutable.List(),
  weekdays: moment.weekdaysMin(),
  Calendar: Calendar
};

export default (state = initialState, action) {
  switch (action.type) {
    case INITIALIZE:
      return {
        ...state,
        weekdays: action.weekdays
      }
    case TOGGLE:
      return {
        ...state,
        weekdays: action.weekdays
      }

    default:

  }
}

export const onInitializeCalendar = (date) => dispatch => {
  dispatch({
    type: INITIALIZE,
    weekdays: redefine(moment(date).weekdaysMin());
  });
}

export const onPrev = (history) => dispatch => {
  dispatch({
    type: PREV,
    base: redefine(Calendar.prev(this.base)),
  });
  history.push(this.base.format('YYYY/MM'));
}

export const onNext = (history) => dispatch => {
  dispatch({
    type: NEXT,
    Calendar: redefine(Calendar.next(this.base))
  });
  history.push(this.base.format('YYYY/MM'));
}

export const redefine = (base) => dispatch => {
  let range = Calendar.innerRange(this.base);
  dispatch({
    type: TOGGLE,
    base: base,
    hasNext: moment().diff(range[1], 'day') >= 1,
    start: Calendar.startDate(base),
    monthNames: Calendar.monthNames(range),
    weeks: Calendar.weeks(this.start, range)
  });
}

export const getDays = (weeks) => dispatch {
  dispatch({
    weeks: weeks.flatMap(function(w){ return w.days; });
  });
}
