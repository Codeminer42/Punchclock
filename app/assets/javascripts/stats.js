async function getContributionsAjax(payload_data){
  const response = $.ajax({
    type: 'GET',
    url: '/admin/stats/show',
    data: payload_data,
  })

  return response
}

$(document).ready(function() {
  // update chart at page ActiveAdmin::Stats
  // with data from '/admin/stats/show'
  // when onChange in dropdown of months
  // by ajax

  $('#by-office-month-selector').on('change', async function(){
    data = await getContributionsAjax(
      payload_data = {
        'month': this.value,
        'by_office': true
    });

    max = Object.values(data)[0]

    new Chartkick['ColumnChart']('graph-by-office-div', data, {max:max});
  });

  $('#by-user-month-selector').on('change', async function(){
    data = await getContributionsAjax(
      payload_data = {
        'month': this.value,
        'by_user': true
    });

    max = Object.values(data)[0]

    new Chartkick['ColumnChart']('graph-by-user-div', data, { max: max });
  })
});
