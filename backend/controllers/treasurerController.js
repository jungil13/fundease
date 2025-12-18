import pool from "../config/db.js";
import { sendEmail } from "../services/emailService.js";

// Get dashboard statistics for Treasurer
const getDashboardStats = async (req, res) => {
  try {
    const connection = await pool.getConnection();
    
    // Get fund balance (total contributions - total withdrawals + confirmed loan repayments)
    const [contributionsResult] = await connection.query(`
      SELECT COALESCE(SUM(amount), 0) as totalContributions
      FROM contributions 
      WHERE status = 'confirmed'
    `);

    const [withdrawalsResult] = await connection.query(`
      SELECT COALESCE(SUM(amount), 0) as totalWithdrawals
      FROM withdrawals 
      WHERE status = 'approved'
    `);

    const [loanRepaymentsResult] = await connection.query(`
      SELECT COALESCE(SUM(amount), 0) as totalLoanRepayments
      FROM loan_repayments 
      WHERE status = 'confirmed'
    `);

    // Use the already calculated contributions result
    const totalContributions = contributionsResult[0]?.totalContributions || 0;

    // Get total loans
    const [loansResult] = await connection.query(`
      SELECT COALESCE(SUM(amount), 0) as totalLoans
      FROM loans 
      WHERE status IN ('approved', 'disbursed', 'completed')
    `);

    // Get total loan payments
    const [loanPaymentsResult] = await connection.query(`
      SELECT COALESCE(SUM(amount), 0) as totalLoanPayments
      FROM loan_repayments 
      WHERE status = 'confirmed'
    `);

    // Get total interest earned
    const [interestResult] = await connection.query(`
      SELECT COALESCE(SUM(amount * interestRate), 0) as totalInterest
      FROM loans 
      WHERE status IN ('approved', 'disbursed', 'completed')
    `);

    // Get pending withdrawals count and amount
    const [pendingWithdrawalsResult] = await connection.query(`
      SELECT COUNT(*) as count, COALESCE(SUM(amount), 0) as amount
      FROM withdrawals 
      WHERE status = 'pending'
    `);

    // Calculate fund balance
    const fundBalance = parseFloat(totalContributions) - 
                       parseFloat(withdrawalsResult[0]?.totalWithdrawals || 0) +
                       parseFloat(loanRepaymentsResult[0]?.totalLoanRepayments || 0);

    const stats = {
      fundBalance: fundBalance,
      totalContributions: totalContributions,
      totalLoans: loansResult[0].totalLoans,
      totalLoanPayments: loanPaymentsResult[0].totalLoanPayments,
      totalInterest: interestResult[0].totalInterest,
      pendingWithdrawals: {
        count: pendingWithdrawalsResult[0].count,
        amount: pendingWithdrawalsResult[0].amount
      }
    };

    connection.release();
    res.json({ success: true, data: stats });
  } catch (error) {
    console.error('Error fetching treasurer dashboard stats:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

// Get pending withdrawal approvals
const getPendingWithdrawals = async (req, res) => {
  try {
    const connection = await pool.getConnection();
    
    const [withdrawals] = await connection.query(`
      SELECT 
        w.withdrawalID as id,
        CONCAT(u.firstName, ' ', u.lastName) as name,
        w.amount,
        w.reason,
        w.date,
        w.status,
        w.createdAt
      FROM withdrawals w
      JOIN members m ON w.memberID = m.memberID
      JOIN users u ON m.userID = u.userID
      WHERE w.status = 'pending'
      ORDER BY w.createdAt DESC
    `);

    connection.release();
    res.json({ success: true, data: withdrawals });
  } catch (error) {
    console.error('Error fetching pending withdrawals:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

// Get pending loan approvals
const getPendingLoans = async (req, res) => {
  try {
    const connection = await pool.getConnection();
    
    const [loans] = await connection.query(`
      SELECT 
        l.loanID as id,
        CONCAT(u.firstName, ' ', u.lastName) as name,
        l.amount,
        l.reason as purpose,
        l.createdAt as date,
        l.status,
        l.interestRate,
        l.termMonths,
        l.monthlyPayment
      FROM loans l
      JOIN members m ON l.memberID = m.memberID
      JOIN users u ON m.userID = u.userID
      WHERE l.status = 'pending'
      ORDER BY l.createdAt DESC
    `);

    connection.release();
    res.json({ success: true, data: loans });
  } catch (error) {
    console.error('Error fetching pending loans:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

// Get recent financial transactions
const getRecentTransactions = async (req, res) => {
  try {
    const connection = await pool.getConnection();
    
    // Get recent contributions
    const [contributions] = await connection.query(`
      SELECT 
        c.contributionID as id,
        CONCAT(u.firstName, ' ', u.lastName) as member,
        'contribution' as type,
        c.amount,
        c.contributionDate as date,
        c.status,
        c.createdAt
      FROM contributions c
      JOIN members m ON c.memberID = m.memberID
      JOIN users u ON m.userID = u.userID
      ORDER BY c.createdAt DESC
      LIMIT 10
    `);

    // Get recent loan payments
    const [loanPayments] = await connection.query(`
      SELECT 
        lr.repaymentID as id,
        CONCAT(u.firstName, ' ', u.lastName) as member,
        'loan_payment' as type,
        lr.amount,
        lr.paymentDate as date,
        lr.status,
        lr.createdAt
      FROM loan_repayments lr
      JOIN loans l ON lr.loanID = l.loanID
      JOIN members m ON l.memberID = m.memberID
      JOIN users u ON m.userID = u.userID
      ORDER BY lr.createdAt DESC
      LIMIT 10
    `);

    // Get recent withdrawals
    const [withdrawals] = await connection.query(`
      SELECT 
        w.withdrawalID as id,
        CONCAT(u.firstName, ' ', u.lastName) as member,
        'withdrawal' as type,
        w.amount,
        w.date,
        w.status,
        w.createdAt
      FROM withdrawals w
      JOIN members m ON w.memberID = m.memberID
      JOIN users u ON m.userID = u.userID
      ORDER BY w.createdAt DESC
      LIMIT 10
    `);

    // Combine and sort all transactions
    const allTransactions = [...contributions, ...loanPayments, ...withdrawals]
      .sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt))
      .slice(0, 10);

    connection.release();
    res.json({ success: true, data: allTransactions });
  } catch (error) {
    console.error('Error fetching recent transactions:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

// Approve withdrawal
const approveWithdrawal = async (req, res) => {
  try {
    const { withdrawalId } = req.params;
    const { notes } = req.body;
    const connection = await pool.getConnection();
    
    await connection.beginTransaction();

    // Update withdrawal status
    await connection.query(
      'UPDATE withdrawals SET status = ?, updatedAt = CURRENT_TIMESTAMP WHERE withdrawalID = ?',
      ['approved', withdrawalId]
    );

    // Get withdrawal details for notification
    const [withdrawalRows] = await connection.query(`
      SELECT 
        w.amount,
        w.reason,
        u.email,
        u.firstName,
        u.lastName
      FROM withdrawals w
      JOIN members m ON w.memberID = m.memberID
      JOIN users u ON m.userID = u.userID
      WHERE w.withdrawalID = ?
    `, [withdrawalId]);

    if (withdrawalRows.length > 0) {
      const withdrawal = withdrawalRows[0];
      
      // Create notification
      await connection.query(
        'INSERT INTO notifications (userID, title, message, type) VALUES (?, ?, ?, ?)',
        [req.user.userID, 'Withdrawal Approved', `Your withdrawal request of ₱${withdrawal.amount.toLocaleString()} has been approved.`, 'success']
      );

      // Send email notification
      await sendEmail(withdrawal.email, 'withdrawalApproved', {
        userName: `${withdrawal.firstName} ${withdrawal.lastName}`,
        amount: withdrawal.amount,
        reason: withdrawal.reason,
        notes: notes || 'No additional notes provided.'
      });
    }

    await connection.commit();
    connection.release();
    
    res.json({ success: true, message: 'Withdrawal approved successfully' });
  } catch (error) {
    await connection.rollback();
    connection.release();
    console.error('Error approving withdrawal:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

// Reject withdrawal
const rejectWithdrawal = async (req, res) => {
  try {
    const { withdrawalId } = req.params;
    const { reason } = req.body;
    const connection = await pool.getConnection();
    
    await connection.beginTransaction();

    // Update withdrawal status
    await connection.query(
      'UPDATE withdrawals SET status = ?, updatedAt = CURRENT_TIMESTAMP WHERE withdrawalID = ?',
      ['rejected', withdrawalId]
    );

    // Get withdrawal details for notification
    const [withdrawalRows] = await connection.query(`
      SELECT 
        w.amount,
        w.reason,
        u.email,
        u.firstName,
        u.lastName
      FROM withdrawals w
      JOIN members m ON w.memberID = m.memberID
      JOIN users u ON m.userID = u.userID
      WHERE w.withdrawalID = ?
    `, [withdrawalId]);

    if (withdrawalRows.length > 0) {
      const withdrawal = withdrawalRows[0];
      
      // Create notification
      await connection.query(
        'INSERT INTO notifications (userID, title, message, type) VALUES (?, ?, ?, ?)',
        [req.user.userID, 'Withdrawal Rejected', `Your withdrawal request of ₱${withdrawal.amount.toLocaleString()} has been rejected. Reason: ${reason}`, 'error']
      );

      // Send email notification
      await sendEmail(withdrawal.email, 'withdrawalRejected', {
        userName: `${withdrawal.firstName} ${withdrawal.lastName}`,
        amount: withdrawal.amount,
        reason: withdrawal.reason,
        rejectionReason: reason
      });
    }

    await connection.commit();
    connection.release();
    
    res.json({ success: true, message: 'Withdrawal rejected successfully' });
  } catch (error) {
    await connection.rollback();
    connection.release();
    console.error('Error rejecting withdrawal:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

// Approve loan
const approveLoan = async (req, res) => {
  try {
    const { loanId } = req.params;
    const { notes } = req.body;
    const connection = await pool.getConnection();
    
    await connection.beginTransaction();

    // Update loan status
    await connection.query(
      'UPDATE loans SET status = ?, approvedBy = ?, approvedAt = CURRENT_TIMESTAMP, updatedAt = CURRENT_TIMESTAMP WHERE loanID = ?',
      ['approved', req.user.userID, loanId]
    );

    // Get loan details for notification
    const [loanRows] = await connection.query(`
      SELECT 
        l.amount,
        l.reason,
        l.interestRate,
        l.termMonths,
        l.monthlyPayment,
        u.email,
        u.firstName,
        u.lastName
      FROM loans l
      JOIN members m ON l.memberID = m.memberID
      JOIN users u ON m.userID = u.userID
      WHERE l.loanID = ?
    `, [loanId]);

    if (loanRows.length > 0) {
      const loan = loanRows[0];
      
      // Create notification
      await connection.query(
        'INSERT INTO notifications (userID, title, message, type) VALUES (?, ?, ?, ?)',
        [req.user.userID, 'Loan Approved', `Your loan application of ₱${loan.amount.toLocaleString()} has been approved.`, 'success']
      );

      // Send email notification
      await sendEmail(loan.email, 'loanApproved', {
        userName: `${loan.firstName} ${loan.lastName}`,
        amount: loan.amount,
        reason: loan.reason,
        interestRate: loan.interestRate,
        termMonths: loan.termMonths,
        monthlyPayment: loan.monthlyPayment,
        notes: notes || 'No additional notes provided.'
      });
    }

    await connection.commit();
    connection.release();
    
    res.json({ success: true, message: 'Loan approved successfully' });
  } catch (error) {
    await connection.rollback();
    connection.release();
    console.error('Error approving loan:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

// Reject loan
const rejectLoan = async (req, res) => {
  try {
    const { loanId } = req.params;
    const { reason } = req.body;
    const connection = await pool.getConnection();
    
    await connection.beginTransaction();

    // Update loan status
    await connection.query(
      'UPDATE loans SET status = ?, approvedBy = ?, approvedAt = CURRENT_TIMESTAMP, updatedAt = CURRENT_TIMESTAMP WHERE loanID = ?',
      ['rejected', req.user.userID, loanId]
    );

    // Get loan details for notification
    const [loanRows] = await connection.query(`
      SELECT 
        l.amount,
        l.reason,
        u.email,
        u.firstName,
        u.lastName
      FROM loans l
      JOIN members m ON l.memberID = m.memberID
      JOIN users u ON m.userID = u.userID
      WHERE l.loanID = ?
    `, [loanId]);

    if (loanRows.length > 0) {
      const loan = loanRows[0];
      
      // Create notification
      await connection.query(
        'INSERT INTO notifications (userID, title, message, type) VALUES (?, ?, ?, ?)',
        [req.user.userID, 'Loan Rejected', `Your loan application of ₱${loan.amount.toLocaleString()} has been rejected. Reason: ${reason}`, 'error']
      );

      // Send email notification
      await sendEmail(loan.email, 'loanRejected', {
        userName: `${loan.firstName} ${loan.lastName}`,
        amount: loan.amount,
        reason: loan.reason,
        rejectionReason: reason
      });
    }

    await connection.commit();
    connection.release();
    
    res.json({ success: true, message: 'Loan rejected successfully' });
  } catch (error) {
    await connection.rollback();
    connection.release();
    console.error('Error rejecting loan:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

// Disburse loan
const disburseLoan = async (req, res) => {
  try {
    const { loanId } = req.params;
    const connection = await pool.getConnection();
    
    await connection.beginTransaction();

    // Get loan details
    const [loanRows] = await connection.query(`
      SELECT 
        l.loanID,
        l.memberID,
        l.userID,
        l.amount,
        l.reason,
        l.status,
        u.email,
        u.firstName,
        u.lastName,
        u.userID as memberUserID
      FROM loans l
      JOIN members m ON l.memberID = m.memberID
      JOIN users u ON m.userID = u.userID
      WHERE l.loanID = ?
    `, [loanId]);

    if (loanRows.length === 0) {
      await connection.rollback();
      connection.release();
      return res.status(404).json({ success: false, message: 'Loan not found' });
    }

    const loan = loanRows[0];

    // Check if loan is approved
    if (loan.status !== 'approved') {
      await connection.rollback();
      connection.release();
      return res.status(400).json({ 
        success: false, 
        message: `Loan must be approved before disbursement. Current status: ${loan.status}` 
      });
    }

    // Update loan status to disbursed
    await connection.query(
      'UPDATE loans SET status = ?, disbursedAt = CURRENT_TIMESTAMP, updatedAt = CURRENT_TIMESTAMP WHERE loanID = ?',
      ['disbursed', loanId]
    );

    // Create notification for member
    await connection.query(
      'INSERT INTO notifications (userID, title, message, type) VALUES (?, ?, ?, ?)',
      [loan.memberUserID, 'Loan Disbursed', `Your loan of ₱${loan.amount.toLocaleString()} has been disbursed. Please check your account.`, 'success']
    );

    // Send email notification
    await sendEmail(loan.email, 'loanDisbursed', {
      userName: `${loan.firstName} ${loan.lastName}`,
      amount: loan.amount,
      reason: loan.reason
    });

    await connection.commit();
    connection.release();
    
    res.json({ 
      success: true, 
      message: 'Loan disbursed successfully',
      data: {
        loanID: loan.loanID,
        memberName: `${loan.firstName} ${loan.lastName}`,
        amount: loan.amount
      }
    });
  } catch (error) {
    await connection.rollback();
    connection.release();
    console.error('Error disbursing loan:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

// Get loan details for disbursement
const getLoanForDisbursement = async (req, res) => {
  let connection;
  try {
    const { loanId } = req.params;
    connection = await pool.getConnection();
    
    const [loanRows] = await connection.query(`
      SELECT 
        l.loanID,
        l.memberID,
        l.amount,
        l.reason,
        l.status,
        l.interestRate,
        l.termMonths,
        l.monthlyPayment,
        CONCAT(u.firstName, ' ', u.lastName) as memberName,
        u.email,
        m.phone as memberPhone,
        m.gcash_qr_code,
        m.gcash_number
      FROM loans l
      JOIN members m ON l.memberID = m.memberID
      JOIN users u ON m.userID = u.userID
      WHERE l.loanID = ?
    `, [loanId]);

    // Format the response to include GCash QR URL if exists
    if (loanRows.length > 0 && loanRows[0].gcash_qr_code) {
      loanRows[0].gcash_qr_code_url = `/uploads/gcash-qr/${loanRows[0].gcash_qr_code}`;
    }

    connection.release();

    if (loanRows.length === 0) {
      return res.status(404).json({ success: false, message: 'Loan not found' });
    }

    res.json({ success: true, data: loanRows[0] });
  } catch (error) {
    if (connection) {
      connection.release();
    }
    console.error('Error fetching loan for disbursement:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
};

export {
  getDashboardStats,
  getPendingWithdrawals,
  getPendingLoans,
  getRecentTransactions,
  approveWithdrawal,
  rejectWithdrawal,
  approveLoan,
  rejectLoan,
  disburseLoan,
  getLoanForDisbursement
};
