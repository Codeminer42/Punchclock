import React from 'react';

export default class Form extends React.Component {
  render() {
    if(!this.props.selecteds.isEmpty()) {
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
            <select ref="project">
            { Projects.map( (p, i)=> <option key={i} value={p[0]} >{p[1]}</option>) }
            </select>
          </p>

          <p>
            <input type="submit" value="Ok" />
          </p>

          <p>
            <a onClick={this.handleDeselect.bind(this)} >
              Descelecionar
            </a> - <a onClick={this.handleErase.bind(this)}>
              Apagar
            </a>
          </p>
          <span> Selecionado ({this.props.selecteds.size})</span>
        </form>
      );
    }
    if(this.props.changes > 0) {
      return (
        <p>
          <button onClick={this.handleSave.bind(this)}>Salvar</button><br />
          Alterações ({this.props.changes})
        </p>
      );

    } else return <p />;
  }

  handleSave(e) {
    this.props.save();
  }

  handleSubmit(e) {
    e.preventDefault();
    this.props.actions.setTimeSheet([
      { from: this.refs.from1.value,
        to: this.refs.to1.value,
        project_id: this.refs.project.value},
      { from: this.refs.from2.value,
        to: this.refs.to2.value,
        project_id: this.refs.project.value}
    ]);
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
