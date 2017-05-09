import React from 'react';

const DayTitle = ({ day }) => {
  return (
    <h3>
      { day.format('DD') }
      { day.date() == 1 ? `/${day.format('MMM')}` : '' }
    </h3>
  );
};

export default DayTitle;
