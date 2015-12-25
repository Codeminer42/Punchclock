import request from 'superagent';
import asPromissed from 'superagent-as-promised';

asPromissed(request);

const sheetRequest = request.get('/dashboard/sheets');

export default {
  fetch: function() {
    return sheetRequest.endAsync();
  }
}
