//= require jquery
//= require jquery-ui/datepicker
//= require jquery_ujs
//= require bootstrap
//= require jquery_nested_form

$(function () {
  
  $(".file-field-import-csv").change(function () {
    $(this).parents("form").submit();
  });

  $('input.datepicker').datepicker({ dateFormat: 'yy-mm-dd' });

});

function openNotificationCenter() {
  document.getElementById("n-r-count").innerHTML = "Notifications <span class=\"caret\"/>";
}

function markAsRead(id) {
  document.getElementById("n-r-count").innerHTML = "Notifications <span class=\"caret\"/>";
  var element = "n-rd-" + id;
  document.getElementById(element).remove();
  $.ajax({
    type: 'PUT',
    dataType: "json",
    url: 'notification/' + id,
    data: { notification: { read: true } }
  })
}

$("#menu-icon").click(function () {
  $('.topnav').toggleClass('responsive');
});