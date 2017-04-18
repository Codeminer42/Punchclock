import React from 'react';
import cx from 'classnames/bind';
import Punches from './Punches';
import DayTitle from './DayTitle';

const Day = ({ onToggle, inner, today, day, sheet, selecteds, selected }) => {
  const handleToggle = () => {
    if(inner) {
      onToggle(day, selecteds);
    }
  }
  let classNames = cx(
    `weekday-${day.day()}`,
    (inner ? 'inner' : 'out'),
    { today: today, selected: selected }
  );

  return(
    <td className={classNames} onClick={() => {handleToggle()}} >
      <DayTitle day={day} />
      <Punches sheet={sheet} />
    </td>
  );
};

export default Day;
