$(document).ready(function() {
    var deactivateAndClearUserSpecialtyAndLevel = function() {
        $("#user_specialty, #user_level").prop("disabled", true);
        $("#user_specialty, #user_level").val("");
    }
    
    var activateUserSpecialtyAndLevel = function() {
        $("#user_specialty, #user_level").prop("disabled", false);
    }

    if ($("#user_occupation_administrative").is(":checked")) {
        deactivateAndClearUserSpecialtyAndLevel();
    }
    
    $("#user_occupation_administrative").on('click', deactivateAndClearUserSpecialtyAndLevel);
    $("#user_occupation_engineer").on('click', activateUserSpecialtyAndLevel);

    $('#user_roles').select2({
        closeOnSelect: false
    });

    $('#user_city_id').select2({
        allowClear: true,
        tags: true
    });

    // hack to fix jquery focus when you have a select2 set as "multiple" in the same page
    $(document).on('select2:open', () => {
        document.querySelector('[aria-controls="select2-user_city_id-results"]').focus();
    });
})
