import React from 'react';
import * as Calendar from '../utils/calendar';

class Navbar extends React.Component{
  render() {
    let nextButton;
    if(this.props.hasNext){
      nextButton = <a onClick={() => {this.handleNext()}}> ❯ </a>
    }

    return (
      <h1>
        <a onClick={() => {this.handlePrev()}}> ❮ </a>
          {this.props.children}
          {nextButton}
      </h1>
    );
  }

  handlePrev() {
    this.props.onPrev(this.props.base)
  }

  handleNext() {
    this.props.onNext(this.props.base)
  }
}

export default Navbar;
