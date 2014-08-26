//= require_self

$(document).ready(function () {
  $("li").on("dblclick", function () {
    $(this).toggleClass("expand");
  });
});