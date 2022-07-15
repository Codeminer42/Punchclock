const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.{erb,haml,html,slim}",
  ],
  theme: {
    extend: {
      colors: {
        red: "#C51414",
        blue: "#5285D4",
        grey: {
          50: "#F5F5F5",
          100: "#D6D6D6",
          200: "#C4C4C4",
          300: "#767676",
          400: "#313131",
          500: "#161616",
        },
      },
      fontFamily: {
        sans: ["Lato", "sans-serif", ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/aspect-ratio"),
    require("@tailwindcss/typography"),
  ],
};
