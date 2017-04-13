import request from 'superagent';
import asPromissed from 'superagent-as-promised';

asPromissed(request);

const url = '/dashboard/sheets';
const csrf = {
  token: document.querySelector('[name="csrf-token"]'),
  param: document.querySelector('[name="csrf-param"]')
};

const fetch = () => {
  return request.get(url).endAsync();
};
