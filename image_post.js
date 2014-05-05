ImagePost = function(attributes) {
  this.text  = "";
  for (var p in attributes) this[p] = attributes[p];
  this.style = ImagePost.styles[attributes.style];
};

ImagePost.prototype.toCanvas = function() {
  var fontSize = Number(this.style.fontSize);
  var fontFamily = this.style.fontFamily;
  var text = this.text;

  var canvas = $('<canvas>').attr('height', '510px').attr('width', '510px')[0];
  var context = canvas.getContext("2d");

  context.drawImage(this.style.backgroundImage, 0, 0, 510, 510, 0, 0, 510, 510)

  context.font = fontSize+"px "+fontFamily;
  context.fillStyle = this.style.fontColor;
  context.textAlign = 'center';

  var lines = text.split("\n");
  var top = (510/2) - (fontSize * ((lines.length / 2)-1));
  console.log(top)

  lines.forEach(function(line) {
    context.fillText(line, 510 / 2, top);
    top = top + fontSize;
  });

  // $(canvas).css({'background-image': this.style.backgroundImage});

  return canvas;
};

ImagePost.prototype.toImage = function() {
  var image = new Image;
  image.src = this.toCanvas().toDataURL("image/png");
  return image;
};



ImagePost.prototype.toHTML = function() {

  var node = $(
    '<div class="image-post">'     +
      '<div class="text-wrapper">' +
        '<div class="text"></div>' +
      '</div>'                     +
    '</div>'
  ).addClass('image-post');

  node.css({
    height: '510px',
    width: '510px',
    color: this.style.fontColor,
    backgroundImage: 'url('+this.style.backgroundImage.src+')',
  })

  node.find('.text').text(this.text);

  return node;

};
