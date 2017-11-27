//= require jquery
//= require jquery-ui/datepicker
//= require jquery_ujs
//= require bootstrap
//= require datepicker
//= require punches

$(function () {
  setDatePicker();

  $('#menu-icon').click(function () {
    $('.topnav').toggleClass('topnav-opened');
  });
});
