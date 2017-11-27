//= require jquery
//= require jquery-ui/datepicker
//= require jquery_ujs
//= require bootstrap
//= require jquery_nested_form
//= require datepicker

$(function () {
  setDatePicker();

  $('#menu-icon').click(function () {
    $('.topnav').toggleClass('topnav-opened');
  });
});
