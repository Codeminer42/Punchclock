import React from 'react';
import cx from 'classnames/bind';
import Punches from './Punches';
import DayTitle from './DayTitle';

export default class Day extends React.Component {
  render() {
    let classNames = cx(
      `weekday-${this.props.day.day()}`,
      (this.props.inner ? 'inner' : 'out'),
      { today: this.props.today, selected: this.props.selected }
    );

    return <td className={classNames} onClick={this.handleClick.bind(this)} >
      <DayTitle day={this.props.day} />
      <Punches sheet={this.props.sheet} />
    </td>
  }

  handleClick(e) {
    e.preventDefault();
    if(this.props.inner) { this.props.actions.toggle(this.props.day); }
  }
}
