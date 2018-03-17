//= require jquery3

// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

this.paintIt = function(element, backgroundColor, textColor) {
  element.style.backgroundColor = backgroundColor;
  if ( textColor != null ) {
    element.style.color = textColor;
  }
}

$(function() {
  return $("a[data-background-color]").click(function(e) {
    var backgroundColor, textColor;
    e.preventDefault();
    backgroundColor = $(this).data("background-color");
    textColor = $(this).data("text-color");
    return paintIt(this, $(this).data("background-color"), $(this).data("text-color"));
  });
});

$(document).ready(function() {
  return $("#new_article").on("ajax:success", function(e, data, status, xhr) {
    return $("#new_article").append(xhr.responseText);
  }).on("ajax:error", function(e, xhr, status, error) {
    return $("#new_article").append("<p>ERROR</p>");
  });
});

