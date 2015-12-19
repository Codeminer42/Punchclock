import React from 'react';
import CalendarWeek from './CalendarWeek';
import moment from 'moment';

export default  React.createClass({
  render: function() {
    moment.locale('pt');

    let base = moment(this.props.base);
    let start = base.startOf('week');
    let range = [base.clone().add(1, 'day'),
                 base.clone().add(1, 'month').set('date', base.date())];
    let monthName = base.format('MMMM');
    let weeks = [];

    for(let i = 0; i < 5; i++) {
      weeks.push(
        <CalendarWeek
          key={i}
          calendarRange={range}
          start={start.clone().add(i, 'week')} />
      )
    }

    return (
      <div>
        <h2>{monthName}</h2>
        <table>
          <thead>
            <tr>
              {moment.weekdays().map( (n, i)=> <th key={i}>{n}</th>)}
            </tr>
          </thead>
          <tbody>{weeks}</tbody>
        </table>
      </div>
    )
  }
});
