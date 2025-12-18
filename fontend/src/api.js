import axios from 'axios'

const getBaseURL = () => {
  if (window.location.hostname !== 'localhost' && window.location.hostname !== '127.0.0.1') {
    const backendURL = `http://${window.location.hostname}:5000/api`
    console.log('Using backend URL:', backendURL)
    return backendURL
  }
  console.log('Using localhost backend URL')
  return 'http://localhost:5000/api'
}

const api = axios.create({
  baseURL: getBaseURL(),
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
})

api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

api.interceptors.response.use(
  (response) => {
    return response
  },
  (error) => {
    console.error('API Error:', error)
    
    if (error.code === 'NETWORK_ERROR' || error.message === 'Network Error') {
      console.error('Backend server is not reachable. Check if server is running on port 5000')
      alert('Cannot connect to server. Please check if the backend server is running.')
    }
    
    if (error.response?.status === 401) {
      localStorage.removeItem('token')
      localStorage.removeItem('user')
      window.location.href = '/login'
    }
    return Promise.reject(error)
  }
)

export default api
