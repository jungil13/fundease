<script setup>
import { ref, onMounted } from "vue";
import api from "@/api";
import Swal from "sweetalert2";
import {
  CreditCardIcon,
  ClipboardDocumentListIcon,
  BanknotesIcon,
  ArrowPathIcon
} from "@heroicons/vue/24/outline";
import qrImg from "@/assets/image.png"; // ✅ Import the image

// ✅ Get user info from localStorage
const user = JSON.parse(localStorage.getItem("user")) || null;
const userID = user?.id || user?.userID; // 🔹 This will be used in requests
const qrCode = qrImg; // use this as the src

// State
const loans = ref([]);
const repayments = ref([]);
const loading = ref(false);
const error = ref(null);

// Forms
const requestForm = ref({
  amount: "",
  termMonths: "",
  reason: "",
  paymentFrequency: "monthly" // daily, weekly, monthly
});

// Verification modal state
const showVerificationModal = ref(false);
const verificationChecked = ref(false);
const loanSummary = ref({
  memberName: "",
  loanAmount: 0,
  interest: 0,
  total: 0
});

const repayForm = ref({
  loanId: "",
  amount: "",
  referenceNo: "",
  notes: "",
  paymentProof: null
});

// Repayment modal state
const showRepaymentModal = ref(false);
const selectedPayment = ref(null);
const selectedLoanForRepayment = ref(null);

const onFileChange = (e) => {
  repayForm.value.paymentProof = e.target.files[0];
};

const previewImage = (url) => {
  Swal.fire({
    imageUrl: url,
    imageAlt: "Payment Proof",
    showCloseButton: true,
    showConfirmButton: false,
    width: "auto"
  });
};
// ✅ Fetch Loans & Repayments
const fetchLoans = async () => {
  if (!userID) return;
  try {
    loading.value = true;
    const res = await api.get(`/loans/user/${userID}`);
    loans.value = res.data;
  } catch (err) {
    console.error(err);
    error.value = "Failed to load loans.";
  } finally {
    loading.value = false;
  }
};

const fetchRepayments = async () => {
  if (!userID) return;
  try {
    const res = await api.get(`/repayments/user/${userID}`);
    repayments.value = res.data;
  } catch (err) {
    console.error(err);
    error.value = "Failed to load repayments.";
  }
};

// Calculate loan summary with 15% interest
const calculateLoanSummary = () => {
  const amount = parseFloat(requestForm.value.amount) || 0;
  const interestRate = 0.15; // 15% interest
  const interest = amount * interestRate;
  const total = amount + interest;
  
  const memberName = user?.firstName && user?.lastName 
    ? `${user.firstName} ${user.lastName}` 
    : user?.name || "Member";
  
  loanSummary.value = {
    memberName: memberName,
    loanAmount: amount,
    interest: interest,
    total: total
  };
};

// Show verification modal before submitting
const showVerification = () => {
  if (!requestForm.value.amount || !requestForm.value.termMonths || !requestForm.value.reason) {
    Swal.fire({
      icon: "warning",
      title: "Incomplete Form",
      text: "Please fill in all required fields",
      confirmButtonColor: "#0ea5e9"
    });
    return;
  }
  
  calculateLoanSummary();
  showVerificationModal.value = true;
  verificationChecked.value = false;
};

// Close verification modal
const closeVerificationModal = () => {
  showVerificationModal.value = false;
  verificationChecked.value = false;
};

// ✅ Request Loan (after verification)
const handleRequestLoan = async () => {
  if (!verificationChecked.value) {
    Swal.fire({
      icon: "warning",
      title: "Verification Required",
      text: "Please acknowledge the loan agreement",
      confirmButtonColor: "#0ea5e9"
    });
    return;
  }

  try {
    loading.value = true;
    error.value = null;

    const payload = {
      userID,
      memberID: userID,
      amount: requestForm.value.amount,
      reason: requestForm.value.reason,
      termMonths: requestForm.value.termMonths,
      interestRate: 0.15, // 15% interest
      paymentFrequency: requestForm.value.paymentFrequency
    };

    const res = await api.post(`/loans/request`, payload);

    Swal.fire({
      icon: "success",
      title: "Loan Requested",
      text: `Your loan (#${res.data.loanID}) has been submitted!`,
      confirmButtonColor: "#0ea5e9"
    });

    requestForm.value = { amount: "", termMonths: "", reason: "", paymentFrequency: "monthly" };
    closeVerificationModal();
    await fetchLoans();
  } catch (err) {
    console.error(err);
    Swal.fire({
      icon: "error",
      title: "Request Failed",
      text: err.response?.data?.message || "Something went wrong",
      confirmButtonColor: "#ef4444"
    });
  } finally {
    loading.value = false;
  }
};

