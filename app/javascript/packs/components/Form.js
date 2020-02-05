import React from 'react';
import Select from 'react-select2-wrapper';

class Form extends React.Component{
  state = {
    hasConfirmedOperation: false
  }

  render() {
    const { calendar: { selecteds } } = this.props;
    const isSelectedsEmpty = selecteds.isEmpty();

    if(isSelectedsEmpty) {
      return null
    }

    const projectsList = Projects.map((p) =>  {
      return {text: p[1], id: p[0]}
    });

    return (
      <form
        onSubmit={this.handleSubmit.bind(this)}>

        <div className="selected-days-container mb-2">
          <h4>Selecionado ({this.props.calendar.selecteds.size})</h4>
          <span>
            <a onClick={() => {this.handleDeselect()}} >
              Descelecionar
            </a> - <a onClick={() => {this.handleErase()}}>
              Apagar
            </a>
          </span>
        </div>

        <div className="mb-3">
          <h5>Projeto</h5>
          <div className="w-100">
            <Select ref="project" data={projectsList}></Select>
          </div>
        </div>

        <h5>Manhã</h5>
        <div className="d-flex align-items-center mb-3">
          <input
            placeholder="De"
            ref="from1"
            type="time"
            defaultValue="09:00"
            className="form-control form-control-sm w-auto" />
          <span className="mx-2">-</span>
          <input
            placeholder="Até"
            ref="to1"
            type="time"
            defaultValue="12:00"
            className="form-control form-control-sm w-auto" />
        </div>
        <h5>Tarde</h5>
        <div className="d-flex align-items-center mb-3">
          <input
            placeholder="De"
            ref="from2"
            type="time"
            defaultValue="13:00"
            className="form-control form-control-sm w-auto" />
          <span className="mx-2">-</span>
          <input
            placeholder="Até"
            ref="to2"
            type="time"
            defaultValue="18:00"
            className="form-control form-control-sm w-auto"/>
        </div>

        <p>
          <input type="submit" value="Salvar" />
        </p>
      </form>
    );
  }

  /* Removes the double confirmation prompt */
  componentDidUpdate() {
    if (this.state.hasConfirmedOperation) {
      this.handleSave();
      this.setState({ hasConfirmedOperation: false })
    }
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
    this.setState({ hasConfirmedOperation: true })
  }

  handleErase() {
    this.props.onErase(
      this.props.calendar.selecteds,
      this.props.calendar.sheets,
      this.props.calendar.deleteds,
      this.props.calendar.sheetsSaveds,
    );
    this.setState({ hasConfirmedOperation: true })
  }

  handleDeselect() {
    this.props.onDeselect();
  }
}

export default Form;
