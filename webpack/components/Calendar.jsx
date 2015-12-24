import React from 'react';
import CalendarStore from '../stores/CalendarStore';
import SheetStore from '../stores/SheetStore';
import CalendarActions from '../actions/CalendarActions';
import Form from './Form';
import Navbar from './Navbar';
import Week from './Week';

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

  render() {
    return (
      <div className="calendar-container">
        <Navbar
          monthNames={this.state.calendar.monthNames}
          hasNext={this.state.calendar.hasNext} />
        <table className='punches-table'>
          <thead><tr>
            {this.state.calendar.weekdays.map((n, i)=> <th key={i}>{n}</th>)}
          </tr></thead>
          <tbody>
            {this.state.calendar.weeks.map((week, i)=> {
              return (
                <Week
                  key={i}
                  week={week}
                  sheets={this.state.sheets} />
              );
            })}
          </tbody>
        </table>
        <Form />
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
};
