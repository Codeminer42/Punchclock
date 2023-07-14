window.addEventListener("DOMContentLoaded", (_) => {
  const inputs = document.querySelectorAll('[data-mask="month_and_year"]');

  inputs.forEach(($input) => {
    $input.addEventListener(
      "input",
      (e) => {
        e.target.value = monthAndYear(e.target.value);
      },
      false
    );
  });
});

const monthAndYear = (value) => {
  return value
    .replace(/\D/g, "")
    .replace(/(\d{2})(\d)/, "$1/$2")
    .replace(/(\/\d{4})\d+?$/, "$1");
};
