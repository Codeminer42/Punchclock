import request from 'superagent';
import asPromissed from 'superagent-as-promised';

asPromissed(request);

const url = '/dashboard/sheets';
const csrf = {
  token: document.querySelector('[name="csrf-token"]'),
  param: document.querySelector('[name="csrf-param"]')
};

export const fetchSheets = () => {
  return request.get(url).endAsync();
};

export const saveSheets = (deleteds, sheets) => {
  let _request = request.post(url);

  if(csrf.token) {
    _request = _request.set('X-CSRF-Param', csrf.param.attributes.content.value)
              .set('X-CSRF-Token', csrf.token.attributes.content.value);
  }

  return _request.send({ delete: deleteds, add: sheets }).endAsync();
};
