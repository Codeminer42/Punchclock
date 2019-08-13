//= require active_admin/base
//= require 'select2/dist/js/select2.js'

$(document).ready(function() {
  var $seachFields = $('[data-select]')
  $seachFields.select2();

  $seachFields.each((_, field) => setLinkForResource($(field)));

  function show_custom_filter(){
    $('#filtro_sidebar_section').removeClass('hide_custom_filter')
    // shrink #active_admin_content
    $('#active_admin_content').addClass('with_sidebar')
    $('#active_admin_content').removeClass('without_sidebar')
  }

  function hide_custom_filter(){
    $('#filtro_sidebar_section').addClass('hide_custom_filter')
    // expand #active_admin_content
    $('#active_admin_content').addClass('without_sidebar')
    $('#active_admin_content').removeClass('with_sidebar')
  }
  
  if ($('#filtro_sidebar_section').length){
    toogle_custom_filter()
  }

  function toogle_custom_filter(){
    if ($('table#table_admin_punches').is(':visible')){
      show_custom_filter()
    }else{
      hide_custom_filter()
    }
  }

  // show/hide sidebar filters when click in tabs
  $('a.ui-tabs-anchor').click(function(){toogle_custom_filter()})
});

function setLinkForResource($resource) {
  var resourceName = $resource.data("select");
  $resource.change(function() {
    $(`[data-select-search="${resourceName}"]`)
      .attr("href",`/admin/${resourceName}/${encodeURIComponent($(this).val())}`);
  });
};
