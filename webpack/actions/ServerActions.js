import alt from '../alt';
import SheetSource from '../sources/SheetSource';

class ServerActions {
  constructor(){
    this.generateActions(
      'updateSheets',
      'sheetsFailed'
    );
  }

  fetchSheets() {
    return (dispatch) => {
      dispatch();

      SheetSource.fetch()
        .then((response) => this.actions.updateSheets(response.body) )
        .catch((response) => this.actions.sheetsFailed(response.body) );
    }
  }
}

export default alt.createActions(ServerActions);
