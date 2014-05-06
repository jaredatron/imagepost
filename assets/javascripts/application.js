//= require "image_post"
//= require "image_post/style"
//= require "image_post/styles"


$(document).on('click', 'a[href=""], a[href="#"]', function(event) {
  event.preventDefault();
});




$(function() {

  $(document).on('click', '.image-post-form', function() {
    $(this).find('.image-post-text textarea').focus();
  });

  $(document).on('keydown', '.image-post-form .image-post-text textarea', function(event) {
    var selectionStart = this.selectionStart || 0;
    var value = this.value;

    if (event.keyCode === 8 || event.keyCode === 46){
      value = value.slice(0,selectionStart-1) + value.slice(selectionStart);
    }else{
      var character = event.keyCode === 13 ? "\n" : String.fromCharCode(event.keyCode);
      value = value.slice(0,selectionStart) + character + value.slice(selectionStart);
    }

    resizeTextarea(this, value)
  });

  $(document).on('paste cut', '.image-post-form .image-post-text textarea', function(event) {
    setTimeout(function() { resizeTextarea(this, this.value); }.bind(this), 1);
  });

  $(document).on('click', '.image-post-form .random-style-button', function() {
    setImagePostFormStyle(ImagePost.randomStyle());
  });

  setImagePostFormStyle(ImagePost.styles[1]);


  function resizeTextarea(textarea, value) {
    textarea.rows = value.split("\n").length || 1;
  };


  function setImagePostFormStyle(style) {
    $('.image-post-form .image-post-text-wrapper').css({
      color:           style.fontColor,
      backgroundColor: style.backgroundColor || "transparent",
      backgroundImage: 'url('+style.backgroundImage.src+')',
    });
  };

});
