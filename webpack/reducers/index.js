import { combineReducers } from 'redux';

import calendarReducer from './calendarReducer';
import selectionReducer from './selectionReducer';
import sheetReducer from './sheetReducer';

export default combineReducers({
  calendarReducer,
  selectionReducer,
  sheetReducer
})
