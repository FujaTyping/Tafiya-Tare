// @ts-check
import { defineConfig, fontProviders } from 'astro/config';

import cloudflare from '@astrojs/cloudflare';

import tailwindcss from '@tailwindcss/vite';

// https://astro.build/config
export default defineConfig({
  output: 'server',
  adapter: cloudflare(),

  vite: {
    plugins: [tailwindcss()]
  },

  fonts: [{
    provider: fontProviders.fontsource(),
    name: "Roboto Condensed",
    cssVariable: "--font-roboto-condensed",
  }]
});