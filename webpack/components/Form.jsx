import React from 'react';
import SelectionStore from '../stores/SelectionStore';
import CalendarActions from '../actions/CalendarActions';

function getStateFromStore() {
  let selecteds = SelectionStore.getState().selectedDays;
  return { selectedCount: selecteds.length };
}

export default class extends React.Component {
  constructor() {
    super();
    this.state = getStateFromStore();
  }

  render() {
    if(this.state.selectedCount == 0) return <p><button>Salvar!</button></p>
    return (
      <form style={ {width: '80%', margin: '0 auto', textAlign: 'center'} }>

        <input placeholder="De" type="time" value="09:00" />
        <input placeholder="Até" type="time" value="12:00" />

        <input placeholder="De" type="time" value="13:00" />
        <input placeholder="Até" type="time" value="18:00" />

        <input type="submit" value="Ok" />
        <button onClick={this.handleDeselect} >Descelecionar</button>
        <button >Apagar</button>
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

  handleDeselect(e) {
    e.preventDefault();
    CalendarActions.deselect();
  }
}
