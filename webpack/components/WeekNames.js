import React from 'react';

const WeekNames = ({ weekdays }) => {
  return (
    <thead>
      <tr>
        {weekdays.map((n, i)=> <th key={i}>{n}</th>)}
      </tr>
    </thead>
  );
};

export default WeekNames;
