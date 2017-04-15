import React from 'react';

class WeekNames extends React.Component{
  render(){
    return (
      <thead>
        <tr>
          {this.props.weekdays.map((n, i)=> <th key={i}>{n}</th>)}
        </tr>
      </thead>
    );
  }
}

export default WeekNames;
