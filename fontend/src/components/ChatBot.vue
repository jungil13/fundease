<template>
  <div class="fixed bottom-4 right-4 z-50">
    <!-- Chat Toggle Button -->
    <button
      v-if="!isOpen"
      @click="toggleChat"
      class="bg-gradient-to-r from-indigo-600 to-purple-600 text-white p-4 rounded-full shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105"
    >
      <svg v-if="!isTyping" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"></path>
      </svg>
      <div v-else class="w-6 h-6 flex items-center justify-center">
        <div class="animate-spin rounded-full h-4 w-4 border-2 border-white border-t-transparent"></div>
      </div>
    </button>

    <!-- Chat Window -->
    <div
      v-if="isOpen"
      class="bg-white rounded-lg shadow-2xl w-80 h-96 flex flex-col border border-gray-200"
    >
      <!-- Chat Header -->
      <div class="bg-gradient-to-r from-indigo-600 to-purple-600 text-white p-4 rounded-t-lg flex items-center justify-between">
        <div class="flex items-center space-x-2">
          <div class="w-8 h-8 bg-white/20 rounded-full flex items-center justify-center">
            <span class="text-sm font-bold">F</span>
          </div>
          <div>
            <h3 class="font-semibold">FundEase Assistant</h3>
            <p class="text-xs opacity-90">How can I help you?</p>
          </div>
        </div>
        <button @click="toggleChat" class="text-white/80 hover:text-white">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
          </svg>
        </button>
      </div>

      <!-- Chat Messages -->
      <div class="flex-1 overflow-y-auto p-4 space-y-4" ref="chatContainer">
        <div
          v-for="message in messages"
          :key="message.id"
          :class="[
            'flex',
            message.isUser ? 'justify-end' : 'justify-start'
          ]"
        >
          <div
            :class="[
              'max-w-xs px-4 py-2 rounded-lg',
              message.isUser
                ? 'bg-gradient-to-r from-indigo-600 to-purple-600 text-white'
                : 'bg-gray-100 text-gray-800'
            ]"
          >
            <p class="text-sm">{{ message.text }}</p>
            <p class="text-xs opacity-70 mt-1">{{ formatTime(message.timestamp) }}</p>
          </div>
        </div>
        
        <!-- Typing Indicator -->
        <div v-if="isTyping" class="flex justify-start">
          <div class="bg-gray-100 text-gray-800 max-w-xs px-4 py-2 rounded-lg">
            <div class="flex space-x-1">
              <div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce"></div>
              <div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay: 0.1s"></div>
              <div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay: 0.2s"></div>
            </div>
          </div>
        </div>
      </div>

      <!-- Quick Actions -->
      <div v-if="showQuickActions" class="px-4 py-2 border-t border-gray-200">
        <div class="flex flex-wrap gap-2">
          <button
            v-for="action in quickActions"
            :key="action.text"
            @click="sendQuickMessage(action.text)"
            class="text-xs bg-gray-100 hover:bg-gray-200 text-gray-700 px-3 py-1 rounded-full transition-colors"
          >
            {{ action.text }}
          </button>
        </div>
      </div>

      <!-- Chat Input -->
      <div class="p-4 border-t border-gray-200">
        <div class="flex space-x-2">
          <input
            v-model="inputMessage"
            @keyup.enter="sendMessage"
            placeholder="Type your question..."
            class="flex-1 px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent text-sm"
            :disabled="isTyping"
          />
          <button
            @click="sendMessage"
            :disabled="!inputMessage.trim() || isTyping"
            class="bg-gradient-to-r from-indigo-600 to-purple-600 text-white px-4 py-2 rounded-lg hover:opacity-90 disabled:opacity-50 disabled:cursor-not-allowed transition-opacity"
          >
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8"></path>
            </svg>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, nextTick, onMounted } from 'vue'
import { faqData, defaultResponses, quickActions as faqQuickActions } from '@/data/faqData.js'

// Reactive data
const isOpen = ref(false)
const isTyping = ref(false)
const inputMessage = ref('')
const messages = ref([])
const chatContainer = ref(null)
const showQuickActions = ref(true)

// Quick action buttons
const quickActions = ref(faqQuickActions)

