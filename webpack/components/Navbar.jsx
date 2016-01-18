import React from 'react';
import { History } from 'react-router';

export default React.createClass({
  mixins: [ History ],
  render: function() {
    let nextButton;

    if(this.props.hasNext )
      nextButton = <a onClick={this.handleNext}> ❯ </a>

    return (
      <h1>
        <a onClick={this.handlePrev}> ❮ </a>
        {this.props.children}
        { nextButton }
      </h1>
    );
  },

  handlePrev: function() {
    this.props.actions.prev(this.history);
  },

  handleNext: function() {
    this.props.actions.next(this.history);
  }
});
