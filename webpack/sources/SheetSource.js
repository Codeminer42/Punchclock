import request from 'superagent';
import asPromissed from 'superagent-as-promised';
import SheetStore from '../stores/SheetStore';

asPromissed(request);

const url = '/dashboard/sheets';
const csrf = {
  token: document.querySelector('[name="csrf-token"]').attributes.content.value,
  param: document.querySelector('[name="csrf-param"]').attributes.content.value
};

export default {
  fetch: function() {
    return request.get(url).endAsync();
  },

  save: function() {
    const state = SheetStore.getState();
    return request.post(url)
      .set('X-CSRF-Param', csrf.param)
      .set('X-CSRF-Token', csrf.token)
      .send({
        delete: state.deleteds,
        add: state.sheets
      }).endAsync();
  }
};
