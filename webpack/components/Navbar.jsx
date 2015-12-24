import React from 'react';

export default class extends React.Component {
  render() {
    let nextButton;

    if(this.props.hasNext )
      nextButton = <a onClick={this.handleNext.bind(this)}> ❯ </a>

    return (
      <h1>
        <a onClick={this.handlePrev.bind(this)}> ❮ </a>
        {this.props.children}
        { nextButton }
      </h1>
    );
  }

  handlePrev() {
    this.props.actions.prev();
  }

  handleNext() {
    this.props.actions.next();
  }
}
