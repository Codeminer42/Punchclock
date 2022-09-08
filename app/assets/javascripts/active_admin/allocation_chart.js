$(document).ready(function () {
  const dateColumnPosition = 2
  const hiddenTimeColumnPosition = 7
  const nameColumnPosition = 0
  
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
      },
      {
        targets: nameColumnPosition,
        orderData: hiddenTimeColumnPosition
      }
    ]
  });
});
