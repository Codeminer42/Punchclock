import React from 'react';
import CalendarActions from '../actions/CalendarActions';

export default class extends React.Component {
  render() {
    let nextButton;

    if(this.props.hasNext )
      nextButton = <a onClick={this.handleNext.bind(this)}> ❯ </a>

    return (
      <h1>
        <a onClick={this.handlePrev.bind(this)}> ❮ </a>
        {this.props.monthNames}
        { nextButton }
      </h1>
    );
  }

  handlePrev() {
    CalendarActions.deselect();
    CalendarActions.prev();
  }

  handleNext() {
    CalendarActions.deselect();
    CalendarActions.next();
  }
}
