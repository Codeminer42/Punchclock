import React from 'react';

const Week = ({ onSelectWeek, week, selecteds, children }) => {
  return (
    <tr onDoubleClick={() => onSelectWeek(week, selecteds)}>
      { children }
    </tr>
  );
};

export default Week;
