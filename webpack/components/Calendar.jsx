import React from 'react';
import CalendarWeek from './CalendarWeek';
import Calendar from '../lib/calendar';

export default  React.createClass({
  render: function() {
    let calendar = new Calendar(this.props.base);
    return (
      <div>
        <h2>{calendar.monthNames.join(' - ')}</h2>
        <table>
          <thead><tr>
            {calendar.weekdays.map( (n, i)=> <th key={i}>{n}</th>)}
          </tr></thead>
          <tbody>
          { calendar.weeks.map( (week, i)=> {
              return <CalendarWeek
                key={i}
                calendarRange={calendar.range}
                week={week} />}) }
          </tbody>
        </table>
      </div>
    )
  }
});
