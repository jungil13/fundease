<template>
  <div v-if="showInstallPrompt" class="fixed bottom-4 right-4 z-50">
    <div class="bg-white rounded-lg shadow-lg p-4 max-w-sm border border-gray-200">
      <div class="flex items-start space-x-3">
        <div class="flex-shrink-0">
          <div class="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
            <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 18h.01M8 21h8a2 2 0 002-2V5a2 2 0 00-2-2H8a2 2 0 00-2 2v14a2 2 0 002 2z"></path>
            </svg>
          </div>
        </div>
        <div class="flex-1 min-w-0">
          <h3 class="text-sm font-medium text-gray-900">Install FundEase</h3>
          <p class="text-sm text-gray-500 mt-1">Install this app on your device for quick access and offline functionality.</p>
          <div class="mt-3 flex space-x-2">
            <button
              @click="installApp"
              class="bg-blue-600 text-white px-3 py-1.5 rounded-md text-sm font-medium hover:bg-blue-700 transition-colors"
            >
              Install
            </button>
            <button
              @click="dismissPrompt"
              class="bg-gray-100 text-gray-700 px-3 py-1.5 rounded-md text-sm font-medium hover:bg-gray-200 transition-colors"
            >
              Not now
            </button>
          </div>
        </div>
        <button
          @click="dismissPrompt"
          class="flex-shrink-0 text-gray-400 hover:text-gray-600"
        >
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
          </svg>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const showInstallPrompt = ref(false)
let deferredPrompt = null

onMounted(() => {
  // Check if the app is already installed
  if (window.matchMedia('(display-mode: standalone)').matches) {
    return
  }

  // Listen for the beforeinstallprompt event
  window.addEventListener('beforeinstallprompt', (e) => {
    e.preventDefault()
    deferredPrompt = e
    showInstallPrompt.value = true
    console.log('PWA install prompt available')
  })

  // Listen for the appinstalled event
  window.addEventListener('appinstalled', () => {
    showInstallPrompt.value = false
    deferredPrompt = null
    console.log('PWA installed successfully')
  })

  // Show manual install prompt after a delay if browser prompt doesn't appear
  setTimeout(() => {
    if (!deferredPrompt && !showInstallPrompt.value) {
      // Check if we can show a manual install prompt
      const isIOS = /iPad|iPhone|iPod/.test(navigator.userAgent)
      const isInStandaloneMode = window.matchMedia('(display-mode: standalone)').matches
      
      if (!isInStandaloneMode) {
        showInstallPrompt.value = true
        console.log('Showing manual install prompt')
      }
    }
  }, 5000) // Show after 5 seconds
})

const installApp = async () => {
  if (deferredPrompt) {
    // Use browser's native install prompt
    deferredPrompt.prompt()
    const { outcome } = await deferredPrompt.userChoice
    
    if (outcome === 'accepted') {
      console.log('User accepted the install prompt')
    } else {
      console.log('User dismissed the install prompt')
    }
    
    showInstallPrompt.value = false
    deferredPrompt = null
  } else {
    // Manual install instructions
    const isIOS = /iPad|iPhone|iPod/.test(navigator.userAgent)
    const isAndroid = /Android/.test(navigator.userAgent)
    
    if (isIOS) {
      alert('To install this app on iOS:\n1. Tap the Share button\n2. Scroll down and tap "Add to Home Screen"\n3. Tap "Add"')
    } else if (isAndroid) {
      alert('To install this app on Android:\n1. Tap the menu button (⋮)\n2. Tap "Add to Home Screen" or "Install App"\n3. Tap "Add" or "Install"')
    } else {
      alert('To install this app:\n1. Click the menu button (⋮) in your browser\n2. Look for "Install FundEase" or "Add to Home Screen"\n3. Click to install')
    }
    
    showInstallPrompt.value = false
  }
}

const dismissPrompt = () => {
  showInstallPrompt.value = false
  // Store dismissal in localStorage to avoid showing again for a while
  localStorage.setItem('pwa-install-dismissed', Date.now().toString())
}
</script>
