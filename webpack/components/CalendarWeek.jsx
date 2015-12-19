import React from 'react';

export default React.createClass({
  render: function() {
    let days = [];
    for(let i = 0; i < 7; i++) {
      let day = this.props.start.clone().add(i, 'day');
      let className = day.isBetween(this.props.calendarRange[0],
                                    this.props.calendarRange[1], 'day') ? 'inner' : 'out';
      days.push(
        <td key={i} className={className}>{day.format('DD')}</td>
      );
    }
    return (
      <tr>{days}</tr>
    )
  }
});
