import React from 'react';
import Select from 'react-select2-wrapper';
import { compareHours } from '../utils/calendar';

class Form extends React.Component{
  state = {
    selectedProject: "",
    hasConfirmedOperation: false,
    workPeriods: {
      from1: "09:00",
      to1: "12:00",
      from2: "13:00",
      to2: "18:00",
      areValid: true
    }
  }

  render() {
    const { calendar: { selecteds } } = this.props;
    const workPeriods = this.state.workPeriods;

    const isSelectedsEmpty = selecteds.isEmpty();
    const isSaveButtonDisabled = isSelectedsEmpty || !!!this.state.selectedProject
    const invalidWorkPeriods = !workPeriods.areValid;

    const projectsList = Projects.map((p) =>  {
      return {text: p[1], id: p[0]}
    });

    return (
      <form onSubmit={this.handleSubmit.bind(this)}>
        <div className="form-container mb-4">
          {/* Form Header */}
          <div className="d-flex justify-content-between align-items-baseline selected-days-container">
            <h6>Selecionado ({this.props.calendar.selecteds.size})</h6>
            <div className="d-flex align-items-center">
              <button
                className="btn btn-outline-secondary btn-sm text-dark mr-2"
                disabled={isSelectedsEmpty}
                type="button"
                onClick={() => {this.handleDeselect()}}
              >
                Remover seleção <i className="fa fa-times-circle fa-sm"></i>
              </button>
              <button
                className="btn btn-outline-danger btn-sm text-danger"
                disabled={isSelectedsEmpty}
                type="button"
                onClick={() => {this.handleErase()}}
              >
                  Apagar <i style={{color: "#c61515"}} className="fa fa-trash fa-sm"></i>
              </button>
            </div>
          </div>
          {/* Form Inputs Control */}
          <div className="row p-3">
            <div className="col select-container">
              <Select
                ref="project"
                value={this.state.selectedProject}
                data={projectsList}
                disabled={isSelectedsEmpty}
                options={{ placeholder: 'Projeto' }}
                onChange={(e) => this.handleProjectChange(e)}
              />
            </div>
            <div className="col">
              <div className="d-flex align-items-center">
                <i style={{color: isSelectedsEmpty ? "#9ea8ad" : "#555"}} className="fa fa-coffee fa-lg"></i>
                <input
                  disabled={isSelectedsEmpty}
                  placeholder="De"
                  ref="from1"
                  name="from1"
                  type="time"
                  defaultValue={workPeriods.from1}
                  className="form-control form-control-sm w-auto ml-1"
                  onChange={this.handleValidWorkPeriods.bind(this)} />
                <span className="mx-1">-</span>
                <input
                  disabled={isSelectedsEmpty}
                  placeholder="Até"
                  ref="to1"
                  name="to1"
                  type="time"
                  defaultValue={workPeriods.to1}
                  className="form-control form-control-sm w-auto"
                  onChange={this.handleValidWorkPeriods.bind(this)} />
              </div>
            </div>
            <div className="col">
              <div className="d-flex align-items-center">
                <i style={{color: isSelectedsEmpty ? "#9ea8ad" : "#555"}} className="fa fa-utensils fa-lg"></i>
                <input
                  disabled={isSelectedsEmpty}
                  placeholder="De"
                  ref="from2"
                  name="from2"
                  type="time"
                  defaultValue={workPeriods.from2}
                  className="form-control form-control-sm w-auto ml-1"
                  onChange={this.handleValidWorkPeriods.bind(this)} />
                <span className="mx-1">-</span>
                <input
                  disabled={isSelectedsEmpty}
                  placeholder="Até"
                  ref="to2"
                  name="to2"
                  type="time"
                  defaultValue={workPeriods.to2}
                  className="form-control form-control-sm w-auto"
                  onChange={this.handleValidWorkPeriods.bind(this)} />
              </div>
            </div>
            <div className="col">
              <input className="w-100" disabled={isSaveButtonDisabled || invalidWorkPeriods} type="submit" value="Salvar" />
            </div>
          </div>
        </div>
      </form>
    );
  }

  /* Removes the double confirmation prompt */
  componentDidUpdate() {
    if (this.props.calendar.selecteds.size == 0) {
      if (this.state.selectedProject) {
        this.setState({ selectedProject: "" })
      }
    }

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
    this.setState({ hasConfirmedOperation: true, selectedProject: "" })
  }

  areValidWorkPeriods(from1, to1, from2, to2) {
    return (
      (compareHours({ firstHour: from1, secondHour: to1 }) && compareHours({ firstHour: from2, secondHour: to2 })) &&
      (compareHours({ firstHour: from1, secondHour: from2 }) && compareHours({ firstHour: to1, secondHour: to2 }))
    )
  }

  handleValidWorkPeriods({target: { name, value }}) {
    const updatedWorkPeriods = {
      ...this.state.workPeriods,
      [name]: value,
    }

    const { from1, to1, from2, to2 } = updatedWorkPeriods

    this.setState({
      workPeriods: { ...updatedWorkPeriods,
      areValid: this.areValidWorkPeriods(from1, to1, from2, to2)
    }})
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

  handleProjectChange(e) {
    this.setState({ selectedProject: e.currentTarget.value })
  }
}

export default Form;
