import React from 'react';
import CalendarStore from '../stores/CalendarStore';
import CalendarActions from '../actions/CalendarActions';

export default class extends React.Component {
  constructor() {
    super();
    this.state = CalendarStore.getState();
  }

  componentDidMount() {
    CalendarStore.listen(this.onChange.bind(this));
    CalendarActions.initializeCalendar(this.props.base);
  }

  componentWillUnmount() {
    CalendarStore.unlisten(this.onChange.bind(this));
  }

  onChange(state) {
    this.setState(state);
  }

  render() {
    let weeks = this.state.weeks.map((week, i)=> {
      return (
        <tr key={i} >
          { week.days.map((d, ii)=> {
          return (<td key={ii} className={d.inner ? 'inner' : 'out'}>
            {d.day.format('DD')}
          </td>);
          })}
        </tr>
      );
    });

    return (
      <div>
        <h2>{this.state.monthNames.join(' - ')}</h2>
        <table>
          <thead><tr>
              {this.state.weekdays.map((n, i)=> <th key={i}>{n}</th>)}
          </tr></thead>
          <tbody>{weeks}</tbody>
        </table>
      </div>
    );
  }
};
