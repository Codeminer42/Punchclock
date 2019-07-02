import React from 'react';
import Select from 'react-select2-wrapper';

class Form extends React.Component{
  render() {
    const projectsList = Projects.map( (p, i) =>  {
      return {text: p[1], id: p[0]}
    });
    if(!this.props.calendar.selecteds.isEmpty()) {
      return (
        <form
          onSubmit={this.handleSubmit.bind(this)}>

          <p>
            <input
              placeholder="De"
              ref="from1"
              type="time"
              defaultValue="09:00"
              className="form-control form-control-sm" />
            <input
              placeholder="Até"
              ref="to1"
              type="time"
              defaultValue="12:00"
              className="form-control form-control-sm" />
          </p>

          <p>
            <input
              placeholder="De"
              ref="from2"
              type="time"
              defaultValue="13:00"
              className="form-control form-control-sm" />
            <input
              placeholder="Até"
              ref="to2"
              type="time"
              defaultValue="18:00"
              className="form-control form-control-sm"/>
          </p>

          <p>
            <Select ref="project" data={projectsList}></Select>
          </p>

          <p>
            <input type="submit" value="Ok" />
          </p>

          <p>
            <a onClick={() => {this.handleDeselect()}} >
              Descelecionar
            </a> - <a onClick={() => {this.handleErase()}}>
              Apagar
            </a>
          </p>
          <span> Selecionado ({this.props.calendar.selecteds.size})</span>
        </form>
      );
    }
    if(this.props.calendar.changes > 0) {
      return (
        <p>
          <button onClick={this.handleSave.bind(this)}>Salvar</button><br />
          Alterações ({this.props.calendar.changes})
        </p>
      );

    } else return <p />;
  }

  handleSave(e) {
    this.props.onSaveSheets(
      this.props.calendar.deleteds,
      this.props.calendar.sheets,
      this.props.calendar.sheetsSaveds
    );
  }

  handleSubmit(e) {
    e.preventDefault();
    this.props.onSetTimeSheet([
        { from: this.refs.from1.value,
          to: this.refs.to1.value,
          project_id: this.refs.project.el.val()},
        { from: this.refs.from2.value,
          to: this.refs.to2.value,
          project_id: this.refs.project.el.val()}
      ],
      this.props.calendar.selecteds,
      this.props.calendar.sheets,
      this.props.calendar.deleteds
    );
  }

  handleErase() {
    this.props.onErase(
      this.props.calendar.selecteds,
      this.props.calendar.sheets,
      this.props.calendar.deleteds,
      this.props.calendar.sheetsSaveds,
    );
  }

  handleDeselect() {
    this.props.onDeselect();
  }
}

export default Form;
