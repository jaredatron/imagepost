$(function() {

  $('.image-post-form').click(function() {
    $(this).find('.image-post-text textarea').focus();
  });

  $('.image-post-form .image-post-text textarea').on('keydown', function(event) {
    var selectionStart = this.selectionStart || 0;
    var value = this.value;

    if (event.keyCode === 8 || event.keyCode === 46){
      value = value.slice(0,selectionStart-1) + value.slice(selectionStart);
    }else{
      var character = event.keyCode === 13 ? "\n" : String.fromCharCode(event.keyCode);
      value = value.slice(0,selectionStart) + character + value.slice(selectionStart);
    }

    this.rows = value.split("\n").length || 1;
  });

});
