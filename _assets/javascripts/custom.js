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
})

/* Stylize pgn4web elements by Bootstrap */
function customFunctionOnPgnGameLoad() {
  $('#GameSelSelect').addClass('form-control');
  $('#autoplayButton').click(refreshButtonset);
}
function customFunctionOnMove() {
  refreshButtonset();
}
function refreshButtonset() {
  $('#GameButtons input').addClass('btn btn-default');
}
