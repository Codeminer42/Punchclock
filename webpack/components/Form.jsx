import React from 'react';
import SelectionStore from '../stores/SelectionStore';
import CalendarActions from '../actions/CalendarActions';

function getStateFromStore() {
  let selecteds = SelectionStore.getState().selectedDays;
  return {
    selectedDays: selecteds,
    selectedCount: selecteds.length
  };
}

export default class extends React.Component {
  constructor() {
    super();
    this.state = getStateFromStore();
  }

  render() {
    if(this.state.selectedCount == 0) return <p><button>Salvar!</button></p>
    return (
      <form
        onSubmit={this.handleSubmit.bind(this)}
        className='punches-toolbar' >

        <input placeholder="De" ref="from1" type="time" defaultValue="09:00" />
        <input placeholder="Até" ref="to1" type="time" defaultValue="12:00" />

        <input placeholder="De" ref="from2" type="time" defaultValue="13:00" />
        <input placeholder="Até" ref="to2" type="time" defaultValue="18:00" />

        <input type="submit" value="Ok" />
        <button onClick={this.handleDeselect} >Descelecionar</button>
        <button onClick={this.handleErase}>Apagar</button>
        <span> Selecionado ({this.state.selectedCount})</span>
      </form>
    );
  }

  componentDidMount() {
    SelectionStore.listen(this.onChange.bind(this));
  }

  componentWillUnmount() {
    SelectionStore.unlisten(this.onChange.bind(this));
  }

  onChange(state) {
    this.setState(getStateFromStore());
  }

  handleSubmit(e) {
    e.preventDefault();
    CalendarActions.setTimeSheet([
      `${this.refs.from1.value} - ${this.refs.to1.value}`,
      `${this.refs.from2.value} - ${this.refs.to2.value}`]);
    CalendarActions.deselect();
  }

  handleErase(e) {
    e.preventDefault();
    CalendarActions.erase();
  }

  handleDeselect(e) {
    e.preventDefault();
    CalendarActions.deselect();
  }
}
