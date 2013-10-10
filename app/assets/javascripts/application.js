// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
// require turbolinks
//= require bootstrap
//= require_tree .
//= require jquery_nested_form

window.requestAnimFrame = (function(){
  return  window.requestAnimationFrame       ||
          window.webkitRequestAnimationFrame ||
          window.mozRequestAnimationFrame    ||
          function( callback ){
            window.setTimeout(callback, 1000 / 60);
          };
})();

$(function(){
  if ($('#clock-canvas').length == 0) {
    return;
  }
  var tic = 0;
  var ctx = $('#clock-canvas').get(0).getContext('2d');
  ctx.translate(180, 180);
  ctx.rotate((Math.PI / 180) * -90);

  function braceVector(deg, radius) {
    var rad = (Math.PI / 180) * deg;
    x = Math.cos(rad) * radius;
    y = Math.sin(rad) * radius;
    return { x: x, y: y };
  }

  function drawBrace(angle, size, color, lineSize) {
    var v = braceVector(angle, size);
    ctx.beginPath();
    ctx.moveTo(0, 0);
    ctx.lineTo(v.x, v.y);
    ctx.lineWidth = lineSize;
    ctx.strokeStyle = color;
    ctx.stroke();
  }

  function drawClock() {
    var dt = new Date(),
        hour = dt.getHours(),
        hourAngle = (hour > 12 ? hour - 12 : hour) * 30,
        minAngle = dt.getMinutes() * 6,
        secAngle = dt.getSeconds() * 6;

    ctx.beginPath();
    ctx.arc(0, 0, 164, 0 * Math.PI, 2 * Math.PI, false);
    ctx.lineWidth = 10;
    ctx.fillStyle = 'white';
    ctx.fill();
    ctx.strokeStyle = '#396c50';
    ctx.stroke();

    ctx.beginPath();
    ctx.arc(0, 0, 8, 0 * Math.PI, 2 * Math.PI, false);
    ctx.fillStyle = 'black';
    ctx.fill();

    drawBrace(hourAngle, 84, 'black', 8);
    drawBrace(minAngle, 134, 'black', 10);
    drawBrace(secAngle, 144, 'red', 4);
  }

  function animate(tm) {
    if (tm - 1000 < tic) {
      requestAnimFrame(animate);
      return;
    }
    tic = tm;
    drawClock();
    requestAnimFrame(animate);
  }

  requestAnimFrame(animate);
});

function openNotificationCenter(){
  document.getElementById("n-r-count").innerHTML = "Notifications <span class=\"caret\"/>";
}

function markAsRead(id){
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
