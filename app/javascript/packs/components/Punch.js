import React from 'react';
import moment from 'moment';

const Punch = ({ punch }) => {
  const format = (timestamp) => {
    return moment(timestamp).format('HH:mm');
  };

  return(
    <li>{format(punch.from)} - {format(punch.to)}</li>
  );
};

export default Punch;
