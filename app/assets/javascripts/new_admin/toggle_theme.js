const bodyTag = document.querySelector('html');

const changeThemeButton = document.querySelector('[data-change-theme]')

changeThemeButton.addEventListener('click', () => {
  bodyTag.classList.toggle('dark')
})
