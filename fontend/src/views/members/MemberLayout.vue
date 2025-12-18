<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import Swal from 'sweetalert2' // Import SweetAlert2

import {
  HomeIcon, BanknotesIcon, ArrowTrendingUpIcon, 
  WalletIcon, ChatBubbleBottomCenterIcon, 
  BellIcon, Cog6ToothIcon, ArrowRightOnRectangleIcon 
} from '@heroicons/vue/24/outline'

const router = useRouter()
const authStore = useAuthStore()
const sidebarOpen = ref(false)
const userFirstName = ref('')
const userRole = ref('')

// Local notification state
const notifications = ref([
  {
    notificationID: '1',
    title: 'Contribution Confirmed',
    message: 'Your contribution of ₱2,500.00 has been confirmed and added to your account.',
    type: 'success',
    isRead: false,
    createdAt: new Date().toISOString()
  },
  {
    notificationID: '2',
    title: 'Loan Application Status',
    message: 'Your loan application for ₱50,000.00 is currently under review.',
    type: 'info',
    isRead: true,
    createdAt: new Date(Date.now() - 2 * 60 * 60 * 1000).toISOString()
  },
  {
    notificationID: '3',
    title: 'Withdrawal Approved',
    message: 'Your withdrawal request of ₱15,000.00 has been approved and will be processed within 24 hours.',
    type: 'success',
    isRead: false,
    createdAt: new Date(Date.now() - 5 * 60 * 60 * 1000).toISOString()
  },
  {
    notificationID: '4',
    title: 'Monthly Meeting Reminder',
    message: 'Don\'t forget about the monthly meeting scheduled for tomorrow at 2:00 PM.',
    type: 'info',
    isRead: true,
    createdAt: new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString()
  },
  {
    notificationID: '5',
    title: 'Payment Due',
    message: 'Your loan payment of ₱3,500.00 is due in 3 days.',
    type: 'warning',
    isRead: false,
    createdAt: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000).toISOString()
  }
])

// Computed property for new notifications
const hasNewNotifications = computed(() => {
  return notifications.value.some(notification => !notification.isRead)
})

const unreadCount = computed(() => {
  return notifications.value.filter(notification => !notification.isRead).length
})

// Function to get user data from localStorage
const getUserData = () => {
  const userData = JSON.parse(localStorage.getItem('user'))
  if (userData && userData.firstName) {
    userFirstName.value = userData.firstName
    userRole.value = userData.role // Assuming role is in the user object
  }
}

// Function to mark notification as read
const markNotificationAsRead = (notificationID) => {
  const notification = notifications.value.find(n => n.notificationID === notificationID)
  if (notification) {
    notification.isRead = true
  }
}

