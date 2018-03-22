//= require jquery
//= require jquery-ui/widgets/datepicker
//= require jquery_ujs
//= require datepicker
//= require select2
//= require select2_simple_form
$(function () {
  setDatePicker();

  $('#menu-icon').click(function () {
    $('.topnav').toggleClass('topnav-opened');
  });
});
