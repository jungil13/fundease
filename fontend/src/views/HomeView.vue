<script setup>
import { ref, onMounted } from 'vue'

// Heroicons imports
import {
  UsersIcon,
  BanknotesIcon,
  BuildingLibraryIcon,
  StarIcon,
  CreditCardIcon,
  ArrowTrendingUpIcon,
  ShieldCheckIcon,
  DevicePhoneMobileIcon,
  BoltIcon,
  ChartPieIcon,
} from '@heroicons/vue/24/solid'

import {
  BanknotesIcon as OutlineBanknotesIcon,
  ArrowUpRightIcon,
  UserPlusIcon,
} from '@heroicons/vue/24/outline'

// Reactive data for animations
const stats = ref([
  { number: '500+', label: 'Active Members', icon: UsersIcon },
  { number: '₱2.5M+', label: 'Total Contributions', icon: BanknotesIcon },
  { number: '₱1.8M+', label: 'Loans Disbursed', icon: BuildingLibraryIcon },
  { number: '98%', label: 'Satisfaction Rate', icon: StarIcon },
])

const features = ref([
  {
    icon: OutlineBanknotesIcon,
    title: 'Smart Contributions',
    description:
      'Track and manage member contributions with automated calculations and reporting.',
    color: 'from-blue-500 to-blue-600',
  },
  {
    icon: BuildingLibraryIcon,
    title: 'Easy Loans',
    description:
      'Streamlined loan application and approval process with built-in risk assessment.',
    color: 'from-green-500 to-green-600',
  },
  {
    icon: ChartPieIcon,
    title: 'Real-time Reports',
    description:
      'Comprehensive financial reports and analytics to make informed decisions.',
    color: 'from-purple-500 to-purple-600',
  },
  {
    icon: ShieldCheckIcon,
    title: 'Secure Transactions',
    description:
      'Bank-level security with encrypted data and secure payment processing.',
    color: 'from-red-500 to-red-600',
  },
  {
    icon: DevicePhoneMobileIcon,
    title: 'Mobile Friendly',
    description: 'Access your account anywhere with our responsive mobile interface.',
    color: 'from-indigo-500 to-indigo-600',
  },
  {
    icon: BoltIcon,
    title: 'Fast Processing',
    description:
      'Quick approval times and instant notifications for all transactions.',
    color: 'from-yellow-500 to-yellow-600',
  },
])

const testimonials = ref([
  {
    name: 'Maria Santos',
    role: 'Member since 2020',
    content:
      'FundEase has made managing my contributions so much easier. The interface is intuitive and the support is excellent.',
    avatar: '👩‍💼',
  },
  {
    name: 'John Dela Cruz',
    role: 'Business Owner',
    content:
      'The loan process was smooth and fast. I got approved within 24 hours and the funds were in my account the next day.',
    avatar: '👨‍💼',
  },
  {
    name: 'Ana Rodriguez',
    role: 'Teacher',
    content:
      'I love the real-time reports and notifications. It keeps me informed about all my financial activities.',
    avatar: '👩‍🏫',
  },
])

const isVisible = ref(false)

onMounted(() => {
  isVisible.value = true
})
</script>

