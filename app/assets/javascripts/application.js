//= require jquery
//= require jquery-ui/datepicker
//= require jquery_ujs
//= require bootstrap
//= require jquery_nested_form

$(function() {
  var menu = $('#navigation-menu');
  var menuToggle = $('#js-mobile-menu');

  $(menuToggle).on('click', function(e) {
    e.preventDefault();
    menu.slideToggle(function(){
      if(menu.is(':hidden')) {
        menu.removeAttr('style');
      }
    });
  });
});
