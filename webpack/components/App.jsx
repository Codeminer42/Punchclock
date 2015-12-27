import React from 'react';
import Calendar from './Calendar';
import AltContainer from 'alt/AltContainer';
import CalendarStore from '../stores/CalendarStore';
import SelectionStore from '../stores/SelectionStore';
import CalendarActions from '../actions/CalendarActions';
import ServerActions from '../actions/ServerActions';
import SheetStore from '../stores/SheetStore';

export default React.createClass({
  render: function() {
    return (
      <AltContainer
        stores={
          { Calendar: CalendarStore,
            Selection: SelectionStore,
            Sheets: SheetStore } }
        actions={
          { actions: CalendarActions,
            serverActions: ServerActions } } >
        <Calendar sheetFor={SheetStore.sheetFor} />
    </AltContainer>
    )
  },

  componentDidMount: function() {
    this.initializeCalendar();
    ServerActions.fetchSheets();
  },

  componentDidUpdate: function() {
    this.initializeCalendar();
  },

  initializeCalendar: function() {
    CalendarActions.initializeCalendar(
      `${this.props.params.year}-${this.props.params.month}-${this.props.route.dayBase}`
    );
  }
});
