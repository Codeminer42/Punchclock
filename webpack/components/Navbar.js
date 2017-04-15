import React from 'react';
import store from '../store';
import { push } from 'react-router-redux';
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
    store.dispatch(push(Calendar.prev(this.props.base).format('YYYY/MM')));
    this.props.onPrev(this.props.base)
  }

  handleNext() {
    store.dispatch(push(Calendar.next(this.props.base).format('YYYY/MM')));
    this.props.onNext(this.props.base)
  }
}

export default Navbar;