// Calculate payment schedule
const calculatePaymentSchedule = (loan) => {
  if (!loan || loan.status !== 'approved' && loan.status !== 'disbursed' && loan.status !== 'active') {
    return [];
  }

  const loanAmount = parseFloat(loan.amount) || 0;
  const interestRate = parseFloat(loan.interestRate) || 0.15;
  const totalAmount = loanAmount * (1 + interestRate); // Loan + interest (e.g., 100 * 1.15 = 115)
  const termMonths = loan.termMonths || 1;
  
  // Get payment frequency from loan or default to 'monthly'
  const paymentFrequency = loan.paymentFrequency || 'monthly';
  
  // Calculate number of payment periods based on frequency and term
  let numberOfPayments = 1;
  if (paymentFrequency === 'daily') {
    // Approximately 30 days per month
    numberOfPayments = termMonths * 30;
  } else if (paymentFrequency === 'weekly') {
    // 4 weeks per month
    numberOfPayments = termMonths * 4;
  } else if (paymentFrequency === 'monthly') {
    // 1 payment per month
    numberOfPayments = termMonths;
  }
  
  // Split total amount by number of payments (e.g., 115 / 4 = 28.75 per payment)
  const paymentPerPeriod = totalAmount / numberOfPayments;
  
  const schedule = [];
  const startDate = loan.disbursedAt 
    ? new Date(loan.disbursedAt) 
    : loan.approvedAt 
      ? new Date(loan.approvedAt) 
      : new Date(loan.createdAt);
  
  // Get confirmed repayments
  const confirmedRepayments = repayments.value.filter(
    r => r.loanID === loan.loanID && r.status === 'confirmed'
  );
  const totalPaid = confirmedRepayments.reduce((sum, r) => sum + parseFloat(r.amount || 0), 0);
  
  // Generate schedule based on payment frequency
  for (let i = 0; i < numberOfPayments; i++) {
    const dueDate = new Date(startDate);
    
    // Calculate due date based on payment frequency
    if (paymentFrequency === 'daily') {
      dueDate.setDate(dueDate.getDate() + i + 1);
    } else if (paymentFrequency === 'weekly') {
      dueDate.setDate(dueDate.getDate() + (i + 1) * 7);
    } else if (paymentFrequency === 'monthly') {
      dueDate.setMonth(dueDate.getMonth() + i + 1);
    }
    
    const expectedPaid = paymentPerPeriod * (i + 1);
    const isPaid = totalPaid >= expectedPaid;
    const isCurrent = i === 0 
      ? totalPaid < paymentPerPeriod 
      : totalPaid >= paymentPerPeriod * i && totalPaid < expectedPaid;
    const isPast = i > 0 && totalPaid < paymentPerPeriod * i;
    
    let status = 'next';
    if (isPaid) status = 'paid';
    else if (isCurrent) status = 'current';
    else if (isPast) status = 'due';
    
    schedule.push({
      dueDate: dueDate,
      amount: paymentPerPeriod,
      status: status,
      index: i
    });
  }
  
  return schedule;
};

const openRepaymentModal = (loan, payment) => {
  selectedLoanForRepayment.value = loan;
  selectedPayment.value = payment;
  repayForm.value.loanId = loan.loanID;
  // Round to 2 decimal places to avoid precision issues
  repayForm.value.amount = Math.round(payment.amount * 100) / 100;
  showRepaymentModal.value = true;
};

const closeRepaymentModal = () => {
  showRepaymentModal.value = false;
  selectedPayment.value = null;
  selectedLoanForRepayment.value = null;
  repayForm.value = { loanId: "", amount: "", referenceNo: "", notes: "", paymentProof: null };
};

