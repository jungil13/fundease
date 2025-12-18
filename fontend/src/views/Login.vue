<template>
  <div class="relative min-h-screen bg-gradient-to-br from-slate-900 via-blue-900 to-indigo-900 flex items-center justify-center p-4 overflow-hidden">
    <!-- Enhanced Background Elements -->
    <div class="absolute inset-0 pointer-events-none">
      <!-- Main gradient orbs -->
      <div class="absolute -top-40 -right-40 w-96 h-96 bg-gradient-to-br from-blue-500/20 to-cyan-400/20 rounded-full filter blur-3xl animate-blob"></div>
      <div class="absolute -bottom-40 -left-40 w-96 h-96 bg-gradient-to-br from-indigo-500/20 to-purple-400/20 rounded-full filter blur-3xl animate-blob animation-delay-2000"></div>
      <div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-80 h-80 bg-gradient-to-br from-emerald-500/15 to-teal-400/15 rounded-full filter blur-3xl animate-blob animation-delay-4000"></div>
      
      <!-- Floating particles -->
      <div class="absolute top-1/4 left-1/4 w-2 h-2 bg-blue-400 rounded-full animate-float opacity-60"></div>
      <div class="absolute top-1/3 right-1/3 w-3 h-3 bg-cyan-400 rounded-full animate-float animation-delay-1000 opacity-60"></div>
      <div class="absolute bottom-1/4 left-1/3 w-1.5 h-1.5 bg-purple-400 rounded-full animate-float animation-delay-2000 opacity-60"></div>
      <div class="absolute bottom-1/3 right-1/4 w-2.5 h-2.5 bg-emerald-400 rounded-full animate-float animation-delay-3000 opacity-60"></div>
    </div>

    <!-- Enhanced Card -->
    <div class="relative z-10 w-full max-w-md">
      <!-- Enhanced Header -->
      <div class="text-center mb-10">
        <div class="inline-flex items-center justify-center w-16 h-16 bg-gradient-to-br from-blue-500 via-indigo-500 to-purple-600 rounded-2xl mb-6 shadow-2xl shadow-blue-500/25">
          <span class="text-white font-bold text-2xl">F</span>
        </div>
        <h1 class="text-5xl font-black text-white mb-4 tracking-tight">
          Welcome 
          <span class="text-transparent bg-clip-text bg-gradient-to-r from-blue-400 via-cyan-400 to-emerald-400">Back</span>
        </h1>
        <p class="text-xl text-blue-100 font-light">Sign in to your FundEase account</p>
      </div>

      <!-- Enhanced Login Form -->
      <div class="bg-white/10 backdrop-blur-xl border border-white/20 p-10 rounded-3xl shadow-2xl">
        <form @submit.prevent="handleLogin" class="space-y-6">
          <!-- Username -->
          <div>
            <label for="username" class="block text-sm font-semibold text-white mb-3">Username</label>
            <input id="username" v-model="form.username" type="text" required
              class="w-full px-4 py-4 bg-white/10 border border-white/20 rounded-xl text-white placeholder-blue-200 focus:ring-2 focus:ring-blue-400 focus:border-transparent transition-all duration-300 backdrop-blur-sm"
              placeholder="Enter your username" :disabled="isLoading" />
          </div>

          <!-- Password -->
          <div>
            <label for="password" class="block text-sm font-semibold text-white mb-3">Password</label>
            <div class="relative">
              <input 
                id="password" 
                v-model="form.password" 
                :type="showPassword ? 'text' : 'password'" 
                required
                class="w-full px-4 py-4 pr-12 bg-white/10 border border-white/20 rounded-xl text-white placeholder-blue-200 focus:ring-2 focus:ring-blue-400 focus:border-transparent transition-all duration-300 backdrop-blur-sm"
                placeholder="Enter your password" 
                :disabled="isLoading" 
              />
              <button
                type="button"
                @click="showPassword = !showPassword"
                class="absolute inset-y-0 right-0 pr-4 flex items-center text-blue-200 hover:text-white transition-colors"
              >
                <EyeIcon v-if="!showPassword" class="h-5 w-5" />
                <EyeSlashIcon v-else class="h-5 w-5" />
              </button>
            </div>
          </div>

          <!-- Forgot Password -->
          <div class="flex items-center justify-between">
            <div class="flex items-center">
              <input id="remember-me" name="remember-me" type="checkbox" 
                class="h-4 w-4 text-blue-500 focus:ring-blue-400 border-white/30 rounded bg-white/10">
              <label for="remember-me" class="ml-3 block text-sm text-blue-100">
                Remember me
              </label>
            </div>
            <button type="button" @click="showForgotPassword = true"
              class="text-sm text-blue-300 hover:text-white font-medium transition-colors">
              Forgot password?
            </button>
          </div>

          <!-- Error -->
          <div v-if="error" class="text-red-300 text-sm bg-red-500/20 border border-red-400/30 p-4 rounded-xl backdrop-blur-sm">
            {{ error }}
          </div>

          <!-- Success -->
          <div v-if="success" class="text-green-300 text-sm bg-green-500/20 border border-green-400/30 p-4 rounded-xl backdrop-blur-sm">
            {{ success }}
          </div>

          <!-- Submit -->
          <button type="submit" :disabled="isLoading"
            class="w-full bg-gradient-to-r from-blue-500 via-indigo-500 to-purple-600 text-white py-4 px-6 rounded-xl font-bold text-lg hover:from-blue-600 hover:via-indigo-600 hover:to-purple-700 transform hover:scale-105 transition-all duration-300 disabled:opacity-50 disabled:cursor-not-allowed disabled:transform-none shadow-lg hover:shadow-blue-500/25">
            <span v-if="isLoading" class="flex items-center justify-center">
              <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none"
                viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor"
                  d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z">
                </path>
              </svg>
              Signing in...
            </span>
            <span v-else>Sign In</span>
          </button>
        </form>

        <!-- Enhanced Demo Accounts -->
        <div class="mt-8 p-6 bg-white/5 border border-white/10 rounded-2xl backdrop-blur-sm">
          <button 
            type="button"
            @click="showDemoAccounts = !showDemoAccounts"
            class="flex items-center justify-between w-full text-left text-sm font-bold text-white"
          >
            Demo Accounts
            <svg 
              :class="{'rotate-180': showDemoAccounts}" 
              class="w-5 h-5 transform transition-transform duration-200 text-blue-300" 
              fill="none" 
              stroke="currentColor" 
              viewBox="0 0 24 24" 
              xmlns="http://www.w3.org/2000/svg"
            >
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                d="M19 9l-7 7-7-7" />
            </svg>
          </button>

          <div v-if="showDemoAccounts" class="mt-4 space-y-3">
            <button 
              v-for="account in demoAccounts" 
              :key="account.username" 
              @click="fillDemoAccount(account)"
              class="w-full text-left p-4 bg-white/10 hover:bg-white/20 rounded-xl text-sm text-blue-100 transition-all duration-300 border border-white/10 hover:border-white/20 backdrop-blur-sm"
            >
              <div class="font-semibold text-white text-base">{{ account.displayName }}</div>
              <div class="text-blue-200 text-sm mt-1">{{ account.username }} / {{ account.password }}</div>
              <div class="text-blue-300 capitalize text-xs mt-1">{{ account.role.replace('_', ' ') }}</div>
            </button>
          </div>
        </div>

        <!-- Enhanced Register Link -->
        <div class="mt-8 text-center">
          <p class="text-blue-200 text-lg">
            Don't have an account?
            <router-link to="/register" class="text-white hover:text-cyan-300 font-bold transition-colors">
              Register here
            </router-link>
          </p>
        </div>
      </div>
    </div>

    <!-- Enhanced Forgot Password Modal -->
    <div v-if="showForgotPassword" class="fixed inset-0 bg-black/50 backdrop-blur-sm overflow-y-auto h-full w-full z-50">
      <div class="relative top-20 mx-auto p-6 w-11/12 md:w-1/2 lg:w-1/3 shadow-2xl rounded-2xl bg-white/10 backdrop-blur-xl border border-white/20">
        <div class="mt-3">
          <div class="flex items-center justify-between mb-6">
            <h3 class="text-2xl font-bold text-white">Reset Password</h3>
            <button @click="showForgotPassword = false" class="text-blue-200 hover:text-white transition-colors">
              <XMarkIcon class="h-6 w-6" />
            </button>
          </div>
          
          <form @submit.prevent="handleForgotPassword" class="space-y-6">
            <div>
              <label for="email" class="block text-sm font-semibold text-white mb-3">Email Address</label>
              <input 
                id="email" 
                v-model="forgotPasswordForm.email" 
                type="email" 
                required
                class="w-full px-4 py-4 bg-white/10 border border-white/20 rounded-xl text-white placeholder-blue-200 focus:ring-2 focus:ring-blue-400 focus:border-transparent transition-all duration-300 backdrop-blur-sm"
                placeholder="Enter your email address"
              />
            </div>
            
            <div v-if="forgotPasswordError" class="text-red-300 text-sm bg-red-500/20 border border-red-400/30 p-4 rounded-xl backdrop-blur-sm">
              {{ forgotPasswordError }}
            </div>
            
            <div v-if="forgotPasswordSuccess" class="text-green-300 text-sm bg-green-500/20 border border-green-400/30 p-4 rounded-xl backdrop-blur-sm">
              {{ forgotPasswordSuccess }}
            </div>
            
            <div class="flex space-x-4">
              <button 
                type="button" 
                @click="showForgotPassword = false"
                class="flex-1 bg-white/10 border border-white/20 text-white px-6 py-3 rounded-xl hover:bg-white/20 transition-all duration-300 backdrop-blur-sm"
              >
                Cancel
              </button>
              <button 
                type="submit" 
                :disabled="forgotPasswordLoading"
                class="flex-1 bg-gradient-to-r from-blue-500 to-purple-600 text-white px-6 py-3 rounded-xl hover:from-blue-600 hover:to-purple-700 disabled:opacity-50 transition-all duration-300 shadow-lg"
              >
                {{ forgotPasswordLoading ? 'Sending...' : 'Send Reset Link' }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref } from "vue"
