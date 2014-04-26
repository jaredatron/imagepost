$(function() {

  $('#input').keyup(function(event) {

    update($(this).val());

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

