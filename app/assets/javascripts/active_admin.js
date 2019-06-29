//= require active_admin/base
//= require 'select2/dist/js/select2.js'

$(document).ready(function() {
  $('[data-select="true"]').select2();
  setLinkForUser()
});

function setLinkForUser() {
  $("#user_id").change(function() {
     $("#search_link").attr("href","/admin/users/" + encodeURIComponent( $(this).val() ) );
  });
}
