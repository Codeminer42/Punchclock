import React from 'react';
import Calendar from './Calendar';

const App = ({ dayBase, year, month }) => {
  return (
    <Calendar
      date={`${year}-${month}-${dayBase}`}
    />
  );
};

export default App;
