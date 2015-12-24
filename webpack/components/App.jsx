import React from 'react';
import Calendar from './Calendar';
import AltContainer from 'alt/AltContainer';
import CalendarStore from '../stores/CalendarStore';
import SelectionStore from '../stores/SelectionStore';
import CalendarActions from '../actions/CalendarActions';
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
        <Calendar />
    </AltContainer>
    )
  },

  componentDidMount: function() {
    CalendarActions.initializeCalendar(this.props.base);
  }
});
