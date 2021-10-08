//= require active_admin/base
//= require 'select2/dist/js/select2.js'
//= require ./active_admin/user.js
//= require ./active_admin/dashboard.js
//= require stats.js
//= require chartkick
//= require Chart.bundle

$(document).ready(function() {
  var $seachFields = $('[data-select]')
  $seachFields.select2();

  $seachFields.each((_, field) => setLinkForResource($(field)));

  var toggleCustomFilter = function() {
    var visible = $('table#table_admin_punches').is(':visible');
    var sideBarFilter = $('#filtro_sidebar_section');
    var adminContent = $('#active_admin_content');
  
    sideBarFilter.toggleClass("hide_custom_filter", !visible);
    adminContent.toggleClass("with_sidebar", visible);
    adminContent.toggleClass("without_sidebar", !visible);
  }
  
  if ($('#filtro_sidebar_section').length){
    toggleCustomFilter()
  }

  // show/hide sidebar filters when click in tabs
  $('a.ui-tabs-anchor').click(function(){toggleCustomFilter()})
});

function setLinkForResource($resource) {
  var resourceName = $resource.data("select");
  $resource.change(function() {
    $(`[data-select-search="${resourceName}"]`)
      .attr("href",`/admin/${resourceName}/${encodeURIComponent($(this).val())}`);
  });
};
