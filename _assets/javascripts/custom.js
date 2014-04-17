$(function() {
  /* Sort a tournament table with tablesorter */
  $('.tablesorter .opponent').addClass('{sorter: false}');
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

  /* Mark commented moves */
  for (var Ply = 1; Ply <= PlyNumberVar[0]; Ply++) {
    if (strippedMoveComment(Ply, 0, true))
      $('#Var0Mv' + Ply).addClass('bg-info');
  }

  /* Show move comment */
  if (CurrentVar == 0 && (theObj = document.getElementById("GameMoveComment"))) {
    theObj.innerHTML = '<span class="comment">' +
      strippedMoveComment(CurrentPly, 0, true) + '</span>';
  }
}
function refreshButtonset() {
  $('#GameButtons input').addClass('btn btn-default');
}
