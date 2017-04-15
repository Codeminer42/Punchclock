import React from 'react';

class DayTitle extends React.Component{
  render(){
    return(
      <h3>
        {this.props.day.format('DD')}
        { this.props.day.date() == 1 ? `/${this.props.day.format('MMM')}` : '' }
      </h3>
    );
  }
}

export default DayTitle;
