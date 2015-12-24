import React from 'react';
import Day from './Day';
import CalendarActions from '../actions/CalendarActions';

export default class extends React.Component {
  render() {
    return (
      <tr onDoubleClick={this.handleSelectWeek.bind(this)}>
        { this.props.week.days.map((d, ii)=> {
        return (<Day
          key={ii}
          inner={d.inner}
          sheet={ this.props.sheets[d.day.format()] || [] }
          day={d.day} />);
        })}
      </tr>
    );
  }

  handleSelectWeek(e) {
    CalendarActions.selectWeek(this.props.week);
  }
}
