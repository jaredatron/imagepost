ImagePost = function() {
  // this.attr  = new Attributes;
  // this.attr('style', 'white')
  // this.style = new ImagePost.Style(this);
};

ImagePost.prototype.style = function() {


};


ImagePost.prototype.toCanvas = function() {
  var fontSize = Number(this.attr('font-size'));
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
