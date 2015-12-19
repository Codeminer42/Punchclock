import React from 'react';
import Calendar from './Calendar';

export default React.createClass({
  render: function() {
    return (
      <div>
        <h1>Dashbard</h1>
        <Calendar base="2015-12-15" />
      </div>
    )
  }
});
