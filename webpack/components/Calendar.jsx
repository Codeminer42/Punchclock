import React from 'react';
import CalendarStore from '../stores/CalendarStore';
import SelectionStore from '../stores/SelectionStore';
import CalendarActions from '../actions/CalendarActions';
import Day from './Day';
import Form from './Form';

export default class extends React.Component {
  constructor() {
    super();
    this.state = CalendarStore.getState();
  }

  weeksRender() {
    return this.state.weeks.map((week, i)=> {
      return (
        <tr key={i} >
          { week.days.map((d, ii)=> {
            return (<Day key={ii} inner={d.inner} day={d.day} />);
          })}
        </tr>
      );
    });
  }

  render() {
    return (
      <div>
        <Form />
        <h2>{this.state.monthNames.join('/')}</h2>
        <table>
          <thead><tr>
            {this.state.weekdays.map((n, i)=> <th key={i}>{n}</th>)}
          </tr></thead>
          <tbody>{this.weeksRender()}</tbody>
        </table>
      </div>
    );
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

  handleDeselect(e) {
    e.preventDefault();
    CalendarActions.deselect();
  }
};
