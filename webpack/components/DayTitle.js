import React from 'react';
export default ({day}) =>
  <h3>
    {day.format('DD')}
    { day.date() == 1 ? `/${day.format('MMM')}` : '' }
  </h3>


