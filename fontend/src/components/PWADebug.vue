<template>
  <div v-if="showDebug" class="fixed top-4 left-4 bg-black/80 text-white p-4 rounded-lg text-xs max-w-sm z-50">
    <h3 class="font-bold mb-2">PWA Debug Info</h3>
    <div class="space-y-1">
      <p><strong>HTTPS:</strong> {{ isHTTPS ? '✅' : '❌' }}</p>
      <p><strong>Service Worker:</strong> {{ hasServiceWorker ? '✅' : '❌' }}</p>
      <p><strong>Manifest:</strong> {{ hasManifest ? '✅' : '❌' }}</p>
      <p><strong>Standalone:</strong> {{ isStandalone ? '✅' : '❌' }}</p>
      <p><strong>Install Prompt:</strong> {{ hasInstallPrompt ? '✅' : '❌' }}</p>
      <p><strong>User Agent:</strong> {{ userAgent }}</p>
    </div>
    <button @click="showDebug = false" class="mt-2 text-red-400 hover:text-red-300">Close</button>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const showDebug = ref(false)
const isHTTPS = ref(false)
const hasServiceWorker = ref(false)
const hasManifest = ref(false)
const isStandalone = ref(false)
const hasInstallPrompt = ref(false)
const userAgent = ref('')

onMounted(() => {
  // Check HTTPS
  isHTTPS.value = location.protocol === 'https:' || location.hostname === 'localhost'
  
  // Check Service Worker
  if ('serviceWorker' in navigator) {
    navigator.serviceWorker.getRegistration().then(registration => {
      hasServiceWorker.value = !!registration
    })
  }
  
  // Check Manifest
  const manifestLink = document.querySelector('link[rel="manifest"]')
  hasManifest.value = !!manifestLink
  
  // Check Standalone
  isStandalone.value = window.matchMedia('(display-mode: standalone)').matches
  
  // Check Install Prompt
  window.addEventListener('beforeinstallprompt', () => {
    hasInstallPrompt.value = true
  })
  
  // User Agent
  userAgent.value = navigator.userAgent.substring(0, 50) + '...'
  
  // Show debug info after 2 seconds
  setTimeout(() => {
    showDebug.value = true
  }, 2000)
})
</script>