const navigation = [
  { name: 'Dashboard', path: '/member/dashboard', icon: HomeIcon },
  { name: 'Contributions', path: '/member/contributions', icon: BanknotesIcon },
  { name: 'Loans', path: '/member/loans', icon: ArrowTrendingUpIcon },
  { name: 'Withdrawals', path: '/member/withdrawals', icon: WalletIcon },
  { name: 'Messages', path: '/member/messages', icon: ChatBubbleBottomCenterIcon },
  { name: 'Notifications', path: '/member/notifications', icon: BellIcon },
  { name: 'Settings', path: '/member/settings', icon: Cog6ToothIcon },
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
  // You would typically call fetchNotifications here as well:
  // fetchNotifications();
})
</script>
<template>
  <div class="relative flex min-h-screen flex-col bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50">
    <div class="absolute inset-0 overflow-hidden pointer-events-none">
      <div
        class="absolute -top-40 -right-40 h-80 w-80 animate-blob rounded-full bg-blue-200 opacity-20 mix-blend-multiply blur-xl"
      ></div>
      <div
        class="absolute -bottom-40 -left-40 h-80 w-80 animate-blob rounded-full bg-purple-200 opacity-20 mix-blend-multiply blur-xl animation-delay-2000"
      ></div>
      <div
        class="absolute top-40 left-40 h-80 w-80 animate-blob rounded-full bg-indigo-200 opacity-20 mix-blend-multiply blur-xl animation-delay-4000"
      ></div>
    </div>

    <div
      v-if="sidebarOpen"
      class="fixed inset-0 z-40 bg-black/50 backdrop-blur-sm lg:hidden transition-all duration-300"
      @click="sidebarOpen = false"
    ></div>

    <aside
      :class="[
        'fixed z-50 inset-y-0 left-0 w-72 bg-white/95 backdrop-blur-xl shadow-2xl border-r border-gray-200/50 transform transition-transform duration-300 ease-in-out lg:translate-x-0',
        sidebarOpen ? 'translate-x-0' : '-translate-x-full'
      ]"
    >
      <div class="border-b border-gray-200/50 p-8">
        <div class="flex items-center space-x-3">
          <div
            class="flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-to-br from-blue-500 to-purple-600 shadow-lg"
          >
            <span class="text-lg font-bold text-white">F</span>
          </div>
          <div>
            <h1 class="bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-xl font-bold text-transparent">
              FundEase
            </h1>
            <p class="text-sm font-medium text-gray-500">Member Portal</p>
          </div>
        </div>
      </div>

      <nav class="flex-1 space-y-3 px-6 py-8">
        <router-link
          v-for="item in navigation"
          :key="item.name"
          :to="item.path"
          class="group flex items-center rounded-xl px-4 py-3 text-gray-700 transition-all duration-300 hover:scale-105 hover:bg-gradient-to-r hover:from-blue-50 hover:to-purple-50 hover:shadow-md"
          active-class="bg-gradient-to-r from-blue-500 to-purple-600 text-white shadow-lg scale-105"
        >
          <div
            class="mr-4 flex h-10 w-10 items-center justify-center rounded-lg bg-gray-100 transition-all duration-300 group-hover:bg-white/20"
          >
            <component :is="item.icon" class="h-5 w-5" />
          </div>
          <span class="truncate font-medium">{{ item.name }}</span>
        </router-link>
      </nav>

      <div class="space-y-4 border-t border-gray-200/50 p-6">
        <div class="flex items-center space-x-3 rounded-xl bg-gray-50/50 p-3">
          <img class="h-10 w-10 rounded-full ring-2 ring-blue-200" src="https://i.pravatar.cc/40" alt="avatar" />
          <div class="min-w-0 flex-1">
            <p class="truncate text-sm font-medium text-gray-900">
              {{ userFirstName || authStore.userDisplayName }}
            </p>
            <p class="text-xs text-gray-500">{{ userRole || 'Member' }}</p>
          </div>
        </div>
        <button
          @click="handleLogout"
          class="flex w-full items-center justify-center rounded-xl bg-red-50 px-4 py-3 font-medium text-red-600 transition-all duration-300 hover:bg-red-100 hover:text-red-700"
        >
          <ArrowRightOnRectangleIcon class="mr-2 h-5 w-5" />
          Sign Out
        </button>
      </div>
    </aside>

    <div class="flex min-h-screen flex-1 flex-col overflow-hidden lg:ml-72">
      <header class="sticky top-0 z-30 border-b border-gray-200/50 bg-white/80 shadow-sm backdrop-blur-xl">
        <div class="flex items-center justify-between px-6 py-4 md:px-8">
          <div class="flex items-center space-x-4">
            <button
              class="rounded-lg p-2 transition-colors duration-200 hover:bg-gray-100 lg:hidden"
              @click="sidebarOpen = !sidebarOpen"
            >
              <svg class="h-6 w-6 text-gray-700" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
              </svg>
            </button>
            <h1
              class="truncate bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text font-serif text-2xl font-bold text-transparent"
            >
              {{ userFirstName || 'Member' }}'s Dashboard
            </h1>
          </div>

          <div class="flex items-center space-x-4 md:space-x-6">
            <RouterLink
              to="/member/notifications"
              class="group relative rounded-xl p-2 transition-all duration-200 hover:bg-gray-100"
            >
              <BellIcon class="h-6 w-6 text-gray-600 transition-colors group-hover:text-blue-600" />
              <span
                v-if="unreadCount > 0"
                class="absolute -top-1 -right-1 flex h-5 w-5 animate-pulse items-center justify-center rounded-full bg-red-500 text-xs text-white"
              >
                {{ unreadCount > 99 ? '99+' : unreadCount }}
              </span>
            </RouterLink>

            <div
              class="hidden cursor-pointer items-center space-x-3 rounded-xl p-2 transition-all duration-200 hover:bg-gray-100 sm:flex"
            >
              <img class="h-9 w-9 rounded-full ring-2 ring-blue-200" src="https://i.pravatar.cc/40" alt="avatar" />
              <div class="min-w-0">
                <p class="truncate text-sm font-medium text-gray-900">
                  {{ userFirstName || authStore.userDisplayName }}
                </p>
                <p class="text-xs text-gray-500">{{ userRole || 'Member' }}</p>
              </div>
            </div>
          </div>
        </div>
      </header>

      <main class="flex-1 overflow-y-auto p-6 md:p-8">
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