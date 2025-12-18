-- Add paymentFrequency column to loans table
ALTER TABLE loans 
ADD COLUMN paymentFrequency ENUM('daily', 'weekly', 'monthly') DEFAULT 'monthly' 
AFTER termMonths;

