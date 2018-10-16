import React from 'react';
import cx from 'classnames/bind';
import Punches from './Punches';
import DayTitle from './DayTitle';
import { isHoliday } from '../utils/calendar';


const Day = ({ day, selecteds, holidays, inner, onToggle, today, selected, sheet }) => {
  let holiday = () => isHoliday(selecteds, day, holidays)

  let handleToggle = () => {
    if(inner && !holiday()) {
      onToggle(day, selecteds);
    }
  }

  let classNames = cx(
    `weekday-${day.day()}`,
    `${(holiday()) ? ' weekday-holiday' : ''}`,
    (inner ? 'inner' : 'out'),
    { today: today, selected: selected }
  );

  return (
    <td className={classNames} onClick={() => {handleToggle()}} >
      <DayTitle day={day} />
      <Punches sheet={sheet} />
    </td>
  );
}

export default Day;