// Methods
const toggleChat = () => {
  isOpen.value = !isOpen.value
  if (isOpen.value && messages.value.length === 0) {
    addBotMessage('Hello! I\'m your FundEase assistant. How can I help you today?')
  }
}

const addMessage = (text, isUser = false) => {
  messages.value.push({
    id: Date.now(),
    text,
    isUser,
    timestamp: new Date()
  })
  scrollToBottom()
}

const addBotMessage = (text) => {
  addMessage(text, false)
}

const sendMessage = async () => {
  if (!inputMessage.value.trim()) return
  
  const userMessage = inputMessage.value.trim()
  addMessage(userMessage, true)
  inputMessage.value = ''
  
  // Hide quick actions after first message
  if (showQuickActions.value) {
    showQuickActions.value = false
  }
  
  // Simulate typing
  isTyping.value = true
  await new Promise(resolve => setTimeout(resolve, 1000))
  
  // Find best response
  const response = findBestResponse(userMessage)
  addBotMessage(response)
  isTyping.value = false
}

const sendQuickMessage = (text) => {
  inputMessage.value = text
  sendMessage()
}

const findBestResponse = (message) => {
  const lowerMessage = message.toLowerCase()
  
  // Direct keyword matching
  for (const [keyword, data] of Object.entries(faqData)) {
    if (lowerMessage.includes(keyword)) {
      return data.response
    }
  }
  
  // Enhanced keyword matching using the keywords array
  for (const [key, data] of Object.entries(faqData)) {
    if (data.keywords && data.keywords.some(keyword => lowerMessage.includes(keyword))) {
      return data.response
    }
  }
  
  // Fuzzy matching for common questions
  if (lowerMessage.includes('register') || lowerMessage.includes('sign up') || lowerMessage.includes('join')) {
    return faqData['how to register'].response
  }
  
  if (lowerMessage.includes('login') || lowerMessage.includes('sign in') || lowerMessage.includes('access')) {
    return faqData['how to login'].response
  }
  
  if (lowerMessage.includes('contribution') || lowerMessage.includes('contribute') || lowerMessage.includes('deposit')) {
    return faqData['how to make contribution'].response
  }
  
  if (lowerMessage.includes('loan') || lowerMessage.includes('borrow') || lowerMessage.includes('apply')) {
    return faqData['how to apply for loan'].response
  }
  
  if (lowerMessage.includes('withdraw') || lowerMessage.includes('withdrawal') || lowerMessage.includes('cash out')) {
    return faqData['how to withdraw'].response
  }
  
  if (lowerMessage.includes('balance') || lowerMessage.includes('account') || lowerMessage.includes('money')) {
    return faqData['account balance'].response
  }
  
  if (lowerMessage.includes('password') || lowerMessage.includes('forgot') || lowerMessage.includes('reset')) {
    return faqData['forgot password'].response
  }
  
  if (lowerMessage.includes('contact') || lowerMessage.includes('support') || lowerMessage.includes('help')) {
    return faqData['contact support'].response
  }
  
  if (lowerMessage.includes('payment') || lowerMessage.includes('pay') || lowerMessage.includes('fee')) {
    return faqData['payment methods'].response
  }
  
  if (lowerMessage.includes('statement') || lowerMessage.includes('history') || lowerMessage.includes('report')) {
    return faqData['transaction history'].response
  }
  
  // Default response - randomly select from default responses
  const randomIndex = Math.floor(Math.random() * defaultResponses.length)
  return defaultResponses[randomIndex]
}

const scrollToBottom = () => {
  nextTick(() => {
    if (chatContainer.value) {
      chatContainer.value.scrollTop = chatContainer.value.scrollHeight
    }
  })
}

const formatTime = (timestamp) => {
  return timestamp.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
}

// Initialize chat
onMounted(() => {
  // Auto-open chat after 3 seconds on first visit
  setTimeout(() => {
    if (!localStorage.getItem('fundease-chat-opened')) {
      toggleChat()
      localStorage.setItem('fundease-chat-opened', 'true')
    }
  }, 3000)
})
</script>

<style scoped>
/* Custom scrollbar for chat */
.overflow-y-auto::-webkit-scrollbar {
  width: 4px;
}

.overflow-y-auto::-webkit-scrollbar-track {
  background: #f1f1f1;
}

.overflow-y-auto::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 2px;
}

.overflow-y-auto::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
}
</style>
