import React from 'react';
import cx from 'classnames/bind';
import Punches from './Punches';
import DayTitle from './DayTitle';

class Day extends React.Component {
  render() {
    let classNames = cx(
      `weekday-${this.props.day.day()}`,
      (this.props.inner ? 'inner' : 'out'),
      { today: this.props.today, selected: this.props.selected }
    );

    return(
      <td className={classNames} onClick={() => {this.handleToggle()}} >
        <DayTitle day={this.props.day} />
        <Punches sheet={this.props.sheet} />
      </td>
    );
  }

  handleToggle() {
    if(this.props.inner) {
      this.props.onToggle(this.props.day, this.props.selecteds);
    }
  }
}

export default Day;
