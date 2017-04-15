import React from 'react';
import Form from './Form';
import Navbar from './Navbar';
import Weeks from './Weeks';
import WeekNames from './WeekNames';
import { connect } from 'react-redux';
import {
  onInitializeCalendar,
  onPrev,
  onNext,
  onFetchSheets,
  sheetFor,
  onSelectWeek,
  onToggle,
  onSaveSheets,
  sumHours,
  isSelected,
  onSetTimeSheet,
  onErase,
  onDeselect,
} from '../reducers/calendarReducer';

class Calendar extends React.Component {
  componentWillMount() {
    this.props.onInitializeCalendar(this.props.date);
  }

  render(){
    return (
      <div className="calendar-container">
        <Navbar
          hasNext={this.props.calendar.hasNext}
          onPrev={this.props.onPrev}
          onNext={this.props.onNext}
          base={this.props.calendar.base}>
          {this.props.calendar.monthName}
        </Navbar>

        <table className='punches-table'>
          <WeekNames weekdays={this.props.calendar.weekdays} />
          <Weeks
            calendar={this.props.calendar}
            sheetFor={sheetFor}
            isSelected={isSelected}
            onSelectWeek={this.props.onSelectWeek}
            onToggle={this.props.onToggle}
          />
        </table>

        <p>Horas: {
          sumHours(
            this.props.calendar.weeks,
            this.props.calendar.sheets,
            this.props.calendar.sheetsSaveds
          )}
        </p>

        <Form
          calendar={this.props.calendar}
          onSetTimeSheet={this.props.onSetTimeSheet}
          onErase={this.props.onErase}
          onDeselect={this.props.onDeselect}
          onSaveSheets={this.props.onSaveSheets} />
      </div>
    );
  }

  componentDidMount() {
    this.props.onInitializeCalendar(this.props.date);
    this.props.onFetchSheets();
  }
}

const mapStateToProps = state => ({
    calendar: state.calendarReducer,
});

const mapDispatchToProps = (dispatch) => ({
   onInitializeCalendar: onInitializeCalendar(dispatch),
   onFetchSheets: onFetchSheets(dispatch),
   onSaveSheets: onSaveSheets(dispatch),
   onPrev: onPrev(dispatch),
   onNext: onNext(dispatch),
   onSelectWeek: onSelectWeek(dispatch),
   onToggle: onToggle(dispatch),
   onSetTimeSheet: onSetTimeSheet(dispatch),
   onErase: onErase(dispatch),
   onDeselect: onDeselect(dispatch),
});

export default connect(mapStateToProps, mapDispatchToProps)(Calendar);