const handleRepayLoan = async () => {
  // Validate amount before submission
  const repaymentAmount = parseFloat(repayForm.value.amount) || 0;
  const remainingBalance = parseFloat(selectedLoanForRepayment.value?.remainingBalance) || 0;

  if (repaymentAmount <= 0) {
    Swal.fire({
      icon: "warning",
      title: "Invalid Amount",
      text: "Please enter a valid payment amount",
      confirmButtonColor: "#ef4444"
    });
    return;
  }

  if (repaymentAmount > remainingBalance) {
    Swal.fire({
      icon: "error",
      title: "Amount Exceeds Balance",
      text: `The payment amount (₱${repaymentAmount.toFixed(2)}) exceeds the remaining balance (₱${remainingBalance.toFixed(2)}). Please enter an amount not exceeding ₱${remainingBalance.toFixed(2)}.`,
      confirmButtonColor: "#ef4444"
    });
    return;
  }

  try {
    loading.value = true;

    const formData = new FormData();
    formData.append("loanID", repayForm.value.loanId);
    formData.append("userID", userID);
    formData.append("amount", repaymentAmount);
    formData.append("referenceNo", repayForm.value.referenceNo);
    formData.append("notes", repayForm.value.notes || "");
    formData.append("paymentMethod", "gcash");
    if (repayForm.value.paymentProof) {
      formData.append("paymentProof", repayForm.value.paymentProof);
    }
    const res = await api.post(`/repayments/repay`, formData, {
      headers: { "Content-Type": "multipart/form-data" }
    });

    Swal.fire({
      icon: "success",
      title: "Repayment Submitted",
      text: "Waiting for admin confirmation.",
      confirmButtonColor: "#22c55e"
    });

    closeRepaymentModal();
    await fetchLoans();
    await fetchRepayments();
  } catch (err) {
    console.error(err);
    Swal.fire({
      icon: "error",
      title: "Repayment Failed",
      text: err.response?.data?.message || "Something went wrong",
      confirmButtonColor: "#ef4444"
    });
  } finally {
    loading.value = false;
  }
};

// ✅ Status Colors
const getStatusColor = (status) => {
  switch (status) {
    case "approved":
    case "active":
      return "text-green-600 font-semibold";
    case "pending":
      return "text-yellow-600 font-semibold";
    case "confirmed":
      return "text-green-700 font-semibold";
    default:
      return "text-red-700";
  }
};

// Load on page start
onMounted(() => {
  fetchLoans();
  fetchRepayments();
});
</script>

