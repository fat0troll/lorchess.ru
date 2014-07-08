$(function() {
  /* Convert score to numeric number for sorting */
  $.tablesorter.addParser({
    id: 'score',
    format: function(s, table, cell, cellIndex) {
      return s.replace(/½/,'.5');
    },
    type: 'numeric'
  });

  /* Sort a tournament table with tablesorter */
  $('.tablesorter th.score').data('sorter', false);
  $('.tablesorter th.total').data('sorter', 'score');
  $('.tablesorter').tablesorter({
    theme       : 'blue',
    widgets     : ['zebra'],
    sortReset   : true,
    sortRestart : true
  });

  /* Navigate through game moves by mouse wheel over the chess board */
  $('#GameBoard').mousewheel(function(event) {
    if (event.deltaY == -1) {
      $('#forwardButton').click();
    } else if (event.deltaY == 1) {
      $('#backButton').click();
    }
    event.stopPropagation();
    return false;
  });
})

/* Stylize pgn4web elements by Bootstrap */
function customFunctionOnPgnGameLoad() {
  $('#GameSelSelect').addClass('form-control');
  $('#autoplayButton').click(refreshButtonset);

  /* No titles for mouse wheel over the chess board */
  $('#GameBoard .pieceImage').removeAttr('title');
}
function customFunctionOnMove() {
  refreshButtonset();
}
function refreshButtonset() {
  $('#GameButtons input').addClass('btn btn-default');
}
