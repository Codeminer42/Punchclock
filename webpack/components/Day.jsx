import React from 'react';
import _ from 'lodash';
import SelectionStore from '../stores/SelectionStore';
import CalendarActions from '../actions/CalendarActions';

function getStateFromStore(props) {
  let selecteds = SelectionStore.getState().selectedDays;
  return { selected: _.contains(selecteds, props.day) };
}

export default class extends React.Component {
  constructor(props) {
    super(props);
    this.state = getStateFromStore(props);
  }

  getClassNames() {
    let classNames = [this.props.inner ? 'inner' : 'out']
    if(this.state.selected) { classNames.push('selected'); }
    return classNames.join(' ');
  }

  render() {
    return (
      <td
        className={this.getClassNames()}
        onClick={this.handleClick.bind(this)} >
        <h3>{this.props.day.format('DD')}</h3>
        <ul>{ this.props.sheet.map( (t, i)=> {
            return <li key={i}>{t}</li>
          })
        }</ul>
      </td>
    );
  }

  componentDidMount() {
    SelectionStore.listen(this.onChange.bind(this));
  }

  componentWillUnmount() {
    SelectionStore.unlisten(this.onChange.bind(this));
  }

  onChange(state) {
    this.setState(getStateFromStore(this.props));
  }

  handleClick(e) {
    if(!this.props.inner) return;
    CalendarActions.toggle(this.props.day);
  }
}
