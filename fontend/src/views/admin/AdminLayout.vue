<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import Swal from 'sweetalert2' // Import SweetAlert2
import axios from 'axios'

import {
  HomeIcon,
  UserGroupIcon,
  UserPlusIcon,
  CurrencyDollarIcon,
  DocumentTextIcon,
  ArrowRightOnRectangleIcon,
  CogIcon,
  ChartBarIcon,
  BellIcon,
  ArrowRightOnRectangleIcon as LogoutIcon,
  BanknotesIcon,
  EnvelopeIcon
} from '@heroicons/vue/24/outline'
import NotificationDropdown from '@/components/NotificationDropdown.vue'

const router = useRouter()
const authStore = useAuthStore()
const sidebarOpen = ref(false)
const userFirstName = ref('')

// Function to get user data from localStorage
const getUserData = () => {
  const userData = JSON.parse(localStorage.getItem('user'))
  if (userData && userData.firstName) {
    userFirstName.value = userData.firstName
  }
}

// Navigation links
const navigation = [
  { name: 'Dashboard', path: '/admin/dashboard', icon: HomeIcon },
  { name: 'Members', path: '/admin/members', icon: UserGroupIcon },
  { name: 'Registrations', path: '/admin/registrations', icon: UserPlusIcon },
  { name: 'Contributions', path: '/admin/contributions', icon: BanknotesIcon },
  { name: 'Loans', path: '/admin/loans', icon: DocumentTextIcon },
  { name: 'Withdrawals', path: '/admin/withdrawals', icon: ArrowRightOnRectangleIcon },
  { name: 'Reports', path: '/admin/reports', icon: ChartBarIcon },
  { name: 'Notifications', path: '/admin/notifications', icon: BellIcon },
  { name: 'Messages', path: '/admin/messages', icon: EnvelopeIcon },
  { name: 'Settings', path: '/admin/settings', icon: CogIcon },
]

// Logout with SweetAlert2 confirmation
const handleLogout = () => {
  Swal.fire({
    title: 'Are you sure?',
    text: "You will be logged out of your session.",
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#3085d6',
    cancelButtonColor: '#d33',
    confirmButtonText: 'Yes, log me out!'
  }).then((result) => {
    if (result.isConfirmed) {
      // Clear token and user data from localStorage
      localStorage.removeItem('token')
      localStorage.removeItem('user')

      // Clear the pinia store state
      authStore.logout()

      Swal.fire(
        'Logged Out!',
        'You have been successfully logged out.',
        'success'
      )
      router.push('/login')
    }
  })
}

