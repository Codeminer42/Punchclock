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

  $('#by-month-selector').on('change', async function(){
    byOfficeData = await getContributionsAjax(
      payload_data = {
        'month': this.value,
        'by_office': true
    });

    byUserData = await getContributionsAjax(
      payload_data = {
        'month': this.value,
        'by_user': true
    });

    byOfficeMax = Object.values(byOfficeData)[0]
    byUserMax = Object.values(byUserData)[0]

    new Chartkick['ColumnChart']('graph-by-office-div', byOfficeData, {max:byOfficeMax});
    new Chartkick['ColumnChart']('graph-by-user-div', byUserData, { max: byUserMax });
  });
});
