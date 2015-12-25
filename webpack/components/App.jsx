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
        actions={ { actions: CalendarActions } } >
        <Calendar sheetFor={SheetStore.sheetFor} />
    </AltContainer>
    )
  },

  componentDidMount: function() {
    CalendarActions.initializeCalendar(this.props.base);
    ServerActions.fetchSheets();
  }
});
