$(function() {

  var textarea = $('.image-post-form .image-post-text textarea');
  var styleSelect = $('.image-post-form .image-post-style');

  $('.image-post-form').click(function() {
    textarea.focus();
  });

  textarea.on('keyup', function(event) {
    this.rows = this.value.split("\n").length || 1;
  });

  textarea.keyup(update);
  styleSelect.change(update);

  textarea.keyup();

  function update() {
    var imagePost = new ImagePost({
      text:  textarea.val() || " ",
      style: Number(styleSelect.val()),
    });

    $('.image-post-form .image-post-text-wrapper').css({
      color:           imagePost.style.fontColor,
      backgroundImage: 'url('+imagePost.style.backgroundImage.src+')',
    });

    var canvas = imagePost.toCanvas();
    $("#canvas-container").html(canvas);

    var image = imagePost.toImage();
    $("#image-container").html(image);

    var html = imagePost.toHTML();
    $("#html-container").html(html);
  };

});
