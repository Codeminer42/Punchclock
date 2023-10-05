import request from 'superagent';
import asPromissed from 'superagent-as-promised';

asPromissed(request);

const urls = {
  sheets: '/dashboard/sheets',
  holidays: '/api/v1/holidays',
  currentAllocation: '/api/v1/allocations/current'
};
const csrf = {
  token: document.querySelector('[name="csrf-token"]'),
  param: document.querySelector('[name="csrf-param"]')
};

export const fetchSheets = () => {
  return request.get(urls.sheets).endAsync();
};

export const fetchHolidays = () => {
  return request.get(urls.holidays).endAsync();
}

export const fetchCurrentAllocation = () => {
  return request.get(urls.currentAllocation).endAsync();
}

export const saveSheets = (deleteds, sheets) => {
  let _request = request.post(urls.sheets);

  if(csrf.token) {
    _request = _request.set('X-CSRF-Param', csrf.param.attributes.content.value)
              .set('X-CSRF-Token', csrf.token.attributes.content.value);
  }

  return _request.send({ delete: deleteds, add: sheets }).endAsync();
};
