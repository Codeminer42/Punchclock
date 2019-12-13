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
})
