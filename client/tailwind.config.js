/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        whatsapp: {
          primary: '#00A884',
          dark: '#111B21',
          sidebar: '#111B21',
          header: '#202C33',
          bubble: '#202C33',
          'bubble-out': '#005C4B',
          text: '#E9EDEF',
          'text-secondary': '#8696A0',
          input: '#2A3942',
          separator: '#313D45',
        },
      },
    },
  },
  plugins: [],
};
