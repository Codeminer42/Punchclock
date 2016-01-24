import React from 'react';
import Week from './Week';
import Day from './Day';

export default function Weeks({Calendar, actions, sheetFor, isSelected}) {
  return <tbody>
    { Calendar.weeks.map((week, i)=>
      <Week key={i} week={week} actions={actions} >
        { week.days.map((d, ii)=>
          <Day key={ii}
            sheet={sheetFor(d)}
            actions={actions}
            selected={isSelected(d.day)}
            {...d.toObject()} />
        )}
      </Week>
    )}
  </tbody>;
};

