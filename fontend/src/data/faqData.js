// FAQ Data for FundEase ChatBot
export const faqData = {
  // Registration & Authentication
  'how to register': {
    response: 'To register for FundEase, click the "Register" button in the top navigation. You\'ll need to provide your personal information, contact details, and create a secure password. Our team will review your application and approve it within 24-48 hours.',
    category: 'registration',
    keywords: ['register', 'sign up', 'join', 'membership', 'application']
  },
  'how to login': {
    response: 'You can login by clicking the "Login" button in the top navigation. Enter your email address and password that you used during registration. If you forgot your password, use the "Forgot Password" link.',
    category: 'authentication',
    keywords: ['login', 'sign in', 'access', 'enter']
  },
  'forgot password': {
    response: 'If you forgot your password, click "Forgot Password" on the login page. Enter your email address and we\'ll send you a reset link. Check your email and follow the instructions to create a new password.',
    category: 'authentication',
    keywords: ['forgot', 'password', 'reset', 'recover']
  },

  // Contributions
  'how to make contribution': {
    response: 'To make a contribution, login to your account and go to the "Contributions" section. Click "Add Contribution" and enter the amount you want to contribute. You can also set up automatic contributions for convenience.',
    category: 'contributions',
    keywords: ['contribution', 'contribute', 'deposit', 'add money', 'pay']
  },
  'contribution schedule': {
    response: 'Contributions are typically due monthly. You can check your contribution schedule in the "Contributions" section of your dashboard. You can also set up automatic contributions to avoid missing payments.',
    category: 'contributions',
    keywords: ['schedule', 'due date', 'when', 'monthly', 'automatic']
  },
  'contribution amount': {
    response: 'The minimum contribution amount varies by membership type. You can check the specific requirements in your member dashboard under "Contribution Requirements". You can contribute more than the minimum amount.',
    category: 'contributions',
    keywords: ['amount', 'minimum', 'how much', 'required', 'limit']
  },

  // Loans
  'how to apply for loan': {
    response: 'To apply for a loan, login and navigate to the "Loans" section. Click "Apply for Loan" and fill out the application form with your loan amount, purpose, and repayment terms. Your application will be reviewed by our committee.',
    category: 'loans',
    keywords: ['loan', 'apply', 'borrow', 'application', 'request']
  },
  'loan requirements': {
    response: 'To qualify for a loan, you must be an active member with regular contributions, have a good payment history, and meet the minimum contribution requirements. The maximum loan amount depends on your total contributions.',
    category: 'loans',
    keywords: ['requirements', 'qualify', 'eligibility', 'criteria', 'conditions']
  },
  'loan interest rate': {
    response: 'Our loan interest rates are competitive and vary based on loan type and amount. You can view current rates in the "Loans" section or contact our loan department for specific rate information.',
    category: 'loans',
    keywords: ['interest', 'rate', 'percentage', 'cost', 'fee']
  },
  'loan repayment': {
    response: 'Loan repayments are typically made monthly through automatic deductions or manual payments. You can view your repayment schedule and make payments in the "Loans" section of your dashboard.',
    category: 'loans',
    keywords: ['repayment', 'payment', 'installment', 'pay back', 'schedule']
  },

  // Withdrawals
  'how to withdraw': {
    response: 'To withdraw funds, go to the "Withdrawals" section in your dashboard. Click "Request Withdrawal" and specify the amount and reason. Withdrawals are subject to approval and may have processing times.',
    category: 'withdrawals',
    keywords: ['withdraw', 'withdrawal', 'cash out', 'get money', 'pull out']
  },
  'withdrawal limits': {
    response: 'Withdrawal limits depend on your account balance and membership type. You can withdraw up to your available balance, but some withdrawals may require committee approval for large amounts.',
    category: 'withdrawals',
    keywords: ['limit', 'maximum', 'how much', 'restriction', 'cap']
  },
  'withdrawal processing time': {
    response: 'Withdrawal processing times vary: standard withdrawals take 1-3 business days, while urgent withdrawals may be processed same-day for an additional fee. You\'ll receive notifications about your withdrawal status.',
    category: 'withdrawals',
    keywords: ['processing', 'time', 'how long', 'duration', 'when']
  },

  // Account & Balance
  'account balance': {
    response: 'You can check your account balance in the "Dashboard" section. It shows your total contributions, available balance, loan balance, and recent transactions.',
    category: 'account',
    keywords: ['balance', 'account', 'money', 'funds', 'total']
  },
  'transaction history': {
    response: 'You can view your complete transaction history in the "Transactions" section of your dashboard. This includes all contributions, loans, withdrawals, and payments with dates and amounts.',
    category: 'account',
    keywords: ['history', 'transactions', 'records', 'past', 'statement']
  },
  'account statement': {
    response: 'You can download your account statement from the "Reports" section. Statements are available monthly and include all your account activity, contributions, loans, and balances.',
    category: 'account',
    keywords: ['statement', 'report', 'download', 'pdf', 'summary']
  },

  // Payments
  'payment methods': {
    response: 'We accept various payment methods including bank transfers, online banking, mobile payments, and cash deposits at our office. You can also set up automatic payments for convenience.',
    category: 'payments',
    keywords: ['payment', 'method', 'how to pay', 'bank', 'online']
  },
  'payment failed': {
    response: 'If your payment failed, check your account balance and payment method. You can retry the payment or contact support if the issue persists. Failed payments don\'t incur penalties if resolved quickly.',
    category: 'payments',
    keywords: ['failed', 'error', 'problem', 'not working', 'declined']
  },
  'payment confirmation': {
    response: 'You\'ll receive payment confirmations via email and SMS. You can also check payment status in your dashboard under "Transactions". Keep your payment receipts for your records.',
    category: 'payments',
    keywords: ['confirmation', 'receipt', 'proof', 'status', 'notification']
  },

  // Support & Contact
  'contact support': {
    response: 'You can contact our support team through the "Contact Us" section in your dashboard, email us at support@fundease.com, or call our hotline. We typically respond within 24 hours during business days.',
    category: 'support',
    keywords: ['contact', 'support', 'help', 'assistance', 'customer service']
  },
  'office hours': {
    response: 'Our office is open Monday to Friday, 8:00 AM to 5:00 PM, and Saturday 9:00 AM to 1:00 PM. Online services are available 24/7. Emergency support is available for urgent matters.',
    category: 'support',
    keywords: ['hours', 'open', 'time', 'schedule', 'when']
  },
  'technical issues': {
    response: 'If you\'re experiencing technical issues, try refreshing your browser or clearing your cache. For persistent problems, contact our technical support team with details about the issue.',
    category: 'support',
    keywords: ['technical', 'bug', 'error', 'not working', 'problem']
  },

  // General Information
  'what is fundease': {
    response: 'FundEase is a comprehensive financial management system for organizations, providing services for managing contributions, loans, and withdrawals with ease and security. We help members achieve their financial goals.',
    category: 'general',
    keywords: ['what is', 'about', 'company', 'service', 'organization']
  },
  'benefits': {
    response: 'FundEase offers competitive loan rates, flexible contribution options, secure transactions, 24/7 online access, and excellent customer support. We help you build financial security and achieve your goals.',
    category: 'general',
    keywords: ['benefits', 'advantages', 'features', 'why', 'good']
  },
  'security': {
    response: 'FundEase uses bank-level security with SSL encryption, secure authentication, and regular security audits. Your personal and financial information is protected with industry-standard security measures.',
    category: 'general',
    keywords: ['security', 'safe', 'protected', 'privacy', 'secure']
  }
}

// Default responses for unmatched queries
export const defaultResponses = [
  'I\'m here to help with FundEase questions! You can ask me about registration, loans, contributions, withdrawals, or any other features.',
  'I can help you with FundEase services. Try asking about registration, loans, contributions, or contact support.',
  'Feel free to ask me anything about FundEase! I can help with account questions, loan applications, contributions, and more.',
  'How can I assist you with FundEase today? I can provide information about our services and help you navigate the platform.'
]

// Quick action suggestions
export const quickActions = [
  { text: 'How to register?', category: 'registration' },
  { text: 'Apply for loan', category: 'loans' },
  { text: 'Make contribution', category: 'contributions' },
  { text: 'Check balance', category: 'account' },
  { text: 'Contact support', category: 'support' },
  { text: 'Withdraw funds', category: 'withdrawals' },
  { text: 'Payment methods', category: 'payments' },
  { text: 'Account statement', category: 'account' }
]


