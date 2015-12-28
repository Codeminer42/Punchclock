import React from 'react';
import { render } from 'react-dom';
import { Router, Route, Redirect } from 'react-router'
import { createHistory, useBasename } from 'history';
import { current, constraintMonth } from 'utils/calendar';

import App from './components/App';


const container = document.getElementById('content');
const dayBase = container.attributes['data-daybase'].value

let history = useBasename(createHistory)({ basename: '/dashboard'});

function constraint(next, replace) {
  if(constraintMonth(next.params.year, next.params.month))
    replace(null, { pathname: '/' });
}

render((
  <Router history={history}>
    <Route path="/:year/:month" component={App} onEnter={constraint} dayBase={dayBase} />
    <Redirect from="/*" to={current().format('YYYY/MM')} />
  </Router>
), container);
