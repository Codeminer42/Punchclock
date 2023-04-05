$(document).ready(function () {
  const dateColumnPosition = 2
  const hiddenTimeColumnPosition = 7
  
  $('#allocations_chart').DataTable({
    paging: false,
    info: false,
    columnDefs: [
      {
        targets: dateColumnPosition,
        orderData: hiddenTimeColumnPosition
      },
      {
        targets: hiddenTimeColumnPosition,
        type: 'num',
        visible: false
      }
    ]
  });
});
