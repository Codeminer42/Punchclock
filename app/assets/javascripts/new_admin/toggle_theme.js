const bodyTag = document.querySelector('html')

const changeThemeButton = document.querySelector('[data-change-theme]')
const lightThemeIcon = document.querySelector('[data-light-icon]')
const darkThemeIcon = document.querySelector('[data-dark-icon]')

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

const updateThemeIcon = (isDarkTheme) => {
  if (isDarkTheme) {
    darkThemeIcon.classList.add('hidden')
    lightThemeIcon.classList.remove('hidden')
  } else {
    lightThemeIcon.classList.add('hidden')
    darkThemeIcon.classList.remove('hidden')
  }
}

const initTheme = () => {
  const isDarkTheme = isDarkThemeEnabled()
  if (isDarkTheme) bodyTag.classList.add('dark')
  updateThemeIcon(isDarkTheme)
}

initTheme()

changeThemeButton.addEventListener('click', () => {
  const isDarkTheme = isDarkThemeEnabled()
  setDarkTheme(!isDarkTheme)
  bodyTag.classList.toggle('dark')
  updateThemeIcon(!isDarkTheme)
})
