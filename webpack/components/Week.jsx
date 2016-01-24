import React from 'react';

export default class Week extends React.Component {
  render() {
    return (
      <tr onDoubleClick={this.handleSelectWeek.bind(this)}>
        { this.props.children }
      </tr>
    );
  }

  handleSelectWeek(e) {
    this.props.actions.selectWeek(this.props.week);
  }
}
