const menus = Array.from(document.querySelectorAll('[data-menu="submenu"]'));

menus.forEach((menu) => {
  menu.addEventListener("click", () => {
    const subMenu = menu.nextElementSibling;
    const arrowIcon = menu.querySelector('[data-icon="arrow"]');

    subMenu.classList.toggle("hidden");
    arrowIcon.classList.toggle("rotate-180");
  });
});
