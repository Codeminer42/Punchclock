$(document).ready(function() {
  // update chart at page ActiveAdmin::Stats 
  // with data from '/admin/stats/show'
  // when onChange in dropdown of months
  // by ajax 
  const max = $('#max').val()
  $('#month-selector').on('change', function(){
    $.ajax({type: 'get', 
            url: '/admin/stats/show', 
            data: {'month': this.value},
            success: function(data, status){
              new Chartkick['ColumnChart']('graph-div', data, {max:max});
            },
          })
  })

});
