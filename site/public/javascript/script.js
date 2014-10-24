$(document).ready(function(){

  $('.footnote, .footnote-container').hide();

  $('.comment').click(function(e){
    e.preventDefault();
    $('.footnote, .footnote-container').hide();
    var noteNumber = getNoteNumber(this, 'comment');
    footnote = $('.footnote[data-comment="' + noteNumber + '"]')[0];
    $('.footnote-container').show();
    $(footnote).show();
  });

  $('.alternative').click(function(e){
    e.preventDefault();
    $('.footnote, .footnote-container').hide();
    var noteNumber = getNoteNumber(this, 'alternative');
    footnote = $('.footnote[data-alternative="' + noteNumber + '"]')[0];
    $('.footnote-container').show();
    $(footnote).show();
  });

  getNoteNumber = function(element, type){
    return $(element).data(type)    
  };


  $('.close-footnote a').click(function(e){
    e.preventDefault();
    $('.footnote, .footnote-container').hide();
  });

});
