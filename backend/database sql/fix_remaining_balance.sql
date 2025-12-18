-- Fix remainingBalance for existing loans to include interest
-- This updates all loans where remainingBalance equals the loan amount
-- (indicating they were created before the fix)
UPDATE loans 
SET remainingBalance = amount * (1 + interestRate)
WHERE remainingBalance = amount 
  AND remainingBalance > 0
  AND status IN ('pending', 'approved', 'disbursed', 'active');

