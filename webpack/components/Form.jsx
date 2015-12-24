import React from 'react';

export default class extends React.Component {
  render() {
    if(this.props.selecteds.isEmpty()) return <p><button>Salvar</button></p>
    return (
      <form
        onSubmit={this.handleSubmit.bind(this)}
        className='punches-toolbar' >

        <p>
          <input placeholder="De" ref="from1" type="time" defaultValue="09:00" />
          <input placeholder="Até" ref="to1" type="time" defaultValue="12:00" />
        </p>

        <p>
          <input placeholder="De" ref="from2" type="time" defaultValue="13:00" />
          <input placeholder="Até" ref="to2" type="time" defaultValue="18:00" />
        </p>

        <p>
          <select>
            <option>Projeto</option>
          </select>
        </p>

        <p>
          <input type="submit" value="Ok" />
        </p>

        <p>
          <a onClick={this.handleDeselect} >Descelecionar</a> <a onClick={this.handleErase}>Apagar</a>
        </p>
        <span> Selecionado ({this.props.selecteds.size})</span>
      </form>
    );
  }

  handleSubmit(e) {
    e.preventDefault();
    this.props.actions.setTimeSheet([
      `${this.refs.from1.value} - ${this.refs.to1.value}`,
      `${this.refs.from2.value} - ${this.refs.to2.value}`]);
  }

  handleErase(e) {
    e.preventDefault();
    this.props.actions.erase();
  }

  handleDeselect(e) {
    e.preventDefault();
    this.props.actions.deselect();
  }
}
