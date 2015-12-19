import React from 'react';
import CalendarStore from '../stores/CalendarStore';
import CalendarActions from '../actions/CalendarActions';
import Day from './Day';

export default class extends React.Component {
  constructor() {
    super();
    this.state = CalendarStore.getState();
  }

  render() {
    let weeks = this.state.weeks.map((week, i)=> {
      return (
        <tr key={i} >
          { week.days.map((d, ii)=> {
            return (<Day
              key={ii}
              inner={d.inner}
              day={d.day}
              selected={_.contains(this.state.selectedDays, d.day)}
              onSelect={this.handleSelect} />);
          })}
        </tr>
      );
    });

    let buttons = []
    if(!_.isEmpty(this.state.selectedDays)) {
      buttons = [
        <button key="register" >Registrar</button>,
        <button key="deselect" onClick={this.handleDeselect} >Descelecionar</button>,
        <button key="erase" >Apagar</button>
      ]
    }

    return (
      <div>
        <p>{ buttons }</p>
        <h2>{this.state.monthNames.join('/')}</h2>
        <table>
          <thead><tr>
            {this.state.weekdays.map((n, i)=> <th key={i}>{n}</th>)}
          </tr></thead>
          <tbody>{weeks}</tbody>
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

  handleSelect(day) {
    CalendarActions.select(day);
  }

  handleDeselect(e) {
    CalendarActions.deselect();
  }
};
