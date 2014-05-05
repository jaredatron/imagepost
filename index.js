$(function() {

  var textarea = $('.image-post-form .image-post-text');
  var styleSelect = $('.image-post-form .image-post-style');

  textarea.keyup(update);
  styleSelect.change(update);

  function update() {
    var imagePost = new ImagePost({
      text:  textarea.val(),
      style: Number(styleSelect.val()),
    });
    console.log(imagePost);

    var canvas = imagePost.toCanvas();
    $("#canvas-container").html(canvas);

    var image = imagePost.toImage();
    $("#image-container").html(image);

    var html = imagePost.toHTML();
    $("#html-container").html(html);
  };

});
