import request from 'superagent';
import asPromissed from 'superagent-as-promised';
import SheetStore from '../stores/SheetStore';

asPromissed(request);

const url = '/dashboard/sheets';
const csrf = {
  token: document.querySelector('[name="csrf-token"]'),
  param: document.querySelector('[name="csrf-param"]')
};

export default {
  fetch: function() {
    return request.get(url).endAsync();
  },

  save: function() {
    const state = SheetStore.getState();
    let _reqquest = request.post(url);

    if(csrf.token) {
      let _request = req.set('X-CSRF-Param', csrf.param.attributes.content.value)
                        .set('X-CSRF-Token', csrf.token.attributes.content.value);
    }

    return _request.send({ delete: state.deleteds, add: state.sheets }).endAsync();
  }
};
