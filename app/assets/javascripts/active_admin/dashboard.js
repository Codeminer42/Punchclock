$(document).ready(function() {
  function filterOptions(option, container) {
    const resource = $('#shortcut-resource').val();
    const optionValue = ($(option.element).val() || '').toString();
    container = $(container);

    if (optionValue.startsWith(resource)) {
      container.show();
      return option.text;
    }

    container.hide();
    return false;
  }

  function updateLink() {
    $('#shortcut-link').attr("href",`/admin/${$('#shortcut-data').val() || ''}`);
  }

  function updateSelectedOption() {
    const resource = $('#shortcut-resource').val();
    const dataSetSelect = $('#shortcut-data');
    
    dataSetSelect.children(`[value^="${resource}"]`).first().prop('selected', true);
    dataSetSelect.select2({ templateResult: filterOptions});
    updateLink();
  }

  $('#shortcut-resource').on('change', updateSelectedOption).select2();
  $('#shortcut-data').on('change', updateLink).select2({ templateResult: filterOptions })

  updateSelectedOption();
  updateLink();
});