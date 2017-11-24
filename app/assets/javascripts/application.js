//= require jquery
//= require jquery-ui/datepicker
//= require jquery_ujs
//= require bootstrap
//= require jquery_nested_form
//= require datepicker

$(function () {
  $('.file-field-import-csv').change(function () {
    $(this).parents('form').submit();
  });

  setDatePicker();

  $('#menu-icon').click(function () {
    $('.topnav').toggleClass('topnav-opened');
  });
});
