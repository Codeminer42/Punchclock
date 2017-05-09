import { createStore, applyMiddleware, compose } from 'redux';
import { logger } from 'redux-logger';
import thunk from 'redux-thunk';
import reducers from './reducers';
import { middleware as routerMiddleware } from './router';

const composeEnhancers = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose;
const middlewares = applyMiddleware (
  thunk,
  logger,
  routerMiddleware,
);

export default createStore (
  reducers,
  composeEnhancers(middlewares),
);
