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
  onFetchHolidays,
  onFetchCurrentAllocation,
} from '../reducers/calendarReducer';

class Calendar extends React.Component {
  componentWillMount() {
    this.props.onInitializeCalendar(this.props.date);
  }

  render(){
    const {
      onPrev,
      onNext,
      onSelectWeek,
      onToggle,
      onSetTimeSheet,
      onErase,
      onDeselect,
      onSaveSheets,
      calendar
    } = this.props;

    return (
      <>
        <div className="container">
          <Form
            calendar={calendar}
            onSetTimeSheet={onSetTimeSheet}
            onErase={onErase}
            onDeselect={onDeselect}
            onSaveSheets={onSaveSheets}
          />
        </div>
        <div className="d-flex justify-content-center container">
          <div className="calendar-container">
            <Navbar
              hasNext={calendar.hasNext}
              onPrev={onPrev}
              onNext={onNext}
              base={calendar.base}
              totalHours={sumHours(
                calendar.weeks,
                calendar.sheets,
                calendar.sheetsSaveds,
                calendar.changes
              )}
            >
              {calendar.monthName}
            </Navbar>

            <table className='punches-table'>
              <WeekNames weekdays={calendar.weekdays} />
              <Weeks
                calendar={calendar}
                sheetFor={sheetFor}
                isSelected={isSelected}
                onSelectWeek={onSelectWeek}
                onToggle={onToggle}
              />
            </table>
          </div>
        </div>
      </>
    );
  }

  componentDidMount() {
    this.props.onInitializeCalendar(this.props.date);
    this.props.onFetchSheets();
    this.props.onFetchCurrentAllocation();
    this.props.onFetchHolidays();
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
  onFetchHolidays: onFetchHolidays(dispatch),
  onFetchCurrentAllocation: onFetchCurrentAllocation(dispatch),
});

export default connect(mapStateToProps, mapDispatchToProps)(Calendar);
