import React from 'react';
import Week from './Week';
import Day from './Day';

const Weeks = ({ sheetFor, isSelected, calendar, onSelectWeek, onToggle }) => {
  return (
    <tbody>
      { calendar.weeks.map((week, i)=>
        <Week key={i}
          selecteds={calendar.selecteds}
          week={week}
          onSelectWeek={onSelectWeek} >
          { week.days.map((d, ii)=>
            <Day key={ii}
              sheet={sheetFor(d, calendar.sheets, calendar.sheetsSaveds)}
              onToggle={onToggle}
              selecteds={calendar.selecteds}
              selected={isSelected(calendar.selecteds, d.day)}
              holidays={calendar.holidays}
              {...d.toObject()} />
          )}
        </Week>
      )}
    </tbody>
  );
};

export default Weeks;
