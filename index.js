ImagePost = function() {
  this.attr('font-size', 20);
  this.attr('font-family', 'Georgia');
};

ImagePost.prototype.attr = function(attribute, value) {
  var property = '_'+attribute;
  if (arguments.length > 1){
    this[property] = value;
    return this;
  }
  return this[property];
};

ImagePost.prototype.toCanvas = function() {
  var fontSize = this.attr('font-size');
  var fontFamily = this.attr('font-family');
  var top = 50;
  var text = this.attr('text');

  var canvas = $('<canvas>')[0];
  var context = canvas.getContext("2d");

  context.font = fontSize+"px "+fontFamily;
  text.split("\n").forEach(function(line) {
    context.fillText(line, 10, top);
    top = top + fontSize;
  });
  return canvas;
};

ImagePost.prototype.toImage = function() {
  var image = new Image;
  image.src = this.toCanvas().toDataURL("image/png");
  return image;
};


$(function() {

  imagePost = new ImagePost;

  $('#input').keyup(function(event) {
    update($(this).val());
  });

  function update(text) {
    imagePost.attr('text', text);
    var canvas = imagePost.toCanvas();
    $("#canvas-container").html(canvas);
    var image = imagePost.toImage();
    $("#image-container").html(image);
  };

});
