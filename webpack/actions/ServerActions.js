import alt from '../alt';
import SheetSource from '../sources/SheetSource';

class ServerActions {
  constructor(){
    this.generateActions(
      'updateSheets',
      'sheetsFailed',
      'saveSuccessSheets',
      'sheetsSaveFailed'
    );
  }

  fetchSheets() {
    return (dispatch) => {
      dispatch();

      SheetSource.fetch()
        .then((response) => this.actions.updateSheets(response.body) )
        .catch((response) => this.actions.sheetsFailed(response.body) );
    };
  }

  saveSheets() {
    return (dispatch) => {
      dispatch();

      SheetSource.save()
        .then((response) => this.actions.saveSuccessSheets(response.body) )
        .catch((response) => this.actions.sheetsSaveFailed(response.body) );
    };
  }
}

export default alt.createActions(ServerActions);
