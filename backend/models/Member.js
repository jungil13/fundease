import pool from "../config/db.js";

const Member = {
  // Create a new member
    async create({ userID, phone, address, employment, monthlyIncome, emergencyContact, emergencyPhone, status = "pending" }) {
    const [res] = await pool.query(
      `INSERT INTO members 
       (userID, phone, address, employment, monthlyIncome, emergencyContact, emergencyPhone, status)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [userID, phone, address, employment, monthlyIncome, emergencyContact, emergencyPhone, status]
    );
    return res.insertId;
  },

  // Get all members with optional search
  async getAll(search = '') {
    const sql = `
      SELECT m.*, u.firstName, u.lastName, u.username, u.email
      FROM members m
      JOIN users u ON u.userID = m.userID
      WHERE u.firstName LIKE ? OR u.lastName LIKE ? OR u.username LIKE ?
      ORDER BY m.memberID DESC
    `;
    const [rows] = await pool.query(sql, [`%${search}%`, `%${search}%`, `%${search}%`]);
    return rows;
  },

  // Get a single member by ID
  async getById(memberID) {
    const sql = `
      SELECT m.*, u.firstName, u.lastName, u.username, u.email
      FROM members m
      JOIN users u ON u.userID = m.userID
      WHERE m.memberID = ?
    `;
    const [rows] = await pool.query(sql, [memberID]);
    return rows[0];
  },

  // Get transactions for a member
  async getTransactions(memberID) {
    const sql = `
      SELECT c.contributionID AS id, 'contribution' AS type, c.amount, c.status, c.paymentMethod, c.contributionDate AS date
      FROM contributions c
      WHERE c.memberID = ?

      UNION ALL

      SELECT l.loanID AS id, 'loan_payment' AS type, lr.amount, lr.status, lr.paymentMethod, lr.paymentDate AS date
      FROM loans l
      JOIN loan_repayments lr ON lr.loanID = l.loanID
      WHERE l.memberID = ?

      ORDER BY date DESC
    `;
    const [rows] = await pool.query(sql, [memberID, memberID]);
    return rows;
  },

  // Get transaction summary (totals)
  async getTransactionSummary(memberID) {
    // Total contributions (only confirmed)
    const [contributions] = await pool.query(`
      SELECT COALESCE(SUM(amount), 0) as total
      FROM contributions
      WHERE memberID = ? AND status = 'confirmed'
    `, [memberID]);

    // Total loans (all approved/disbursed loans)
    const [loans] = await pool.query(`
      SELECT COALESCE(SUM(amount), 0) as total
      FROM loans
      WHERE memberID = ? AND status IN ('approved', 'disbursed', 'completed')
    `, [memberID]);

    // Total repayments (only confirmed)
    const [repayments] = await pool.query(`
      SELECT COALESCE(SUM(lr.amount), 0) as total
      FROM loan_repayments lr
      JOIN loans l ON lr.loanID = l.loanID
      WHERE l.memberID = ? AND lr.status = 'confirmed'
    `, [memberID]);

    return {
      totalContributions: parseFloat(contributions[0].total) || 0,
      totalLoans: parseFloat(loans[0].total) || 0,
      totalRepayments: parseFloat(repayments[0].total) || 0
    };
  }
};

export default Member;
