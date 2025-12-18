import { fileURLToPath, URL } from 'node:url'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import vueDevTools from 'vite-plugin-vue-devtools'
import tailwindcss from '@tailwindcss/vite'
import { VitePWA } from 'vite-plugin-pwa'

// https://vite.dev/config/
export default defineConfig({
  server: {
    host: "0.0.0.0",  // expose to your LAN and tunnels
    port: 5173,
    hmr: {
      port: 5173
    },
    // Enable HTTPS for PWA testing
    https: false, // Set to true if you have SSL certificates
    // For development, you can use: npm install -g local-ssl-proxy
    // Then run: local-ssl-proxy --source 5174 --target 5173
  },
  plugins: [
    vue(),
    // vueDevTools(), // Disabled to avoid 404 errors
    tailwindcss(),
    VitePWA({
      registerType: 'autoUpdate',
      includeAssets: ['favicon.ico', 'manifest.json', 'icon.svg', 'screenshot-wide.png', 'screenshot-narrow.png'],
      workbox: {
        globPatterns: ['**/*.{js,css,html,ico,png,svg,json}'],
        navigateFallback: '/offline.html'
      }
    })
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    },
  },
})
