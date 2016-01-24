import React from 'react';
import moment from 'moment';

function format(timestamp) {
  return moment(timestamp).format('HH:mm');
}

export default ({punch}) =>
  <li>{format(punch.get('from'))} - {format(punch.get('to'))}</li>
