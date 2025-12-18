-- Add GCash QR code and GCash number fields to members table
ALTER TABLE `members` 
ADD COLUMN `gcash_qr_code` VARCHAR(255) DEFAULT NULL AFTER `emergencyPhone`,
ADD COLUMN `gcash_number` VARCHAR(20) DEFAULT NULL AFTER `gcash_qr_code`;

