//= require active_admin/base
//= require 'select2/dist/js/select2.js'

$(document).ready(function() {
  $('[data-select]').select2();
  setLinkForUser();
  setLinkForOffice();
});

function setLinkForUser() {
  $("#user_id").change(function() {
    $("#search-user-link").attr("href","/admin/users/" + encodeURIComponent( $(this).val() ) );
  });
};

function setLinkForOffice() {
  $("#office_id").change(function() {
    $("#search-office-link").attr("href","/admin/offices/" + encodeURIComponent( $(this).val() ) );
  });
};
