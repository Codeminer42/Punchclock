import React from 'react';
import moment from 'moment';

const format = (timestamp) => {
  return moment.utc(timestamp).format('HH:mm');
};

class Punch extends React.Component{
  render(){
    let punch = this.props.punch;
    return(
      <li>{format(punch.from)} - {format(punch.to)}</li>
    );
  }
}

export default Punch;
