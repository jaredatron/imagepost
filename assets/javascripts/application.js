//= require "image_post"
//= require "image_post/style"
//= require "image_post/styles"


$(document).on('click', 'a[href=""], a[href="#"]', function(event) {
  event.preventDefault();
});




$(function() {

  var styleIndex = 0;

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
    styleIndex = ImagePost.randomStyleIndex();
    setImagePostFormStyle();
  });

  $(document).on('keyup change', '.image-post-form .image-post-text textarea', function(event) {
    update();
  });


  setImagePostFormStyle();

  function resizeTextarea(textarea, value) {
    textarea.rows = value.split("\n").length || 1;
  };

  function setImagePostFormStyle() {
    var style = ImagePost.styles[styleIndex];
    console.log(style)
    $('.image-post-form .image-post-text-wrapper').css({
      color:           style.fontColor,
      fontSize:        style.fontSize,
      fontFamily:      style.fontFamily,
      backgroundColor: style.backgroundColor ? style.backgroundColor : 'transparent',
      backgroundImage: style.backgroundImageUrl ? 'url('+style.backgroundImageUrl+')' : false,
    });
    update();
  };

  function update() {
    var imagePost = new ImagePost({
      text:  $('.image-post-form .image-post-text textarea').val() || " ",
      styleIndex: styleIndex,
    });

    console.log(imagePost);

    $('.image-post-form input[name="text"]').val(imagePost.text);
    $('.image-post-form input[name="style"]').val(0)
    $('.image-post-form input[name="image"]').val(imagePost.toImageData());

    // var canvas = imagePost.toCanvas();
    // $("#canvas-container").html(canvas);

    var image = imagePost.toImage();
    $(".image-preview").html(image);

    // var html = imagePost.toHTML();
    // $(".html-preview").html(html);
  }

});
