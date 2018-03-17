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
    return paintIt(this, $(this).data("background-color"), $(this).data("text-color"));
  });
});
