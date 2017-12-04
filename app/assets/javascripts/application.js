//= require jquery
//= require jquery-ui/datepicker
//= require jquery_ujs
//= require datepicker

$(function () {
  setDatePicker();

  $('#menu-icon').click(function () {
    $('.topnav').toggleClass('topnav-opened');
  });
});
