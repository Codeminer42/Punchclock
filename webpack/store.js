import { createStore, applyMiddleware } from 'redux';
import { logger } from 'redux-logger';
import thunk from 'redux-thunk';
import reducer from './reducers';

const middlewares = applyMiddleware (
  thunk,
  logger
);

export default createStore (reducers, middlewares);
