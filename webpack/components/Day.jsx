import React from 'react';
import classNames from 'classnames/bind';
import Punch from './Punch';

export default class extends React.Component {
  getClassNames() {
    return classNames(
      `weekday-${this.props.day.day()}`,
      (this.props.inner ? 'inner' : 'out'),
      {
        today: this.props.today,
        selected: this.props.selected
      }
    );
  }

  render() {
    let title;
    if(this.props.day.date() == 1)
      title = <h3>{this.props.day.format('DD')}/{this.props.day.format('MMM')}</h3>
    else
      title = <h3>{this.props.day.format('DD')}</h3>

    return (
      <td
        className={this.getClassNames()}
        onClick={this.handleClick.bind(this)} >
        { title }
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
