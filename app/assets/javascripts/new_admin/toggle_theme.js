const bodyTag = document.querySelector('html')

const changeThemeButton = document.querySelector('[data-change-theme]')

const isDarkThemeEnabled = () => {
  if (window.localStorage.getItem('dark-theme')) {
    return JSON.parse(window.localStorage.getItem('dark-theme'))
  }

  if (window.matchMedia)
    return window.matchMedia('(prefers-color-scheme: dark)').matches

  return false
}

const setDarkTheme = (active) => {
  window.localStorage.setItem('dark-theme', active)
}

const initTheme = () => {
  const isDarkTheme = isDarkThemeEnabled()
  if (isDarkTheme) bodyTag.classList.add('dark')
}

initTheme()

changeThemeButton.addEventListener('click', () => {
  const isDarkTheme = isDarkThemeEnabled()
  setDarkTheme(!isDarkTheme)
  bodyTag.classList.toggle('dark')
})