<template>
  <div class="min-h-screen relative p-6">
    <div class="relative z-10 max-w-5xl mx-auto space-y-8">
      <h1 class="text-3xl font-bold text-sky-700">Loan & Repayment</h1>

      <!-- Error/Success Messages -->
      <div v-if="error" class="bg-red-50 border border-red-200 rounded-xl p-4">
        <div class="flex items-center">
          <div class="w-5 h-5 text-red-400 mr-2">⚠️</div>
          <p class="text-red-800">{{ error }}</p>
        </div>
      </div>

      <div v-if="success" class="bg-green-50 border border-green-200 rounded-xl p-4">
        <div class="flex items-center">
          <div class="w-5 h-5 text-green-400 mr-2">✅</div>
          <p class="text-green-800">{{ success }}</p>
        </div>
      </div>

      <!-- Request Loan -->
      <div class="bg-white/80 backdrop-blur-xl rounded-2xl shadow-xl p-6">
        <h2 class="text-xl font-semibold flex items-center gap-2 text-gray-800 mb-4">
          <CreditCardIcon class="w-6 h-6 text-sky-600" /> Request a Loan
        </h2>
        <form @submit.prevent="showVerification" class="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div>
            <label class="block text-sm text-gray-700 mb-2">Amount (₱)</label>
            <input v-model="requestForm.amount" type="number" min="0" step="0.01"
              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-sky-500 focus:border-transparent"
              required />
          </div>
          <div>
            <label class="block text-sm text-gray-700 mb-2">
              Term (months)
              <span class="text-xs text-gray-500 block mt-1">Refers to the total length of time you have to repay the loan in full.</span>
            </label>
            <input v-model="requestForm.termMonths" type="number" min="1" max="60"
              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-sky-500 focus:border-transparent"
              required />
          </div>
          <div>
            <label class="block text-sm text-gray-700 mb-2">
              Payment Frequency
              <span class="text-xs text-gray-500 block mt-1">How often you will make payments.</span>
            </label>
            <select v-model="requestForm.paymentFrequency"
              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-sky-500 focus:border-transparent"
              required>
              <option value="daily">Daily</option>
              <option value="weekly">Weekly</option>
              <option value="monthly">Monthly</option>
            </select>
          </div>
          <div class="md:col-span-3">
            <label class="block text-sm text-gray-700 mb-2">Purpose</label>
            <textarea v-model="requestForm.reason" rows="3" placeholder="e.g., school fees, medical, business capital"
              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-sky-500 focus:border-transparent"
              required></textarea>
          </div>
          <div class="md:col-span-3 flex gap-3">
            <button type="submit" :disabled="loading"
              class="bg-sky-600 hover:bg-sky-700 disabled:opacity-50 text-white px-6 py-3 rounded-lg font-semibold">
              {{ loading ? 'Submitting...' : 'Submit Request' }}
            </button>
            <p class="text-sm text-gray-500 flex items-center gap-2">
              <ClipboardDocumentListIcon class="w-5 h-5" /> Requests are reviewed within 1–3 business days.
            </p>
          </div>
        </form>
      </div>

      <!-- Verification Modal -->
      <div v-if="showVerificationModal" class="fixed inset-0 bg-black bg-opacity-30 backdrop-blur-sm flex items-center justify-center z-50 p-4">
        <div class="bg-white rounded-2xl shadow-xl max-w-md w-full p-6">
          <h3 class="text-xl font-bold text-gray-900 mb-4">Loan Verification</h3>
          
          <div class="space-y-3 mb-6">
            <div>
              <p class="text-sm text-gray-600">Member Name</p>
              <p class="text-lg font-semibold text-gray-900">{{ loanSummary.memberName }}</p>
            </div>
            <div>
              <p class="text-sm text-gray-600">Loan Amount</p>
              <p class="text-lg font-semibold text-gray-900">₱{{ loanSummary.loanAmount.toLocaleString('en-PH', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) }}</p>
            </div>
            <div>
              <p class="text-sm text-gray-600">Interest (15%)</p>
              <p class="text-lg font-semibold text-gray-900">₱{{ loanSummary.interest.toLocaleString('en-PH', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) }}</p>
            </div>
            <div class="border-t pt-3">
              <p class="text-sm text-gray-600">Total Amount</p>
              <p class="text-2xl font-bold text-sky-600">₱{{ loanSummary.total.toLocaleString('en-PH', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) }}</p>
            </div>
          </div>

          <div class="mb-6">
            <label class="flex items-start gap-3 cursor-pointer">
              <input type="checkbox" v-model="verificationChecked"
                class="mt-1 w-5 h-5 text-sky-600 border-gray-300 rounded focus:ring-sky-500" />
              <span class="text-sm text-gray-700">
                By submitting this loan request, I acknowledge and accept that the approved loan amount will incur interest as defined by the FundEase loan agreement.
              </span>
            </label>
          </div>

          <div class="flex gap-3">
            <button @click="closeVerificationModal"
              class="flex-1 bg-gray-200 hover:bg-gray-300 text-gray-700 px-4 py-2 rounded-lg font-medium">
              Cancel
            </button>
            <button @click="handleRequestLoan" :disabled="!verificationChecked || loading"
              class="flex-1 bg-sky-600 hover:bg-sky-700 disabled:opacity-50 text-white px-4 py-2 rounded-lg font-medium">
              {{ loading ? 'Submitting...' : 'Submit' }}
            </button>
          </div>
        </div>
      </div>
      <!-- Repay Loan -->
      <div class="bg-white/80 backdrop-blur-xl rounded-2xl shadow-xl p-6">
        <h2 class="text-xl font-semibold flex items-center gap-2 text-gray-800 mb-4">
          <BanknotesIcon class="w-6 h-6 text-green-600" /> Repay a Loan
        </h2>

        <!-- Payment Schedule for Active Loans -->
        <div v-for="loan in loans.filter(l => ['approved', 'disbursed', 'active'].includes(l.status))" :key="loan.loanID" class="mb-6">
          <h3 class="text-lg font-medium text-gray-700 mb-3">Loan #{{ loan.loanID }}</h3>
          <div class="space-y-2">
            <div v-for="(payment, index) in calculatePaymentSchedule(loan)" :key="index"
              :class="[
                'p-4 rounded-lg border-2',
                payment.status === 'paid' ? 'bg-green-50 border-green-200' : 
                payment.status === 'current' ? 'bg-blue-50 border-blue-300' :
                payment.status === 'due' ? 'bg-red-50 border-red-200' :
                'bg-gray-50 border-gray-200'
              ]">
              <div class="flex items-center justify-between">
                <div class="flex-1">
                  <div class="flex items-center gap-2 mb-1">
                    <span v-if="payment.status === 'paid'" class="text-green-600 font-semibold">✓ Paid</span>
                    <span v-else-if="payment.status === 'current'" class="text-blue-600 font-semibold">Current Due</span>
                    <span v-else-if="payment.status === 'due'" class="text-red-600 font-semibold">Due</span>
                    <span v-else class="text-gray-600 font-semibold">Next Due</span>
                    <span class="text-gray-600">, {{ payment.dueDate.toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' }) }}</span>
                  </div>
                  <p class="text-gray-700">Amount to pay: <span class="font-semibold">₱{{ payment.amount.toLocaleString('en-PH', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) }}</span></p>
                </div>
                <div v-if="payment.status !== 'paid'">
                  <button @click="openRepaymentModal(loan, payment)"
                    class="bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-lg font-medium text-sm">
                    Pay Now
                  </button>
                </div>
              </div>
            </div>
          </div>
            </div>

        <!-- Empty State -->
        <div v-if="loans.filter(l => ['approved', 'disbursed', 'active'].includes(l.status)).length === 0" class="text-center py-8">
          <BanknotesIcon class="w-16 h-16 text-gray-300 mx-auto mb-4" />
          <p class="text-gray-500">No active loans to repay</p>
        </div>
            </div>

      <!-- Repayment Modal -->
      <div v-if="showRepaymentModal" class="fixed inset-0 bg-opacity-30 backdrop-blur-sm flex items-center justify-center z-50 p-4">
        <div class="bg-white rounded-2xl shadow-xl max-w-md w-full p-6">
          <h3 class="text-xl font-bold text-gray-900 mb-4">Make Payment</h3>
          
          <form @submit.prevent="handleRepayLoan" enctype="multipart/form-data" class="space-y-4">
            <div>
              <label class="block text-sm text-gray-700 mb-2">Amount (₱)</label>
              <input 
                v-model.number="repayForm.amount" 
                type="number" 
                :min="0" 
                :max="selectedLoanForRepayment?.remainingBalance || 0"
                step="any"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent" 
                required />
              <div class="mt-2 space-y-1">
                <p v-if="selectedPayment" class="text-xs text-gray-500">
                  Expected amount: ₱{{ selectedPayment.amount.toFixed(2) }}
                </p>
                <p v-if="selectedLoanForRepayment" class="text-xs font-medium" :class="{
                  'text-red-600': parseFloat(repayForm.amount || 0) > parseFloat(selectedLoanForRepayment.remainingBalance || 0),
                  'text-gray-600': parseFloat(repayForm.amount || 0) <= parseFloat(selectedLoanForRepayment.remainingBalance || 0)
                }">
                  Remaining balance: ₱{{ parseFloat(selectedLoanForRepayment.remainingBalance || 0).toFixed(2) }}
                </p>
                <p v-if="selectedLoanForRepayment && parseFloat(repayForm.amount || 0) > parseFloat(selectedLoanForRepayment.remainingBalance || 0)" 
                  class="text-xs text-red-600 font-medium">
                  ⚠️ Amount exceeds remaining balance
                </p>
              </div>
            </div>

            <div>
              <label class="block text-sm text-gray-700 mb-2">Reference No</label>
              <input v-model="repayForm.referenceNo" type="text" placeholder="GCash Reference No."
                class="w-full px-4 py-3 border border-gray-300 rounded-lg" required />
            </div>

            <div>
              <label class="block text-sm text-gray-700 mb-2">Upload Payment Proof</label>
              <input type="file" @change="onFileChange" accept="image/*" class="w-full text-sm" required />
            </div>

            <div class="flex gap-3 pt-4">
              <button type="button" @click="closeRepaymentModal"
                class="flex-1 bg-gray-200 hover:bg-gray-300 text-gray-700 px-4 py-2 rounded-lg font-medium">
                Cancel
              </button>
              <button type="submit" :disabled="loading"
                class="flex-1 bg-green-600 hover:bg-green-700 disabled:opacity-50 text-white px-4 py-2 rounded-lg font-medium">
                {{ loading ? 'Processing...' : 'Submit Payment' }}
              </button>
            </div>
          </form>
        </div>
      </div>


      <!-- Loans Table -->
      <div class="bg-white/80 backdrop-blur-xl rounded-2xl shadow-xl p-6">
        <h2 class="text-xl font-semibold text-gray-800 mb-4">Your Loans</h2>

        <!-- Loading State -->
        <div v-if="loading" class="flex items-center justify-center py-8">
          <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-sky-600"></div>
          <span class="ml-2 text-gray-600">Loading loans...</span>
        </div>

        <!-- Loans Table -->
        <div v-else-if="loans.length > 0" class="overflow-x-auto">
          <table class="w-full border-collapse">
            <thead>
              <tr class="text-left text-gray-600">
                <th class="p-3">Loan ID</th>
                <th class="p-3">Date</th>
                <th class="p-3">Amount</th>
                <th class="p-3">Balance</th>
                <th class="p-3">Status</th>
                <th class="p-3">Term</th>
                <th class="p-3">Monthly Payment</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="loan in loans" :key="loan.loanID" class="border-t">
                <td class="p-3">{{ loan.loanID }}</td>
                <td class="p-3">{{ new Date(loan.createdAt).toLocaleDateString() }}</td>
                <td class="p-3">₱{{ parseFloat(loan.amount).toLocaleString() }}</td>
                <td class="p-3">₱{{ parseFloat(loan.remainingBalance).toLocaleString() }}</td>
                <td class="p-3">
                  <span :class="getStatusColor(loan.status)">{{ loan.status.charAt(0).toUpperCase() +
                    loan.status.slice(1) }}</span>
                </td>
                <td class="p-3">{{ loan.termMonths }} months</td>
                <td class="p-3">₱{{ parseFloat(loan.monthlyPayment || 0).toLocaleString() }}</td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Empty State -->
        <div v-else class="text-center py-8">
          <CreditCardIcon class="w-16 h-16 text-gray-300 mx-auto mb-4" />
          <p class="text-gray-500 text-lg mb-2">No loans found</p>
          <p class="text-gray-400">You haven't applied for any loans yet.</p>
        </div>
      </div>

      <!-- Repayments Table -->
      <div v-if="repayments.length > 0" class="bg-white/80 backdrop-blur-xl rounded-2xl shadow-xl p-6">
        <h2 class="text-xl font-semibold text-gray-800 mb-4">Repayment History</h2>
        <div class="overflow-x-auto">
          <table class="w-full border-collapse">
            <thead>
              <tr class="text-left text-gray-600">
                <th class="p-3">Date</th>
                <th class="p-3">Loan ID</th>
                <th class="p-3">Amount</th>
                <th class="p-3">Reference No</th>
                <th class="p-3">Payment Proof</th>
                <th class="p-3">Status</th>
                <th class="p-3">Notes</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="repayment in repayments" :key="repayment.repaymentID" class="border-t">
                <td class="p-3">{{ new Date(repayment.paymentDate).toLocaleDateString() }}</td>
                <td class="p-3">{{ repayment.loanID }}</td>
                <td class="p-3">₱{{ parseFloat(repayment.amount).toLocaleString() }}</td>
                <td class="p-3">{{ repayment.referenceNo || '-' }}</td>

                <!-- ✅ Payment Proof -->
                <td class="p-3">
                  <div v-if="repayment.paymentProof">
                    <img :src="`http://localhost:5000/uploads/paymentProofs/${repayment.paymentProof}`" alt="Payment Proof"
                      class="w-16 h-16 object-cover rounded cursor-pointer hover:scale-105 transition"
                      @click="previewImage(`http://localhost:5000/uploads/paymentProofs/${repayment.paymentProof}`)" />
                  </div>
                  <span v-else class="text-gray-400 italic">No proof</span>
                </td>

                <!-- ✅ Status -->
                <td class="p-3">
                  <span :class="getStatusColor(repayment.status)">
                    {{ repayment.status.charAt(0).toUpperCase() + repayment.status.slice(1) }}
                  </span>
                </td>

                <td class="p-3">{{ repayment.notes || '-' }}</td>
              </tr>
            </tbody>
          </table>
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

@keyframes blob {

  0%,
  100% {
    transform: translate(0, 0) scale(1)
  }

  33% {
    transform: translate(30px, -50px) scale(1.1)
  }

  66% {
    transform: translate(-20px, 20px) scale(0.9)
  }
}
</style>
