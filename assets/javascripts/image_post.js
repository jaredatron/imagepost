ImagePost = function(attributes) {
  this.text  = "";
  for (var p in attributes) this[p] = attributes[p];
  this.style = ImagePost.styles[this.styleIndex];
};

ImagePost.prototype.toCanvas = function() {
  if (this.canvas) return this.canvas;

  var fontSize = Number(this.style.fontSize);
  var fontFamily = this.style.fontFamily;
  var text = this.text;

  var canvas = $('<canvas>').attr('height', '510px').attr('width', '510px')[0];
  var context = canvas.getContext("2d");

  if (this.style.backgroundColor){
    context.fillStyle = this.style.backgroundColor;
    context.fillRect(0,0,510,510);
  }

  if (this.style.backgroundImage){
    context.drawImage(this.style.backgroundImage, 0, 0, 510, 510, 0, 0, 510, 510);
  }

  context.font = fontSize+"px "+fontFamily;
  context.fillStyle = this.style.fontColor;
  context.textAlign = 'center';

  var lines = text.split("\n");
  var top = (510/2) - (fontSize * ((lines.length / 2)-1));

  lines.forEach(function(line) {
    context.fillText(line, 510 / 2, top);
    top = top + fontSize;
  });

  this.canvas = canvas;

  return canvas;
};

ImagePost.prototype.toImageData = function() {
  return this.toCanvas().toDataURL("image/png");
};


ImagePost.prototype.toImage = function() {
  var image = new Image;
  image.src = this.toImageData();
  return image;
};



ImagePost.prototype.toHTML = function() {

  var node = $(
    '<div class="image-post">'     +
      '<div class="text-wrapper">' +
        '<div class="text"></div>' +
      '</div>'                     +
    '</div>'
  );

  node.css({
    height:          '510px',
    width:           '510px',
    color:           this.style.fontColor,
    fontSize:        this.style.fontSize,
    fontFamily:      this.style.fontFamily,
    backgroundColor: this.style.backgroundColor ? this.style.backgroundColor : 'transparent',
    backgroundImage: this.style.backgroundImageUrl ? 'url('+this.style.backgroundImageUrl+')' : false,
  })

  node.find('.text').text(this.text);

  return node;

};
