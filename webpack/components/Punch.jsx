import React from 'react';
import moment from 'moment';

function format(timestamp) {
  return moment(timestamp).format('HH:mm');
}

export default class extends React.Component {
  render() {
    let p = this.props.punch;
    return <li>{format(p.get('from'))} - {format(p.get('to'))}</li>
  }
};
