//= require active_admin/base
//= require 'select2/dist/js/select2.js'

$(document).ready(function() {
  var $seachFields = $('[data-select]')
  $seachFields.select2();

  $seachFields.each((_, field) => setLinkForResource($(field)));
});

function setLinkForResource($resource) {
  var resourceName = $resource.data("select");
  $resource.change(function() {
    $(`[data-select-search="${resourceName}"]`)
      .attr("href",`/admin/${resourceName}/${encodeURIComponent($(this).val())}`);
  });
};
