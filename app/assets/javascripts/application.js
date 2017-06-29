//= require jquery
//= require jquery-ui/datepicker
//= require jquery_ujs
//= require bootstrap
//= require jquery_nested_form

$(function () {
  $('.file-field-import-csv').change(function () {
    $(this).parents('form').submit();
  });

  $('input.datepicker').datepicker({ dateFormat: 'yy-mm-dd' });

  $('#menu-icon').click(function () {
    $('.topnav').toggleClass('responsive');
  });
});

function openNotificationCenter() {
  var content = 'Notifications <span class="caret"></span>';
  document.getElementById('n-r-count').innerHTML = content;
}

function markAsRead(id) {
  openNotificationCenter();
  document.getElementById('n-rd-'+ id).remove();

  $.ajax({
    type: 'PUT',
    dataType: 'json',
    url: 'notification/' + id,
    data: {
      notification: { read: true }
    }
  });
}
