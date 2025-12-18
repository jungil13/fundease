import pool from "../config/db.js";

export const getReportsData = async (req, res) => {
  try {
    const { period, startDate, endDate } = req.query;
    
    console.log('Getting reports data for period:', period, 'startDate:', startDate, 'endDate:', endDate);

    // Determine date range based on period
    let dateFilter = '';
    let params = [];
    
    if (period === 'month') {
      dateFilter = 'WHERE MONTH(createdAt) = MONTH(CURRENT_DATE()) AND YEAR(createdAt) = YEAR(CURRENT_DATE())';
    } else if (period === 'quarter') {
      dateFilter = 'WHERE QUARTER(createdAt) = QUARTER(CURRENT_DATE()) AND YEAR(createdAt) = YEAR(CURRENT_DATE())';
    } else if (period === 'year') {
      dateFilter = 'WHERE YEAR(createdAt) = YEAR(CURRENT_DATE())';
    } else if (period === 'custom' && startDate && endDate) {
      dateFilter = 'WHERE DATE(createdAt) BETWEEN ? AND ?';
      params = [startDate, endDate];
    }
    
    // If no period specified, default to all time
    if (!dateFilter) {
      dateFilter = '';
    }

    // Get fund balance and financial metrics - FIXED CALCULATION
    const [contributionsResult] = await pool.query(`
      SELECT COALESCE(SUM(amount), 0) as totalContributions
      FROM contributions 
      WHERE status = 'confirmed'
      ${dateFilter ? 'AND ' + dateFilter.replace('createdAt', 'contributionDate').replace('WHERE ', '') : ''}
    `, params);

    const [withdrawalsResult] = await pool.query(`
      SELECT COALESCE(SUM(amount), 0) as totalWithdrawals
      FROM withdrawals 
      WHERE status = 'approved'
      ${dateFilter ? 'AND ' + dateFilter.replace('createdAt', 'date').replace('WHERE ', '') : ''}
    `, params);

    const [loanRepaymentsResult] = await pool.query(`
      SELECT COALESCE(SUM(amount), 0) as totalLoanRepayments
      FROM loan_repayments 
      WHERE status = 'confirmed'
      ${dateFilter ? 'AND ' + dateFilter.replace('createdAt', 'paymentDate').replace('WHERE ', '') : ''}
    `, params);

    const [loansResult] = await pool.query(`
      SELECT 
        COALESCE(SUM(amount), 0) as totalLoans,
        COALESCE(SUM(amount * 0.05), 0) as totalInterest
      FROM loans 
      WHERE status IN ('approved', 'disbursed', 'active', 'completed')
      ${dateFilter ? 'AND ' + dateFilter.replace('WHERE ', '') : ''}
    `, params);
    
    console.log('Fund metrics calculated separately');
    console.log('Query params:', params);
    
    // Create fundMetrics object to match existing code structure
    const fundMetrics = [{
      totalContributions: contributionsResult[0]?.totalContributions || 0,
      totalWithdrawals: withdrawalsResult[0]?.totalWithdrawals || 0,
      totalLoans: loansResult[0]?.totalLoans || 0,
      totalInterest: loansResult[0]?.totalInterest || 0
    }];

    // Get member activity metrics
    const [memberMetrics] = await pool.query(`
      SELECT 
        COUNT(DISTINCT CASE WHEN m.status = 'active' THEN m.memberID END) as activeMembers,
        COUNT(DISTINCT CASE WHEN MONTH(m.createdAt) = MONTH(CURRENT_DATE()) AND YEAR(m.createdAt) = YEAR(CURRENT_DATE()) THEN m.memberID END) as newMembers,
        COUNT(DISTINCT CASE WHEN l.status = 'pending' THEN l.loanID END) as loanApplications,
        COUNT(DISTINCT CASE WHEN w.status = 'pending' THEN w.withdrawalID END) as withdrawalRequests
      FROM members m
      LEFT JOIN loans l ON m.memberID = l.memberID
      LEFT JOIN withdrawals w ON m.memberID = w.memberID
    `);

    // Get average metrics - handle date filtering separately for each table
    let averageQuery;
    if (dateFilter) {
      // If date filter is applied, we need to handle it carefully due to JOIN
      // Remove the "WHERE" from dateFilter since we're adding it manually
      const cleanDateFilter = dateFilter.replace('WHERE ', '');
      // Replace all instances of 'createdAt' with 'c.createdAt' for the contributions table
      const cleanDateFilterForContributions = cleanDateFilter.replace(/createdAt/g, 'c.createdAt');
      averageQuery = `
        SELECT 
          COALESCE(AVG(CASE WHEN c.status = 'confirmed' THEN c.amount END), 0) as averageContribution,
          COALESCE(AVG(CASE WHEN l.status IN ('approved', 'disbursed', 'active') THEN l.amount END), 0) as averageLoanAmount,
          COALESCE(
            (SELECT COUNT(*) FROM loan_repayments lr 
             JOIN loans l2 ON lr.loanID = l2.loanID 
             WHERE lr.status = 'confirmed' AND l2.status IN ('approved', 'disbursed', 'active')
            ) * 100.0 / 
            (SELECT COUNT(*) FROM loans l3 WHERE l3.status IN ('approved', 'disbursed', 'active')), 0
          ) as loanRepaymentRate
        FROM contributions c
        LEFT JOIN loans l ON c.memberID = l.memberID
        WHERE ${cleanDateFilterForContributions}
      `;
    } else {
      // No date filter, use the original query
      averageQuery = `
        SELECT 
          COALESCE(AVG(CASE WHEN c.status = 'confirmed' THEN c.amount END), 0) as averageContribution,
          COALESCE(AVG(CASE WHEN l.status IN ('approved', 'disbursed', 'active') THEN l.amount END), 0) as averageLoanAmount,
          COALESCE(
            (SELECT COUNT(*) FROM loan_repayments lr 
             JOIN loans l2 ON lr.loanID = l2.loanID 
             WHERE lr.status = 'confirmed' AND l2.status IN ('approved', 'disbursed', 'active')
            ) * 100.0 / 
            (SELECT COUNT(*) FROM loans l3 WHERE l3.status IN ('approved', 'disbursed', 'active')), 0
          ) as loanRepaymentRate
        FROM contributions c
        LEFT JOIN loans l ON c.memberID = l.memberID
      `;
    }
    
    console.log('Average metrics query:', averageQuery);
    console.log('Query params for average:', params);
    
    const [averageMetrics] = await pool.query(averageQuery, params);

    // Get recent transactions  
    const transactionsQuery = `
      (SELECT 
        'contribution' as type,
        c.contributionID as id,
        c.createdAt as date,
        CONCAT(u.firstName, ' ', u.lastName) as memberName,
        CONCAT('MEM', LPAD(m.memberID, 3, '0')) as memberId,
        c.amount,
        c.status
      FROM contributions c
      JOIN members m ON c.memberID = m.memberID
      JOIN users u ON m.userID = u.userID
      ${dateFilter ? dateFilter.replace(/createdAt/g, 'c.createdAt') : ''}
      ORDER BY c.createdAt DESC
      LIMIT 5)
      UNION ALL
      (SELECT 
        'loan' as type,
        l.loanID as id,
        l.createdAt as date,
        CONCAT(u.firstName, ' ', u.lastName) as memberName,
        CONCAT('MEM', LPAD(m.memberID, 3, '0')) as memberId,
        l.amount,
        l.status
      FROM loans l
      JOIN members m ON l.memberID = m.memberID
      JOIN users u ON m.userID = u.userID
      ${dateFilter ? dateFilter.replace(/createdAt/g, 'l.createdAt') : ''}
      ORDER BY l.createdAt DESC
      LIMIT 5)
      UNION ALL
      (SELECT 
        'withdrawal' as type,
        w.withdrawalID as id,
        w.createdAt as date,
        CONCAT(u.firstName, ' ', u.lastName) as memberName,
        CONCAT('MEM', LPAD(m.memberID, 3, '0')) as memberId,
        w.amount,
        w.status
      FROM withdrawals w
      JOIN members m ON w.memberID = m.memberID
      JOIN users u ON m.userID = u.userID
      ${dateFilter ? dateFilter.replace(/createdAt/g, 'w.createdAt') : ''}
      ORDER BY w.createdAt DESC
      LIMIT 5)
      ORDER BY date DESC
      LIMIT 10
    `;
    
    console.log('Transactions query:', transactionsQuery);
    const [recentTransactions] = await pool.query(transactionsQuery, dateFilter ? [params[0], params[1], params[0], params[1], params[0], params[1]] : []);

    // Get monthly overview for charts
    const [monthlyOverview] = await pool.query(`
      SELECT 
        DATE_FORMAT(createdAt, '%Y-%m') as month,
        SUM(CASE WHEN type = 'contribution' THEN amount ELSE 0 END) as contributions,
        SUM(CASE WHEN type = 'withdrawal' THEN amount ELSE 0 END) as withdrawals,
        SUM(CASE WHEN type = 'loan' THEN amount ELSE 0 END) as loans
      FROM (
        SELECT amount, createdAt, 'contribution' as type FROM contributions WHERE status = 'confirmed'
        UNION ALL
        SELECT amount, createdAt, 'withdrawal' as type FROM withdrawals WHERE status = 'approved'
        UNION ALL
        SELECT amount, createdAt, 'loan' as type FROM loans WHERE status IN ('approved', 'disbursed', 'active')
      ) as combined
      WHERE createdAt >= DATE_SUB(CURRENT_DATE(), INTERVAL 12 MONTH)
      GROUP BY DATE_FORMAT(createdAt, '%Y-%m')
      ORDER BY month ASC
    `);

    // Get weekly contribution report (last 8 weeks)
    const [weeklyContributions] = await pool.query(`
      SELECT 
        CONCAT(YEAR(contributionDate), '-W', LPAD(WEEK(contributionDate, 1), 2, '0')) as week,
        YEAR(contributionDate) as year,
        WEEK(contributionDate, 1) as weekNumber,
        DATE_FORMAT(DATE_SUB(contributionDate, INTERVAL WEEKDAY(contributionDate) DAY), '%M %d, %Y') as weekStart,
        DATE_FORMAT(DATE_ADD(DATE_SUB(contributionDate, INTERVAL WEEKDAY(contributionDate) DAY), INTERVAL 6 DAY), '%M %d, %Y') as weekEnd,
        COUNT(*) as contributionCount,
        COALESCE(SUM(amount), 0) as totalAmount,
        COUNT(DISTINCT memberID) as memberCount
      FROM contributions
      WHERE status = 'confirmed'
        AND contributionDate >= DATE_SUB(CURRENT_DATE(), INTERVAL 8 WEEK)
      GROUP BY YEAR(contributionDate), WEEK(contributionDate, 1), weekStart, weekEnd
      ORDER BY year DESC, weekNumber DESC
      LIMIT 8
    `);

    // Calculate fund balance correctly (contributions - withdrawals + loan repayments)
    const totalFundBalance = parseFloat(contributionsResult[0]?.totalContributions || 0) - 
                           parseFloat(withdrawalsResult[0]?.totalWithdrawals || 0) +
                           parseFloat(loanRepaymentsResult[0]?.totalLoanRepayments || 0);
    
    const fundUtilization = totalFundBalance > 0 ? 
      ((parseFloat(loansResult[0]?.totalLoans || 0) / totalFundBalance) * 100).toFixed(1) : 0;

    // Format the response
    const reportsData = {
      success: true,
      data: {
        keyMetrics: {
          totalFundBalance: totalFundBalance,
          totalContributions: parseFloat(contributionsResult[0]?.totalContributions || 0),
          activeLoans: parseFloat(loansResult[0]?.totalLoans || 0),
          interestEarned: parseFloat(loansResult[0]?.totalInterest || 0)
        },
        memberActivity: {
          activeMembers: memberMetrics[0]?.activeMembers || 0,
          newMembers: memberMetrics[0]?.newMembers || 0,
          loanApplications: memberMetrics[0]?.loanApplications || 0,
          withdrawalRequests: memberMetrics[0]?.withdrawalRequests || 0
        },
        financialSummary: {
          averageContribution: parseFloat(averageMetrics[0]?.averageContribution || 0),
          averageLoanAmount: parseFloat(averageMetrics[0]?.averageLoanAmount || 0),
          loanRepaymentRate: parseFloat(averageMetrics[0]?.loanRepaymentRate || 0),
          fundUtilization: parseFloat(fundUtilization)
        },
        recentTransactions: recentTransactions.map(transaction => ({
          id: transaction.id,
          date: transaction.date,
          memberName: transaction.memberName,
          memberId: transaction.memberId,
          type: transaction.type,
          amount: parseFloat(transaction.amount),
          status: transaction.status
        })),
        monthlyOverview: monthlyOverview.map(month => ({
          month: month.month,
          contributions: parseFloat(month.contributions || 0),
          withdrawals: parseFloat(month.withdrawals || 0),
          loans: parseFloat(month.loans || 0)
        })),
        weeklyContributions: weeklyContributions.map(week => ({
          week: week.week,
          weekNumber: week.weekNumber,
          weekStart: week.weekStart,
          weekEnd: week.weekEnd,
          contributionCount: parseInt(week.contributionCount || 0),
          totalAmount: parseFloat(week.totalAmount || 0),
          memberCount: parseInt(week.memberCount || 0)
        }))
      }
    };

    console.log('Reports data retrieved successfully');
    res.json(reportsData);
  } catch (err) {
    console.error('Reports error:', err);
    res.status(500).json({ 
      success: false, 
      message: "Server error", 
      error: err.message 
    });
  }
};

export const exportReport = async (req, res) => {
  try {
    const { format, period, startDate, endDate } = req.body;
    
    if (!format || !['excel', 'pdf'].includes(format)) {
      return res.status(400).json({
        success: false,
        message: "Invalid export format. Must be 'excel' or 'pdf'"
      });
    }

    // For now, return success message
    // In a real implementation, you would generate and return the actual file
    res.json({
      success: true,
      message: `${format.toUpperCase()} report generated successfully`,
      data: {
        downloadUrl: `/api/reports/download/${format}-${Date.now()}`,
        expiresAt: new Date(Date.now() + 24 * 60 * 60 * 1000) // 24 hours
      }
    });
  } catch (err) {
    console.error('Export error:', err);
    res.status(500).json({ 
      success: false, 
      message: "Server error", 
      error: err.message 
    });
  }
};
