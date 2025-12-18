<script setup>
import { ref } from 'vue'
import axios from "axios"
import { EyeIcon, EyeSlashIcon } from "@heroicons/vue/24/outline"
import api from "@/api"

const form = ref({
  firstName: '',
  lastName: '',
  username: '',
  email: '',
  password: '',
  confirmPassword: '',
  phone: '',
  monthlyIncome: '',
  address: '',
  employment: '',
  emergencyContact: '',
  emergencyPhone: ''
})

const isLoading = ref(false)
const error = ref('')
const success = ref('')
const showPassword = ref(false)
const showConfirmPassword = ref(false)

const handleRegistration = async () => {
  error.value = ''
  success.value = ''

  // ✅ check confirm password
  if (form.value.password !== form.value.confirmPassword) {
    error.value = "Passwords don't match."
    return
  }

  isLoading.value = true
  try {
    // ✅ send actual data (use .value)
    await api.post("/auth/register", form.value)

    // fake delay to show loading
    await new Promise(resolve => setTimeout(resolve, 1500))

    success.value = 'Account created successfully! Your registration is pending admin approval. You will receive a notification once approved.'

    // ✅ reset form (clear all fields safely)
    Object.keys(form.value).forEach(key => {
      form.value[key] = ''
    })
  } catch (e) {
    // ✅ show backend error if available
    if (e.response?.data?.message) {
      error.value = e.response.data.message
    } else {
      error.value = 'Something went wrong. Please try again.'
    }
  } finally {
    isLoading.value = false
  }
}
</script>