// Call on component mount
onMounted(() => {
  getUserData()
})
</script>
<template>
  <div class="relative flex min-h-screen flex-col bg-gradient-to-br from-indigo-50 via-blue-50 to-cyan-50">
    <div class="absolute inset-0 overflow-hidden pointer-events-none">
      <div
        class="absolute -top-40 -right-40 h-80 w-80 animate-blob rounded-full bg-indigo-200 opacity-20 mix-blend-multiply blur-xl"
      ></div>
      <div
        class="absolute -bottom-40 -left-40 h-80 w-80 animate-blob rounded-full bg-cyan-200 opacity-20 mix-blend-multiply blur-xl animation-delay-2000"
      ></div>
      <div
        class="absolute top-40 left-40 h-80 w-80 animate-blob rounded-full bg-blue-200 opacity-20 mix-blend-multiply blur-xl animation-delay-4000"
      ></div>
    </div>

    <div
      v-if="sidebarOpen"
      class="fixed inset-0 z-40 bg-black/50 backdrop-blur-sm transition-all duration-300 lg:hidden"
      @click="sidebarOpen = false"
    />

    <aside
      :class="[
        'fixed inset-y-0 left-0 z-50 w-72 transform border-r border-gray-200/50 bg-white/95 shadow-2xl backdrop-blur-xl transition-all duration-300 ease-in-out lg:translate-x-0',
        sidebarOpen ? 'translate-x-0' : '-translate-x-full',
      ]"
    >
      <div class="border-b border-gray-200/50 p-6">
        <div class="flex items-center gap-3">
          <div
            class="flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-to-br from-indigo-500 to-cyan-600 shadow-lg"
          >
            <span class="text-lg font-bold text-white">F</span>
          </div>
          <div>
            <h1
              class="bg-gradient-to-r from-indigo-600 to-cyan-600 bg-clip-text text-xl font-bold text-transparent"
            >
              FundEase
            </h1>
            <p class="text-sm font-medium text-gray-500">Admin Portal</p>
          </div>
        </div>
      </div>

      <nav class="flex-1 space-y-2 px-4 py-6">
        <router-link
          v-for="item in navigation"
          :key="item.name"
          :to="item.path"
          class="group flex items-center gap-4 rounded-xl px-4 py-3 text-gray-700 transition-all duration-300 hover:scale-[1.02] hover:bg-gradient-to-r hover:from-indigo-50 hover:to-cyan-50 hover:shadow-md"
          active-class="bg-gradient-to-r from-indigo-500 to-cyan-600 text-white shadow-lg scale-[1.02]"
        >
          <div
            class="flex h-8 w-8 items-center justify-center rounded-lg bg-gray-100 transition-all duration-300 group-hover:bg-white/20"
          >
            <component :is="item.icon" class="h-5 w-5" />
          </div>
          <span class="font-medium">{{ item.name }}</span>
        </router-link>
      </nav>

      <div class="space-y-4 border-t border-gray-200/50 p-6">
        <div class="flex items-center gap-3 rounded-xl bg-gray-50/50 p-3">
          <img
            class="h-10 w-10 rounded-full ring-2 ring-indigo-200"
            src="https://i.pravatar.cc/40"
            alt="avatar"
          />
          <div class="min-w-0 flex-1">
            <p class="truncate text-sm font-medium text-gray-900">
              {{ userFirstName || "Administrator" }}
            </p>
            <p class="text-xs text-gray-500">Administrator</p>
          </div>
        </div>
        <button
          @click="handleLogout"
          class="flex w-full items-center justify-center rounded-xl bg-red-50 px-4 py-3 font-medium text-red-600 transition-all duration-300 hover:bg-red-100 hover:text-red-700"
        >
          <LogoutIcon class="mr-2 h-5 w-5" />
          Sign Out
        </button>
      </div>
    </aside>

    <div class="flex min-h-screen flex-1 flex-col lg:ml-72 overflow-hidden">
      <header
        class="sticky top-0 z-30 border-b border-gray-200/50 bg-white/80 shadow-sm backdrop-blur-xl"
      >
        <div class="flex items-center justify-between px-4 py-4 sm:px-6 lg:px-8">
          <div class="flex items-center gap-4">
            <button
              class="rounded-lg p-2 transition-colors duration-200 hover:bg-gray-100 lg:hidden"
              @click="sidebarOpen = !sidebarOpen"
            >
              <svg
                class="h-6 w-6 text-gray-700"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M4 6h16M4 12h16M4 18h16"
                />
              </svg>
            </button>
            <h1
              class="truncate bg-gradient-to-r from-indigo-600 to-cyan-600 bg-clip-text text-xl font-bold text-transparent sm:text-2xl"
            >
              {{ userFirstName || "Administrator" }} Dashboard
            </h1>
          </div>

          <div class="flex items-center gap-4 sm:gap-6">
            <NotificationDropdown />

            <div
              class="hidden cursor-pointer items-center gap-3 rounded-xl p-2 transition-all duration-200 hover:bg-gray-100 sm:flex"
            >
              <img
                class="h-9 w-9 rounded-full ring-2 ring-indigo-200"
                src="https://i.pravatar.cc/40"
                alt="avatar"
              />
              <div class="hidden min-w-0 sm:block">
                <p class="truncate text-sm font-medium text-gray-900">
                  {{ userFirstName || "Administrator" }}
                </p>
                <p class="text-xs text-gray-500">Administrator</p>
              </div>
            </div>
          </div>
        </div>
      </header>

      <main class="flex-1 overflow-y-auto p-4 sm:p-6 lg:p-8">
        <div class="mx-auto max-w-7xl">
          <router-view />
        </div>
      </main>
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
@keyframes blob {
  0%,
  100% {
    transform: translate(0, 0) scale(1);
  }
  33% {
    transform: translate(30px, -50px) scale(1.1);
  }
  66% {
    transform: translate(-20px, 20px) scale(0.9);
  }
}
</style>