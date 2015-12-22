import React from 'react';
import CalendarStore from '../stores/CalendarStore';
import SheetStore from '../stores/SheetStore';
import CalendarActions from '../actions/CalendarActions';
import Day from './Day';
import Form from './Form';

function getStateFromStore() {
  return {
    calendar: CalendarStore.getState(),
    sheets: SheetStore.getState().sheets
  };
}

export default class extends React.Component {
  constructor() {
    super();
    this.state = getStateFromStore();
  }

  weeksRender() {
    return this.state.calendar.weeks.map((week, i)=> {
      return (
        <tr key={i} >
          { week.days.map((d, ii)=> {
            return (<Day
              key={ii}
              inner={d.inner}
              sheet={ this.state.sheets[d.day.format()] || [] }
              day={d.day} />);
          })}
        </tr>
      );
    });
  }

  render() {
    return (
      <div>
        <Form />
        <h2>{this.state.calendar.monthNames.join('/')}</h2>
        <table>
          <thead><tr>
            {this.state.calendar.weekdays.map((n, i)=> <th key={i}>{n}</th>)}
          </tr></thead>
          <tbody>{this.weeksRender()}</tbody>
        </table>
      </div>
    );
  }

  componentDidMount() {
    CalendarStore.listen(this.onChange.bind(this));
    SheetStore.listen(this.onChange.bind(this));

    CalendarActions.initializeCalendar(this.props.base);
  }

  componentWillUnmount() {
    CalendarStore.unlisten(this.onChange.bind(this));
    SheetStore.unlisten(this.onChange.bind(this));
  }

  onChange() {
    this.setState(getStateFromStore());
  }

  handleDeselect(e) {
    e.preventDefault();
    CalendarActions.deselect();
  }
};
