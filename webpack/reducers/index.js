import { combineReducers } from 'redux';
import calendarReducer from './calendarReducer';
import { reducer as routerReducer } from '../router';

export default combineReducers({
  calendarReducer,
  routerReducer
})
