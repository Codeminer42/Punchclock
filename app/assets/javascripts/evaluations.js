$(window).on('load', function() {
  show_questionnaire_kinds();
  show_tooltip();
});

function show_tooltip() {
  $('[data-toggle="tooltip"]').tooltip()
}

function show_questionnaire_kinds() {
  $('a[name=new-evaluation]').on('ajax:success', function(event) {
    xhr_with_questionnaires_modal = event.detail[2];
    $('[data-modal=questionnaire-kinds]').append(xhr_with_questionnaires_modal.responseText);

    $('#selectFormModal').modal('show');
  });
}
