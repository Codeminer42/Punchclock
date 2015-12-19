import React from 'react';

export default React.createClass({
  render: function() {
    return (
      <tr>{this.props.week.days.map( (d, i)=> {
          return <td key={i} className={d.inner ? 'inner' : 'out'}>
            {d.day.format('DD')}
          </td>
      })}</tr>
    )
  }
});
