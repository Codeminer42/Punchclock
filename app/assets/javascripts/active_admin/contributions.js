$(window).on("load", function () {
  $("a[name=refuse_contribution]").on("click", function () {
    const reasons = Object.values($(this).data("reasons"));
    const id = $(this).data("id");
    ActiveAdmin.ModalDialog(
      "Justificativa:",
      { Motivo: reasons },
      function (inputs) {
        $.ajax({
          url: `/admin/contributions/${id}/refuse`,
          data: JSON.stringify({ rejected_reason: inputs.Motivo }),
          contentType: "application/json; charset=utf-8",
          dataType: "json",
          type: "PUT",
          complete: function (result) {
            window.location.reload();
          },
        });
      }
    );
  });
});
