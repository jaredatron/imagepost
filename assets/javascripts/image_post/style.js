//= require 'image_post'

ImagePost.Style = function(attributes) {
  this.fontColor        = 'white';
  this.fontSize         = '42';
  this.fontFamily       = 'Helvetica';
  this.backgroundImageSrc  = '';

  for (var p in attributes) this[p] = attributes[p];

  this.backgroundImage  = new Image();
  this.backgroundImage.src = this.backgroundImageSrc
};
