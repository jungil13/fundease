import LoanModel from "../models/loanModel.js";
import RepaymentModel from "../models/repaymentModel.js";

const RepaymentController = {
 async repayLoan(req, res) {
  try {
    const { loanID, userID, amount, paymentMethod, referenceNo, notes } = req.body;

    // ✅ If image uploaded, use filename
    const paymentProof = req.file ? req.file.filename : null;

    // Parse amount to ensure it's a number
    const repaymentAmount = parseFloat(amount);
    if (isNaN(repaymentAmount) || repaymentAmount <= 0) {
      return res.status(400).json({ success: false, message: "Invalid payment amount" });
    }

    const loan = await LoanModel.getLoanById(loanID);
    if (!loan) return res.status(404).json({ success: false, message: "Loan not found" });

    // Parse remaining balance to ensure it's a number
    const remainingBalance = parseFloat(loan.remainingBalance) || 0;

    if (remainingBalance <= 0)
      return res.status(400).json({ success: false, message: "Loan is already fully paid" });

    if (repaymentAmount > remainingBalance) {
      return res.status(400).json({ 
        success: false, 
        message: `Amount exceeds balance. Payment amount: ₱${repaymentAmount.toFixed(2)}, Remaining balance: ₱${remainingBalance.toFixed(2)}` 
      });
    }

    const repaymentID = await RepaymentModel.addRepayment({
      loanID,
      userID,
      amount: repaymentAmount,
      paymentMethod,
      paymentProof, // ✅ now stores filename
      referenceNo,
      notes,
    });

    const newBalance = remainingBalance - repaymentAmount;
    await LoanModel.updateBalance(loanID, newBalance);

    if (newBalance <= 0) await LoanModel.updateStatus(loanID, "completed");

    res.json({
      success: true,
      repaymentID,
      newBalance,
      message: newBalance <= 0 ? "Loan fully repaid and closed" : "Repayment successful",
    });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
},

 // ✅ Get all repayments
  async getAllRepayments(req, res) {
    try {
      const repayments = await RepaymentModel.getAllRepayments();
      res.json(repayments);
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  async getRepayments(req, res) {
    try {
      const { userID } = req.params;
      const repayments = await RepaymentModel.getRepaymentsByUser(userID);
      res.json(repayments);
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  // ✅ Update repayment status
  async updateRepaymentStatus(req, res) {
    try {
      const { repaymentID } = req.params;
      const { status, notes } = req.body;

      if (!["pending", "confirmed", "rejected"].includes(status)) {
        return res.status(400).json({ success: false, message: "Invalid status" });
      }

      const success = await RepaymentModel.updateStatus(repaymentID, status, notes);
      if (!success) {
        return res.status(404).json({ success: false, message: "Repayment not found" });
      }

      res.json({ success: true, message: `Repayment marked as ${status}` });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },
};

export default RepaymentController;