<template>
  <div class="min-h-screen relative flex items-center justify-center bg-gradient-to-br from-slate-900 via-blue-900 to-indigo-900 p-6 overflow-hidden">
    <!-- Enhanced Background Elements -->
    <div class="absolute inset-0 overflow-hidden pointer-events-none">
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
    <div class="relative z-10 w-full max-w-4xl bg-white/10 backdrop-blur-xl border border-white/20 shadow-2xl rounded-3xl p-10">
      <!-- Enhanced Header -->
      <div class="text-center mb-10">
        <div class="inline-flex items-center justify-center w-16 h-16 bg-gradient-to-br from-blue-500 via-indigo-500 to-purple-600 rounded-2xl mb-6 shadow-2xl shadow-blue-500/25">
          <span class="text-white font-bold text-2xl">F</span>
        </div>
        <h1 class="text-5xl font-black text-white mb-4 tracking-tight">
          Join 
          <span class="text-transparent bg-clip-text bg-gradient-to-r from-blue-400 via-cyan-400 to-emerald-400">FundEase</span>
        </h1>
        <p class="text-xl text-blue-100 font-light">Create your account and start your financial journey</p>
      </div>

      <!-- Enhanced Form -->
      <form @submit.prevent="handleRegistration" class="space-y-8">
        <!-- Personal Information -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <label class="block text-sm font-semibold text-white mb-3">First Name *</label>
            <input v-model="form.firstName" type="text" required placeholder="Enter first name"
              class="w-full px-4 py-4 bg-white/10 border border-white/20 rounded-xl text-white placeholder-blue-200 focus:ring-2 focus:ring-blue-400 focus:border-transparent transition-all duration-300 backdrop-blur-sm" />
          </div>
          <div>
            <label class="block text-sm font-semibold text-white mb-3">Last Name *</label>
            <input v-model="form.lastName" type="text" required placeholder="Enter last name"
              class="w-full px-4 py-4 bg-white/10 border border-white/20 rounded-xl text-white placeholder-blue-200 focus:ring-2 focus:ring-blue-400 focus:border-transparent transition-all duration-300 backdrop-blur-sm" />
          </div>
          <div>
            <label class="block text-sm font-semibold text-white mb-3">Username *</label>
            <input v-model="form.username" type="text" required placeholder="Choose a username"
              class="w-full px-4 py-4 bg-white/10 border border-white/20 rounded-xl text-white placeholder-blue-200 focus:ring-2 focus:ring-blue-400 focus:border-transparent transition-all duration-300 backdrop-blur-sm" />
          </div>
          <div>
            <label class="block text-sm font-semibold text-white mb-3">Email *</label>
            <input v-model="form.email" type="email" required placeholder="Enter your email"
              class="w-full px-4 py-4 bg-white/10 border border-white/20 rounded-xl text-white placeholder-blue-200 focus:ring-2 focus:ring-blue-400 focus:border-transparent transition-all duration-300 backdrop-blur-sm" />
          </div>
          <div>
            <label class="block text-sm font-semibold text-white mb-3">Password *</label>
            <div class="relative">
              <input 
                v-model="form.password" 
                :type="showPassword ? 'text' : 'password'" 
                required 
                placeholder="Create a password"
                class="w-full px-4 py-4 pr-12 bg-white/10 border border-white/20 rounded-xl text-white placeholder-blue-200 focus:ring-2 focus:ring-blue-400 focus:border-transparent transition-all duration-300 backdrop-blur-sm" 
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
          <div>
            <label class="block text-sm font-semibold text-white mb-3">Confirm Password *</label>
            <div class="relative">
              <input 
                v-model="form.confirmPassword" 
                :type="showConfirmPassword ? 'text' : 'password'" 
                required 
                placeholder="Confirm your password"
                class="w-full px-4 py-4 pr-12 bg-white/10 border border-white/20 rounded-xl text-white placeholder-blue-200 focus:ring-2 focus:ring-blue-400 focus:border-transparent transition-all duration-300 backdrop-blur-sm" 
              />
              <button
                type="button"
                @click="showConfirmPassword = !showConfirmPassword"
                class="absolute inset-y-0 right-0 pr-4 flex items-center text-blue-200 hover:text-white transition-colors"
              >
                <EyeIcon v-if="!showConfirmPassword" class="h-5 w-5" />
                <EyeSlashIcon v-else class="h-5 w-5" />
              </button>
            </div>
          </div>
          <div>
            <label class="block text-sm font-semibold text-white mb-3">Phone *</label>
            <input v-model="form.phone" type="tel" required placeholder="Enter phone number"
              class="w-full px-4 py-4 bg-white/10 border border-white/20 rounded-xl text-white placeholder-blue-200 focus:ring-2 focus:ring-blue-400 focus:border-transparent transition-all duration-300 backdrop-blur-sm" />
          </div>
          <div>
            <label class="block text-sm font-semibold text-white mb-3">Monthly Income *</label>
            <input v-model="form.monthlyIncome" type="number" required min="0" step="0.01" placeholder="Enter monthly income"
              class="w-full px-4 py-4 bg-white/10 border border-white/20 rounded-xl text-white placeholder-blue-200 focus:ring-2 focus:ring-blue-400 focus:border-transparent transition-all duration-300 backdrop-blur-sm" />
          </div>
        </div>

        <!-- Address & Employment -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <label class="block text-sm font-semibold text-white mb-3">Address *</label>
            <textarea v-model="form.address" rows="3" required placeholder="Enter your complete address"
              class="w-full px-4 py-4 bg-white/10 border border-white/20 rounded-xl text-white placeholder-blue-200 focus:ring-2 focus:ring-blue-400 focus:border-transparent transition-all duration-300 backdrop-blur-sm"></textarea>
          </div>
          <div>
            <label class="block text-sm font-semibold text-white mb-3">Employment Status *</label>
            <select v-model="form.employment" required
              class="w-full px-4 py-4 bg-white/10 border border-white/20 rounded-xl text-white focus:ring-2 focus:ring-blue-400 focus:border-transparent transition-all duration-300 backdrop-blur-sm">
              <option value="" class="bg-slate-800 text-white">Select employment status</option>
              <option value="Employed" class="bg-slate-800 text-white">Employed</option>
              <option value="Self-employed" class="bg-slate-800 text-white">Self-employed</option>
              <option value="Unemployed" class="bg-slate-800 text-white">Unemployed</option>
              <option value="Student" class="bg-slate-800 text-white">Student</option>
              <option value="Retired" class="bg-slate-800 text-white">Retired</option>
            </select>
          </div>
        </div>

        <!-- Emergency -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <label class="block text-sm font-semibold text-white mb-3">Emergency Contact Name</label>
            <input v-model="form.emergencyContact" type="text" placeholder="Enter emergency contact name"
              class="w-full px-4 py-4 bg-white/10 border border-white/20 rounded-xl text-white placeholder-blue-200 focus:ring-2 focus:ring-blue-400 focus:border-transparent transition-all duration-300 backdrop-blur-sm" />
          </div>
          <div>
            <label class="block text-sm font-semibold text-white mb-3">Emergency Contact Phone</label>
            <input v-model="form.emergencyPhone" type="tel" placeholder="Enter emergency contact phone"
              class="w-full px-4 py-4 bg-white/10 border border-white/20 rounded-xl text-white placeholder-blue-200 focus:ring-2 focus:ring-blue-400 focus:border-transparent transition-all duration-300 backdrop-blur-sm" />
          </div>
        </div>

        <!-- Messages -->
        <div v-if="error" class="text-red-300 text-sm bg-red-500/20 border border-red-400/30 p-4 rounded-xl backdrop-blur-sm">{{ error }}</div>
        <div v-if="success" class="text-green-300 text-sm bg-green-500/20 border border-green-400/30 p-4 rounded-xl backdrop-blur-sm">{{ success }}</div>

        <!-- Submit -->
        <button type="submit" :disabled="isLoading"
          class="w-full bg-gradient-to-r from-blue-500 via-indigo-500 to-purple-600 text-white py-4 px-6 rounded-xl font-bold text-lg hover:from-blue-600 hover:via-indigo-600 hover:to-purple-700 transform hover:scale-105 transition-all duration-300 disabled:opacity-50 disabled:cursor-not-allowed disabled:transform-none shadow-lg hover:shadow-blue-500/25">
          <span v-if="isLoading" class="flex items-center justify-center">
            <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none"
              viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor"
                d="M4 12a8 8 0 018-8V0C5.37 0 0 5.37 0 12h4zm2 5.29A7.96 7.96 0 014 12H0c0 3.04 1.14 5.82 3 7.94l3-2.65z"></path>
            </svg>
            Creating Account...
          </span>
          <span v-else>Create Account</span>
        </button>
      </form>

      <!-- Enhanced Login link -->
      <div class="mt-8 text-center">
        <p class="text-blue-200 text-lg">
          Already have an account?
          <router-link to="/login" class="text-white hover:text-cyan-300 font-bold transition-colors">Sign in here</router-link>
        </p>
      </div>
    </div>
  </div>
</template>

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