<template>
  <div class="min-h-screen bg-gradient-to-br from-slate-900 via-blue-900 to-indigo-900 overflow-hidden">
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

    <!-- Hero Section -->
    <div class="relative min-h-screen flex items-center justify-center p-4">
      <div class="relative z-10 w-full max-w-7xl text-center">
        <div class="mb-20" :class="{ 'animate-fade-in-up': isVisible }">
          <!-- Enhanced Logo -->
          <div class="inline-flex items-center justify-center w-24 h-24 bg-gradient-to-br from-blue-500 via-indigo-500 to-purple-600 rounded-3xl mb-10 shadow-2xl shadow-blue-500/25 animate-pulse">
            <BuildingLibraryIcon class="w-14 h-14 text-white" />
          </div>
          
          <!-- Enhanced Typography -->
          <h1 class="text-5xl md:text-6xl font-black text-white mb-6 leading-tight tracking-tight">
            Welcome to
            <span class="block text-transparent bg-clip-text bg-gradient-to-r from-blue-400 via-cyan-400 to-emerald-400 animate-gradient">
              FundEase
            </span>
          </h1>
          
          <p class="text-xl md:text-2xl text-blue-100 max-w-3xl mx-auto leading-relaxed font-light">
            Your trusted sinking fund management platform for managing
            <span class="text-white font-medium">contributions</span>, 
            <span class="text-white font-medium">loans</span>, and 
            <span class="text-white font-medium">withdrawals</span> with ease and security.
          </p>
        </div>

        <!-- Enhanced Statistics Cards -->
        <div
          class="grid grid-cols-2 md:grid-cols-4 gap-6 mb-16"
          :class="{ 'animate-fade-in-up': isVisible }"
          style="animation-delay: 0.2s"
        >
          <div
            v-for="(stat, index) in stats"
            :key="index"
            class="group bg-white/10 backdrop-blur-xl border border-white/20 p-6 rounded-2xl shadow-2xl hover:shadow-blue-500/25 transition-all duration-500 hover:scale-105 hover:bg-white/15"
          >
            <div class="flex flex-col items-center text-center">
              <div class="w-12 h-12 bg-gradient-to-br from-blue-500 to-cyan-400 rounded-xl flex items-center justify-center mb-3 group-hover:scale-110 transition-transform duration-300 shadow-lg">
                <component :is="stat.icon" class="w-6 h-6 text-white" />
              </div>
              <div class="text-3xl font-black text-white mb-1 tracking-tight">
                {{ stat.number }}
              </div>
              <div class="text-blue-200 font-medium text-xs uppercase tracking-wider">{{ stat.label }}</div>
            </div>
          </div>
        </div>

        <!-- Enhanced Call-to-Action Buttons -->
        <div
          class="space-y-6"
          :class="{ 'animate-fade-in-up': isVisible }"
          style="animation-delay: 0.4s"
        >
          <div class="flex flex-col sm:flex-row gap-4 justify-center">
            <router-link
              to="/login"
              class="group bg-gradient-to-r from-blue-500 via-indigo-500 to-purple-600 text-white px-10 py-4 rounded-2xl font-bold text-lg hover:from-blue-600 hover:via-indigo-600 hover:to-purple-700 transform hover:scale-105 transition-all duration-300 shadow-2xl hover:shadow-blue-500/25 border border-white/20"
            >
              <span class="flex items-center justify-center gap-2">
                Sign In
                <ArrowUpRightIcon
                  class="w-5 h-5 group-hover:translate-x-1 group-hover:-translate-y-1 transition-transform"
                />
              </span>
            </router-link>
            <router-link
              to="/register"
              class="group bg-white/10 backdrop-blur-xl text-white px-10 py-4 rounded-2xl font-bold text-lg border-2 border-white/30 hover:border-white/50 hover:bg-white/20 transform hover:scale-105 transition-all duration-300 shadow-2xl hover:shadow-white/10"
            >
              <span class="flex items-center justify-center gap-2">
                Create Account
                <UserPlusIcon
                  class="w-5 h-5 group-hover:translate-x-1 group-hover:-translate-y-1 transition-transform"
                />
              </span>
            </router-link>
          </div>

          <p class="text-lg text-blue-200">
            Already have an account?
            <router-link
              to="/login"
              class="text-white hover:text-cyan-300 font-semibold hover:underline transition-colors"
            >
              Sign in here
            </router-link>
          </p>
        </div>
      </div>
    </div>

    <!-- Enhanced Features Section -->
    <div class="py-16 bg-gradient-to-br from-slate-800 via-blue-800 to-indigo-900 relative overflow-hidden">
      <!-- Background Pattern -->
      <div class="absolute inset-0 opacity-5">
        <div class="absolute inset-0" style="background-image: radial-gradient(circle at 1px 1px, white 1px, transparent 0); background-size: 20px 20px;"></div>
      </div>
      
      <div class="max-w-7xl mx-auto px-4 relative z-10">
        <div class="text-center mb-16">
          <h2 class="text-4xl font-black text-white mb-6 tracking-tight">
            Why Choose 
            <span class="text-transparent bg-clip-text bg-gradient-to-r from-blue-400 to-cyan-400">FundEase</span>?
          </h2>
          <p class="text-xl text-blue-100 max-w-3xl mx-auto leading-relaxed font-light">
            Experience the future of sinking fund management with our
            cutting-edge features and user-friendly interface.
          </p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          <div
            v-for="(feature, index) in features"
            :key="index"
            class="group bg-white/10 backdrop-blur-xl border border-white/20 p-8 rounded-2xl shadow-2xl hover:shadow-blue-500/25 transition-all duration-500 hover:scale-105 hover:bg-white/15"
          >
            <div class="text-center">
              <div
                class="w-16 h-16 bg-gradient-to-br rounded-2xl flex items-center justify-center mx-auto mb-6 group-hover:scale-110 transition-transform duration-300 shadow-lg"
                :class="feature.color"
              >
                <component :is="feature.icon" class="w-10 h-10 text-white" />
              </div>
              <h3 class="text-2xl font-bold text-white mb-4 text-center">
                {{ feature.title }}
              </h3>
              <p class="text-blue-100 text-center leading-relaxed">
                {{ feature.description }}
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Enhanced Testimonials Section -->
    <div class="py-16 bg-gradient-to-br from-indigo-900 via-purple-900 to-slate-900 relative overflow-hidden">
      <!-- Background Elements -->
      <div class="absolute inset-0 opacity-10">
        <div class="absolute top-20 left-20 w-32 h-32 bg-blue-400 rounded-full filter blur-3xl"></div>
        <div class="absolute bottom-20 right-20 w-40 h-40 bg-purple-400 rounded-full filter blur-3xl"></div>
        <div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-60 h-60 bg-cyan-400 rounded-full filter blur-3xl"></div>
      </div>
      
      <div class="max-w-7xl mx-auto px-4 relative z-10">
        <div class="text-center mb-16">
          <h2 class="text-4xl font-black text-white mb-6 tracking-tight">
            What Our 
            <span class="text-transparent bg-clip-text bg-gradient-to-r from-purple-400 to-pink-400">Members</span> Say
          </h2>
          <p class="text-xl text-purple-100 max-w-3xl mx-auto leading-relaxed font-light">
            Join thousands of satisfied members who trust FundEase for their
            financial needs.
          </p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div
            v-for="(testimonial, index) in testimonials"
            :key="index"
            class="group bg-white/10 backdrop-blur-xl border border-white/20 p-8 rounded-2xl shadow-2xl hover:shadow-purple-500/25 transition-all duration-500 hover:scale-105 hover:bg-white/15"
          >
            <div class="text-center">
              <div class="mb-6">
                <div
                  class="w-16 h-16 bg-gradient-to-br from-purple-500 to-pink-500 rounded-full flex items-center justify-center mx-auto mb-4 shadow-lg group-hover:scale-110 transition-transform duration-300"
                >
                  <span class="text-2xl">{{ testimonial.avatar }}</span>
                </div>
                <h4 class="text-xl font-bold text-white mb-2">
                  {{ testimonial.name }}
                </h4>
                <p class="text-purple-200 font-medium">{{ testimonial.role }}</p>
              </div>
              <p class="text-purple-100 italic text-center leading-relaxed mb-4">
                "{{ testimonial.content }}"
              </p>
              <div class="flex justify-center">
                <div class="flex space-x-1">
                  <StarIcon
                    v-for="i in 5"
                    :key="i"
                    class="w-5 h-5 text-yellow-400 drop-shadow-lg"
                  />
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Enhanced Final CTA Section -->
    <div class="py-16 bg-gradient-to-br from-slate-900 via-blue-900 to-indigo-900 relative overflow-hidden">
      <!-- Animated Background -->
      <div class="absolute inset-0">
        <div class="absolute inset-0 bg-gradient-to-r from-blue-600/20 via-indigo-600/20 to-purple-600/20"></div>
        <div class="absolute top-0 left-0 w-full h-full">
          <div class="absolute top-1/4 left-1/4 w-64 h-64 bg-blue-500/10 rounded-full filter blur-3xl animate-blob"></div>
          <div class="absolute bottom-1/4 right-1/4 w-80 h-80 bg-purple-500/10 rounded-full filter blur-3xl animate-blob animation-delay-2000"></div>
          <div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-96 h-96 bg-indigo-500/10 rounded-full filter blur-3xl animate-blob animation-delay-4000"></div>
        </div>
      </div>
      
      <div class="max-w-4xl mx-auto text-center px-4 relative z-10">
        <div class="mb-10">
          <div class="inline-flex items-center justify-center w-16 h-16 bg-gradient-to-br from-blue-500 to-purple-600 rounded-2xl mb-6 shadow-2xl shadow-blue-500/25">
            <BoltIcon class="w-10 h-10 text-white" />
          </div>
          <h2 class="text-5xl font-black text-white mb-6 tracking-tight">
            Ready to Get 
            <span class="text-transparent bg-clip-text bg-gradient-to-r from-blue-400 via-cyan-400 to-purple-400">Started</span>?
          </h2>
          <p class="text-xl text-blue-100 mb-8 max-w-2xl mx-auto leading-relaxed font-light">
            Join FundEase today and experience the most advanced sinking fund
            management platform with cutting-edge technology and unmatched security.
          </p>
        </div>
        
        <div class="flex flex-col sm:flex-row gap-6 justify-center">
          <router-link
            to="/register"
            class="group bg-gradient-to-r from-blue-500 via-indigo-500 to-purple-600 text-white px-12 py-4 rounded-2xl font-bold text-xl hover:from-blue-600 hover:via-indigo-600 hover:to-purple-700 transform hover:scale-105 transition-all duration-300 shadow-2xl hover:shadow-blue-500/25 border border-white/20"
          >
            <span class="flex items-center justify-center gap-2">
              Get Started Now
              <ArrowUpRightIcon class="w-6 h-6 group-hover:translate-x-1 group-hover:-translate-y-1 transition-transform" />
            </span>
          </router-link>
          <router-link
            to="/login"
            class="group bg-white/10 backdrop-blur-xl border-2 border-white/30 text-white px-12 py-4 rounded-2xl font-bold text-xl hover:border-white/50 hover:bg-white/20 transform hover:scale-105 transition-all duration-300 shadow-2xl hover:shadow-white/10"
          >
            <span class="flex items-center justify-center gap-2">
              Sign In
              <ArrowUpRightIcon class="w-6 h-6 group-hover:translate-x-1 group-hover:-translate-y-1 transition-transform" />
            </span>
          </router-link>
        </div>
        
        <div class="mt-12 pt-6 border-t border-white/20">
          <p class="text-lg text-blue-200">
            Trusted by <span class="text-white font-bold">500+</span> members • 
            <span class="text-white font-bold">₱2.5M+</span> managed • 
            <span class="text-white font-bold">98%</span> satisfaction rate
          </p>
        </div>
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

.animation-delay-6000 {
  animation-delay: 6s;
}

.animation-delay-1000 {
  animation-delay: 1s;
}

.animation-delay-2000 {
  animation-delay: 2s;
}

.animation-delay-3000 {
  animation-delay: 3s;
}

.animate-float {
  animation: float 6s ease-in-out infinite;
}

.animate-fade-in-up {
  animation: fadeInUp 1s ease-out forwards;
}

.animate-gradient {
  animation: gradient 3s ease infinite;
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
  0%,
  100% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(-20px);
  }
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes gradient {
  0%,
  100% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
}

/* Custom scrollbar */
::-webkit-scrollbar {
  width: 8px;
}

::-webkit-scrollbar-track {
  background: #f1f1f1;
}

::-webkit-scrollbar-thumb {
  background: linear-gradient(to bottom, #3b82f6, #10b981);
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: linear-gradient(to bottom, #2563eb, #059669);
}
</style>