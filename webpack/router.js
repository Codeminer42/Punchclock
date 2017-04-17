import React from 'react';
import { Route, Redirect } from 'react-router';
import createHistory from 'history/createBrowserHistory';
import {
  ConnectedRouter,
  routerMiddleware,
  routerReducer
} from 'react-router-redux';
import { current, constraintMonth } from './utils/calendar';
import App from './components/App';

export const history = createHistory({
  basename: '/dashboard'
});

export const middleware = routerMiddleware(history);
export const reducer = routerReducer;

function constraint(next, replace) {
  if(constraintMonth(next.params.year, next.params.month)){
    replace(null, { pathname: '/' });
  }
}

class Routes extends React.Component{
  render(){
    return(
      <ConnectedRouter history={history}>
        <div>
          <Route path="/:year/:month" component={App} onEnter={constraint} />
          <Redirect to={'/'+current().format('YYYY/MM')} />
        </div>
      </ConnectedRouter>
    );
  }
}

export default Routes;
