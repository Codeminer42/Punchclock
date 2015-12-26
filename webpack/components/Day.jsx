import React from 'react';
import Punch from './Punch';

export default class extends React.Component {
  getClassNames() {
    let classNames = [`weekday-${this.props.day.day()}`];

    if(this.props.inner) classNames.push('inner');
    else classNames.push('out');

    if(this.props.selected) { classNames.push('selected'); }
    return classNames.join(' ');
  }

  render() {
    return (
      <td
        className={this.getClassNames()}
        onClick={this.handleClick.bind(this)} >
        <h3>{this.props.day.format('DD')}</h3>
        <ul className="punches">
          { this.props.sheet.map( (punch, i)=> <Punch key={i} punch={punch} /> )}
        </ul>
      </td>
    );
  }

  handleClick(e) {
    e.preventDefault();
    if(this.props.inner) {
      this.props.actions.toggle(this.props.day);
    }
  }
}
