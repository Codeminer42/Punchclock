import React from 'react';
import Select from 'react-select2-wrapper';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faSun, faMoon, faTrash, faTimesCircle } from '@fortawesome/free-solid-svg-icons';

class Form extends React.Component{
  state = {
    hasConfirmedOperation: false
  }

  render() {
    const { calendar: { selecteds } } = this.props;
    const isSelectedsEmpty = selecteds.isEmpty();

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
                Remover seleção <FontAwesomeIcon fixedWidth size="sm" icon={faTimesCircle} />
              </button>
              <button
                className="btn btn-outline-danger btn-sm text-danger"
                disabled={isSelectedsEmpty}
                type="button"
                onClick={() => {this.handleErase()}}
              >
                  Apagar <FontAwesomeIcon color="#c61515" fixedWidth size="sm" icon={faTrash} />
              </button>
            </div>
          </div>
          {/* Form Inputs Control */}
          <div className="row p-3">
            <div className="col select-container">
              <Select
                ref="project"
                data={projectsList}
                disabled={isSelectedsEmpty}
                options={{ placeholder: 'Projeto' }}
              />
            </div>
            <div className="col">
              <div className="d-flex align-items-center">
                <FontAwesomeIcon fixedWidth color={isSelectedsEmpty ? "#9ea8ad" : "#555"} icon={faSun} size="lg" />
                <input
                  disabled={isSelectedsEmpty}
                  placeholder="De"
                  ref="from1"
                  type="time"
                  defaultValue="09:00"
                  className="form-control form-control-sm w-auto ml-1" />
                <span className="mx-1">-</span>
                <input
                  disabled={isSelectedsEmpty}
                  placeholder="Até"
                  ref="to1"
                  type="time"
                  defaultValue="12:00"
                  className="form-control form-control-sm w-auto" />
              </div>
            </div>
            <div className="col">
              <div className="d-flex align-items-center">
                <FontAwesomeIcon fixedWidth color={isSelectedsEmpty ? "#9ea8ad" : "#555"} icon={faMoon} size="lg" />
                <input
                  disabled={isSelectedsEmpty}
                  placeholder="De"
                  ref="from2"
                  type="time"
                  defaultValue="13:00"
                  className="form-control form-control-sm w-auto ml-1" />
                <span className="mx-1">-</span>
                <input
                  disabled={isSelectedsEmpty}
                  placeholder="Até"
                  ref="to2"
                  type="time"
                  defaultValue="18:00"
                  className="form-control form-control-sm w-auto"/>
              </div>
            </div>
            <div className="col">
              <input className="w-100" disabled={isSelectedsEmpty} type="submit" value="Salvar" />
            </div>
          </div>
        </div>
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
