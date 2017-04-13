import React from 'react';
import Form from './Form';
import Navbar from './Navbar';
import Weeks from './Weeks';
import WeekNames from './WeekNames';
import { connect } from 'react-redux';
import { fetchSheets } from '../reducers/sheetReducer';
import { onInitializecalendar } from '../reducers/calendarReducer';

class Calendar extends React.Component {
  render(){
    console.log(this.props);
    return (
      <div className="calendar-container">

      </div>
    );
  }

  componentDidMount() {
    this.initializeCalendar();
    this.props.fetchSheets();
  }

  componentDidUpdate() {
    this.initializeCalendar();
  }

  initializeCalendar() {
    this.props.initializeCalendar(this.props.date);
  }
}

const mapStateToProps = state => ({
    calendar: state.calendarReducer,
    selection: state.selectionReducer,
    sheets: state.sheetReducer,
});

const mapDispatchToProps = dispatch => ({
  fetchSheets() {
    dispatch(fetchSheets());
  },
  initializeCalendar() {
    dispatch(onInitializecalendar());
  }
});

export default connect(mapStateToProps, mapDispatchToProps)(Calendar);
