import React from 'react';
import ReactDOM from 'react-dom';
import Routes from './router';
import { Provider } from 'react-redux';
import store from './store';

require("chartkick").use(require("highcharts"))

const container = document.getElementById('content')
export const dayBase = container.attributes['data-daybase'].value;

ReactDOM.render(
  <Provider store={store}>
    <Routes dayBase={dayBase}/>
  </Provider>,
  container
);