import { useRouter } from "vue-router"
import api from "@/api"
import { useAuthStore } from "@/stores/auth"
import { EyeIcon, EyeSlashIcon, XMarkIcon } from "@heroicons/vue/24/outline"

const router = useRouter()
const authStore = useAuthStore()

const form = ref({
  username: "",
  password: ""
})

const showDemoAccounts = ref(false)

const isLoading = ref(false)
const error = ref("")
const success = ref("")
const showPassword = ref(false)

// Forgot Password
const showForgotPassword = ref(false)
const forgotPasswordForm = ref({
  email: ""
})
const forgotPasswordLoading = ref(false)
const forgotPasswordError = ref("")
const forgotPasswordSuccess = ref("")

const demoAccounts = ref([
  { username: "admin", displayName: "Administrator", role: "admin", password: "admin" },
  { username: "treasurer", displayName: "Treasurer", role: "treasurer", password: "123456" },
  { username: "committee", displayName: "Committee Member", role: "screening_committee", password: "123456" },
  { username: "john_doe", displayName: "John Doe", role: "member", password: "password123" },
  { username: "jane_smith", displayName: "Jane Smith", role: "member", password: "password123" },
  { username: "mike_wilson", displayName: "Mike Wilson", role: "member", password: "password123" },
  { username: "sarah_jones", displayName: "Sarah Jones", role: "member", password: "password123" },
  { username: "david_brown", displayName: "David Brown", role: "member", password: "password123" },
  { username: "lisa_davis", displayName: "Lisa Davis", role: "member", password: "password123" },
  { username: "tom_miller", displayName: "Tom Miller", role: "member", password: "password123" },
  { username: "emma_taylor", displayName: "Emma Taylor", role: "member", password: "password123" }
])

