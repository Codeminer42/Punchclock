import React from 'react';
import Form from './Form';
import Navbar from './Navbar';
import Weeks from './Weeks';
import WeekNames from './WeekNames';

export default function Calendar({...props}) {
  return (
    <div className="calendar-container">
      <Navbar hasNext={props.Calendar.hasNext} actions={props.actions}>
        {props.Calendar.monthNames}
      </Navbar>

      <table className='punches-table'>
        <WeekNames weekdays={props.Calendar.weekdays} />
        <Weeks {...props} />
      </table>

      <p>Horas: { props.Sheets.sum }</p>

      <Form
        selecteds={props.Selection.selecteds}
        changes={props.Sheets.changes}
        actions={props.actions}
        save={props.serverActions.saveSheets} />
    </div>
  );
};
