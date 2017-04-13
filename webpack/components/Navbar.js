import React from 'react';
import { History } from 'react-router';

class Navbar extends React.Component{

  render() {
    let nextButton;
    if(this.props.hasNext ){
      nextButton = <a onClick={this.handleNext}> ❯ </a>
    }
    return (
      <h1>
        <a onClick={this.handlePrev}> ❮ </a>
        {this.props.children}
        { nextButton }
      </h1>
    );
  }

  handlePrev() {
    this.props.actions.prev(History);
  }

  handleNext() {
    this.props.actions.next(History);
  }
}

export default Navbar;
