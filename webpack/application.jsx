import React from 'react';
import { render } from 'react-dom';
import { Router, Route, Redirect } from 'react-router'
import { useBasename } from 'history';
import createBrowserHistory from 'history/lib/createBrowserHistory'
import moment from 'moment'

import App from './components/App';


let history = useBasename(createBrowserHistory)({ basename: '/dashboard'});
const container = document.getElementById('content');
const dayBase = container.attributes['data-daybase'].value

render((
  <Router history={history}>
    <Route path="/:year/:month" component={App} dayBase={dayBase} />
    <Redirect from="/*" to={moment().format('YYYY/MM')} />
  </Router>
), container);
