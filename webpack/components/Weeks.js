import React from 'react';
import Week from './Week';
import Day from './Day';

class Weeks extends React.Component{
  render(){
    return(
      <tbody>
        { this.props.calendar.weeks.map((week, i)=>
          <Week key={i}
            selecteds={this.props.calendar.selecteds} 
            week={week}
            onSelectWeek={this.props.onSelectWeek} >
            { week.days.map((d, ii)=>
              <Day key={ii}
                sheet={this.props.sheetFor(d, this.props.calendar.sheets, this.props.calendar.sheetsSaveds)}
                onToggle={this.props.onToggle}
                selecteds={this.props.calendar.selecteds}
                selected={this.props.isSelected(this.props.calendar.selecteds, d.day)}
                {...d.toObject()} />
            )}
          </Week>
        )}
      </tbody>
    );
  }
}

export default Weeks;
