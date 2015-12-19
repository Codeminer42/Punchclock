import React from 'react';

export default class extends React.Component {
  render() {
    let classNames = [this.props.inner ? 'inner' : 'out']
    if(this.props.selected) { classNames.push('selected'); }
    let tdStyle = {
      border: (this.props.selected ? '1px solid' : ''),
      cursor: 'pointer',
      opacity: (this.props.inner ? 1 : 0.3 ),
      WebkitUserSelect: 'none'
    }

    return (
      <td
        className={classNames}
        style={tdStyle}
        onClick={this.handleClick.bind(this)} >
        {this.props.day.format('DD')}
      </td>
    );
  }

  handleClick(e) {
    if(!this.props.inner) return;
    this.props.onSelect(this.props.day);
  }
}
