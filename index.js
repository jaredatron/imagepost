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

    imagePost.attr('text', $(this).val());
    var canvas = imagePost.toCanvas();
    $("#canvas-container").html(canvas);
    var image = imagePost.toImage();
    $("#image-container").html(image);



  });

});



function update(text){
  var fontSize = 20;
  var canvas = $('<canvas>')[0];
  var context = canvas.getContext("2d");
  var top = 50;

  context.font = fontSize+"px Georgia";
  text.split("\n").forEach(function(line) {
    context.fillText(line, 10, top);
    top = top + fontSize;
  });



  // var textSize = context.measureText(text);
  // console.log('height', textSize.height);
  // console.log('width', textSize.width);

  $("#canvas-container").html(canvas);

  var image = new Image;
  image.src = canvas.toDataURL("image/png");
  $("#image-container").html(image);
}