async function handleLogin() {
  isLoading.value = true
  error.value = ""
  success.value = ""

  try {
    // ✅ Call backend login API using the configured API instance
    const res = await api.post("/auth/login", {
      username: form.value.username,
      password: form.value.password
    })

    const token = res.data.token
    const user = res.data.user || {} // fallback to empty object

    if (!token || !user.role) {
      throw new Error("Invalid login response. Missing token or role.")
    }

    // ✅ Use auth store to save token + user
    authStore.loginSuccess(token, user)

    // ✅ Map database roles to router paths
    let routerPath = user.role
    if (user.role === 'screening_committee') {
      routerPath = 'committee'  // ← map to the correct route
    }

    // ✅ Redirect based on the corrected path
    router.push(`/${routerPath}/dashboard`)
  } catch (err) {
    console.error("Login error:", err)
    error.value = err.response?.data?.message || err.message || "Invalid username or password."
  } finally {
    isLoading.value = false
  }
}

function fillDemoAccount(account) {
    form.value.username = account.username
  form.value.password = account.password
}

async function handleForgotPassword() {
  forgotPasswordLoading.value = true
  forgotPasswordError.value = ""
  forgotPasswordSuccess.value = ""

  try {
    const res = await api.post("/auth/forgot-password", {
      email: forgotPasswordForm.value.email
    })

    forgotPasswordSuccess.value = res.data.message || "Password reset link sent to your email"
    
    // Clear form after success
    setTimeout(() => {
      showForgotPassword.value = false
      forgotPasswordForm.value.email = ""
      forgotPasswordSuccess.value = ""
    }, 3000)
  } catch (err) {
    forgotPasswordError.value = err.response?.data?.message || "Failed to send reset link"
  } finally {
    forgotPasswordLoading.value = false
  }
}
</script>
<style scoped>
.animate-blob {
  animation: blob 7s infinite;
}

.animation-delay-2000 {
  animation-delay: 2s;
}

.animation-delay-4000 {
  animation-delay: 4s;
}

.animation-delay-1000 {
  animation-delay: 1s;
}

.animation-delay-3000 {
  animation-delay: 3s;
}

.animate-float {
  animation: float 6s ease-in-out infinite;
}

@keyframes blob {
  0% {
    transform: translate(0px, 0px) scale(1);
  }
  33% {
    transform: translate(30px, -50px) scale(1.1);
  }
  66% {
    transform: translate(-20px, 20px) scale(0.9);
  }
  100% {
    transform: translate(0px, 0px) scale(1);
  }
}

@keyframes float {
  0%, 100% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(-20px);
  }
}
</style>
