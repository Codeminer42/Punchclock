import React from 'react';

class Week extends React.Component {
  render() {
    return (
      <tr onDoubleClick={() => {this.handleSelectWeek()}}>
        { this.props.children }
      </tr>
    );
  }

  handleSelectWeek() {
    this.props.onSelectWeek(this.props.week, this.props.selecteds);
  }
}

export default Week;
