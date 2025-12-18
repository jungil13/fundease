-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 05, 2025 at 11:46 AM                
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fundeases_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--    

CREATE TABLE `admins` (
  `adminID` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `role` enum('super_admin','treasurer','screening_committee') NOT NULL DEFAULT 'screening_committee',
  `isActive` tinyint(1) DEFAULT 1,
  `lastLogin` datetime DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`adminID`, `username`, `password`, `email`, `firstName`, `lastName`, `role`, `isActive`, `lastLogin`, `createdAt`, `updatedAt`) VALUES
(1, 'admin', '$2b$12$UsBsQGTdrdk7HWo374YWyuC0ge/HTNmxwuXFeZ8ESIotHd5GYN5Fq', 'admin@fundeases.com', 'System', 'Administrator', 'super_admin', 1, NULL, '2025-08-30 14:04:03', '2025-09-01 09:28:01');

-- --------------------------------------------------------

--
-- Table structure for table `contributions`
--

CREATE TABLE `contributions` (
  `contributionID` int(11) NOT NULL,
  `memberID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `paymentMethod` enum('cash','gcash','maya','bank_transfer','qrph') NOT NULL,
  `paymentProof` varchar(255) DEFAULT NULL,
  `referenceNo` varchar(100) DEFAULT NULL,
  `status` enum('pending','confirmed','rejected') DEFAULT 'pending',
  `contributionDate` date NOT NULL,
  `notes` text DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `paymongo_source_id` varchar(255) DEFAULT NULL,
  `paymongo_payment_id` varchar(255) DEFAULT NULL,
  `status_detail` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `contributions`
--

INSERT INTO `contributions` (`contributionID`, `memberID`, `userID`, `amount`, `paymentMethod`, `paymentProof`, `referenceNo`, `status`, `contributionDate`, `notes`, `createdAt`, `updatedAt`, `paymongo_source_id`, `paymongo_payment_id`, `status_detail`) VALUES
(1, 11, 11, 1500.00, 'cash', NULL, NULL, 'confirmed', '2025-06-04', 'Monthly contribution - cash', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(2, 11, 11, 1500.00, 'gcash', NULL, NULL, 'confirmed', '2025-06-29', 'Monthly contribution - gcash', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(3, 11, 11, 3000.00, 'cash', NULL, NULL, 'confirmed', '2025-07-20', 'Monthly contribution - cash', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(4, 11, 11, 1000.00, 'qrph', NULL, NULL, 'confirmed', '2025-08-21', 'Monthly contribution - qrph', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(5, 11, 11, 3000.00, 'maya', NULL, NULL, 'confirmed', '2025-08-31', 'Monthly contribution - maya', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(6, 12, 12, 2500.00, 'cash', NULL, NULL, 'confirmed', '2025-08-24', 'Monthly contribution - cash', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(7, 12, 12, 5000.00, 'maya', NULL, NULL, 'confirmed', '2025-08-25', 'Monthly contribution - maya', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(8, 12, 12, 1500.00, 'maya', NULL, NULL, 'confirmed', '2025-07-05', 'Monthly contribution - maya', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(9, 12, 12, 2000.00, 'qrph', NULL, NULL, 'confirmed', '2025-04-07', 'Monthly contribution - qrph', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(10, 13, 13, 1000.00, 'cash', NULL, NULL, 'confirmed', '2025-08-25', 'Monthly contribution - cash', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(11, 13, 13, 2000.00, 'gcash', NULL, NULL, 'confirmed', '2025-03-09', 'Monthly contribution - gcash', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(12, 13, 13, 1000.00, 'maya', NULL, NULL, 'confirmed', '2025-05-01', 'Monthly contribution - maya', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(13, 13, 13, 3000.00, 'qrph', NULL, NULL, 'confirmed', '2025-08-02', 'Monthly contribution - qrph', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(14, 13, 13, 5000.00, 'cash', NULL, NULL, 'confirmed', '2025-05-24', 'Monthly contribution - cash', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(15, 14, 14, 2000.00, 'gcash', NULL, NULL, 'confirmed', '2025-05-18', 'Monthly contribution - gcash', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(16, 14, 14, 2500.00, 'qrph', NULL, NULL, 'confirmed', '2025-06-24', 'Monthly contribution - qrph', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(17, 14, 14, 3000.00, 'maya', NULL, NULL, 'confirmed', '2025-08-18', 'Monthly contribution - maya', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(18, 15, 15, 5000.00, 'cash', NULL, NULL, 'confirmed', '2025-03-28', 'Monthly contribution - cash', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(19, 15, 15, 1000.00, 'cash', NULL, NULL, 'confirmed', '2025-04-09', 'Monthly contribution - cash', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(20, 15, 15, 2000.00, 'bank_transfer', NULL, NULL, 'confirmed', '2025-04-12', 'Monthly contribution - bank_transfer', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(21, 15, 15, 1500.00, 'cash', NULL, NULL, 'confirmed', '2025-03-09', 'Monthly contribution - cash', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(22, 16, 16, 3000.00, 'maya', NULL, NULL, 'confirmed', '2025-06-02', 'Monthly contribution - maya', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(23, 16, 16, 2000.00, 'maya', NULL, NULL, 'confirmed', '2025-05-12', 'Monthly contribution - maya', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(24, 16, 16, 2000.00, 'maya', NULL, NULL, 'confirmed', '2025-08-10', 'Monthly contribution - maya', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(25, 16, 16, 5000.00, 'maya', NULL, NULL, 'confirmed', '2025-07-04', 'Monthly contribution - maya', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(26, 16, 16, 1500.00, 'bank_transfer', NULL, NULL, 'confirmed', '2025-03-23', 'Monthly contribution - bank_transfer', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(27, 16, 16, 5000.00, 'cash', NULL, NULL, 'confirmed', '2025-03-20', 'Monthly contribution - cash', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(28, 16, 16, 5000.00, 'qrph', NULL, NULL, 'confirmed', '2025-08-27', 'Monthly contribution - qrph', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(29, 17, 17, 2000.00, 'cash', NULL, NULL, 'confirmed', '2025-07-06', 'Monthly contribution - cash', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(30, 17, 17, 2000.00, 'gcash', NULL, NULL, 'confirmed', '2025-08-09', 'Monthly contribution - gcash', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(31, 17, 17, 1000.00, 'gcash', NULL, NULL, 'confirmed', '2025-07-18', 'Monthly contribution - gcash', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(32, 17, 17, 3000.00, 'gcash', NULL, NULL, 'confirmed', '2025-03-23', 'Monthly contribution - gcash', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(33, 17, 17, 2500.00, 'bank_transfer', NULL, NULL, 'confirmed', '2025-03-23', 'Monthly contribution - bank_transfer', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(34, 17, 17, 2000.00, 'qrph', NULL, NULL, 'confirmed', '2025-05-17', 'Monthly contribution - qrph', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(35, 17, 17, 3000.00, 'qrph', NULL, NULL, 'confirmed', '2025-03-30', 'Monthly contribution - qrph', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(36, 17, 17, 2500.00, 'qrph', NULL, NULL, 'pending', '2025-04-19', 'Monthly contribution - qrph', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(37, 18, 18, 1500.00, 'cash', NULL, NULL, 'confirmed', '2025-05-05', 'Monthly contribution - cash', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(38, 18, 18, 2500.00, 'cash', NULL, NULL, 'confirmed', '2025-03-15', 'Monthly contribution - cash', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(39, 18, 18, 5000.00, 'gcash', NULL, NULL, 'confirmed', '2025-04-19', 'Monthly contribution - gcash', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(40, 18, 18, 2000.00, 'maya', NULL, NULL, 'confirmed', '2025-05-26', 'Monthly contribution - maya', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(41, 18, 18, 3000.00, 'cash', NULL, NULL, 'confirmed', '2025-06-27', 'Monthly contribution - cash', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(42, 18, 18, 3000.00, 'bank_transfer', NULL, NULL, 'confirmed', '2025-06-08', 'Monthly contribution - bank_transfer', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(43, 18, 18, 2000.00, 'gcash', NULL, NULL, 'confirmed', '2025-04-20', 'Monthly contribution - gcash', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(44, 18, 18, 1500.00, 'qrph', NULL, NULL, 'pending', '2025-05-07', 'Monthly contribution - qrph', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(45, 18, 18, 2000.00, 'gcash', NULL, NULL, 'confirmed', '2025-04-20', 'Monthly contribution - gcash', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(46, 18, 18, 1500.00, 'bank_transfer', NULL, NULL, 'confirmed', '2025-07-20', 'Monthly contribution - bank_transfer', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL, NULL),
(47, 19, 19, 5000.00, 'qrph', 'proof-1756959495805-336882176.jpg', '119255080054', 'confirmed', '2025-09-04', '', '2025-09-04 04:18:15', '2025-09-04 04:18:53', NULL, NULL, NULL),
(48, 20, 20, 3000.00, 'qrph', 'proof-1756976099099-621770603.png', '11925508080165', 'confirmed', '2025-09-04', '', '2025-09-04 08:54:59', '2025-09-04 10:52:04', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `loans`
--

CREATE TABLE `loans` (
  `loanID` int(11) NOT NULL,
  `memberID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `remainingBalance` decimal(12,2) NOT NULL DEFAULT 0.00,
  `reason` text NOT NULL,
  `status` enum('pending','approved','rejected','disbursed','completed') DEFAULT 'pending',
  `interestRate` decimal(5,2) DEFAULT 5.00,
  `termMonths` int(11) DEFAULT 12,
  `monthlyPayment` decimal(10,2) DEFAULT NULL,
  `approvedBy` int(11) DEFAULT NULL,
  `approvedAt` datetime DEFAULT NULL,
  `disbursedAt` datetime DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `loans`
--

INSERT INTO `loans` (`loanID`, `memberID`, `userID`, `amount`, `remainingBalance`, `reason`, `status`, `interestRate`, `termMonths`, `monthlyPayment`, `approvedBy`, `approvedAt`, `disbursedAt`, `notes`, `createdAt`, `updatedAt`) VALUES
(1, 11, 11, 15000.00, 11807.72, 'Vehicle purchase', 'approved', 0.05, 18, 875.00, NULL, NULL, NULL, NULL, '2025-09-04 02:17:21', '2025-09-04 02:17:21'),
(2, 12, 12, 50000.00, 37217.91, 'Wedding expenses', 'approved', 0.05, 24, 2187.50, NULL, NULL, NULL, NULL, '2025-09-04 02:17:21', '2025-09-04 02:17:21'),
(3, 13, 13, 30000.00, 20802.64, 'Education expenses', 'approved', 0.05, 12, 2625.00, NULL, NULL, NULL, NULL, '2025-09-04 02:17:21', '2025-09-04 02:17:21'),
(4, 15, 15, 100000.00, 66572.60, 'Home improvement', 'approved', 0.05, 36, 2916.67, NULL, NULL, NULL, NULL, '2025-09-04 02:17:21', '2025-09-04 02:17:21'),
(5, 16, 16, 25000.00, 10505.01, 'Investment opportunity', 'approved', 0.05, 6, 4375.00, NULL, NULL, NULL, NULL, '2025-09-04 02:17:21', '2025-09-04 02:17:21'),
(6, 17, 17, 10000.00, 8233.58, 'Vehicle purchase', 'approved', 0.05, 6, 1750.00, NULL, NULL, NULL, NULL, '2025-09-04 02:17:21', '2025-09-04 02:17:21'),
(7, 18, 18, 20000.00, 15507.77, 'Vehicle purchase', 'approved', 0.05, 36, 583.33, NULL, NULL, NULL, NULL, '2025-09-04 02:17:21', '2025-09-04 02:17:21'),
(8, 20, 20, 5000.00, 3250.00, 'School Fees', 'approved', 0.05, 3, 1750.00, NULL, NULL, NULL, NULL, '2025-09-04 08:55:22', '2025-09-04 10:49:57');

-- --------------------------------------------------------

--
-- Table structure for table `loan_repayments`
--

CREATE TABLE `loan_repayments` (
  `repaymentID` int(11) NOT NULL,
  `loanID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `paymentMethod` enum('cash','gcash','maya','bank_transfer') NOT NULL,
  `paymentProof` varchar(255) DEFAULT NULL,
  `referenceNo` varchar(100) DEFAULT NULL,
  `status` enum('pending','confirmed','rejected') DEFAULT 'pending',
  `paymentDate` date NOT NULL,
  `notes` text DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `loan_repayments`
--

INSERT INTO `loan_repayments` (`repaymentID`, `loanID`, `userID`, `amount`, `paymentMethod`, `paymentProof`, `referenceNo`, `status`, `paymentDate`, `notes`, `createdAt`, `updatedAt`) VALUES
(1, 1, 11, 3136.00, '', NULL, NULL, 'confirmed', '2025-07-23', 'Loan repayment - qrph', '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(2, 1, 11, 4210.00, 'gcash', NULL, NULL, 'confirmed', '2025-07-27', 'Loan repayment - gcash', '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(3, 1, 11, 1016.00, 'bank_transfer', NULL, NULL, 'confirmed', '2025-08-07', 'Loan repayment - bank_transfer', '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(4, 1, 11, 2941.00, 'bank_transfer', NULL, NULL, 'confirmed', '2025-08-10', 'Loan repayment - bank_transfer', '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(5, 1, 11, 2130.00, '', NULL, NULL, 'confirmed', '2025-09-02', 'Loan repayment - qrph', '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(6, 2, 12, 9034.00, 'gcash', NULL, NULL, 'confirmed', '2025-07-26', 'Loan repayment - gcash', '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(7, 2, 12, 9318.00, 'maya', NULL, NULL, 'confirmed', '2025-07-25', 'Loan repayment - maya', '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(8, 2, 12, 8611.00, 'bank_transfer', NULL, NULL, 'confirmed', '2025-08-19', 'Loan repayment - bank_transfer', '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(9, 2, 12, 4038.00, 'bank_transfer', NULL, NULL, 'confirmed', '2025-07-15', 'Loan repayment - bank_transfer', '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(10, 3, 13, 6826.00, '', NULL, NULL, 'confirmed', '2025-09-02', 'Loan repayment - qrph', '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(11, 4, 15, 20079.00, '', NULL, NULL, 'pending', '2025-08-11', 'Loan repayment - qrph', '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(12, 4, 15, 19904.00, '', NULL, NULL, 'confirmed', '2025-07-15', 'Loan repayment - qrph', '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(13, 4, 15, 4041.00, 'cash', NULL, NULL, 'confirmed', '2025-08-12', 'Loan repayment - cash', '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(14, 4, 15, 12915.00, 'cash', NULL, NULL, 'confirmed', '2025-07-30', 'Loan repayment - cash', '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(15, 5, 16, 1874.00, 'maya', NULL, NULL, 'confirmed', '2025-07-29', 'Loan repayment - maya', '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(16, 6, 17, 2661.00, 'maya', NULL, NULL, 'confirmed', '2025-08-16', 'Loan repayment - maya', '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(17, 6, 17, 1559.00, 'cash', NULL, NULL, 'pending', '2025-07-16', 'Loan repayment - cash', '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(18, 6, 17, 2547.00, 'cash', NULL, NULL, 'confirmed', '2025-07-25', 'Loan repayment - cash', '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(19, 6, 17, 2701.00, 'gcash', NULL, NULL, 'confirmed', '2025-09-02', 'Loan repayment - gcash', '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(20, 6, 17, 3262.00, 'bank_transfer', NULL, NULL, 'confirmed', '2025-07-23', 'Loan repayment - bank_transfer', '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(21, 7, 18, 1338.00, 'gcash', NULL, NULL, 'confirmed', '2025-07-07', 'Loan repayment - gcash', '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(22, 7, 18, 5645.00, '', NULL, NULL, 'confirmed', '2025-08-13', 'Loan repayment - qrph', '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(23, 7, 18, 1491.00, '', NULL, NULL, 'pending', '2025-07-22', 'Loan repayment - qrph', '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(24, 8, 20, 1750.00, 'gcash', 'proof-1756982997206-618270700.png', '1192550808156', 'confirmed', '2025-09-04', 'Loan repayment 1', '2025-09-04 10:49:57', '2025-09-04 10:51:21');

-- --------------------------------------------------------

--
-- Table structure for table `members`
--

CREATE TABLE `members` (
  `memberID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `employment` varchar(100) DEFAULT NULL,
  `monthlyIncome` decimal(10,2) DEFAULT NULL,
  `emergencyContact` varchar(100) DEFAULT NULL,
  `emergencyPhone` varchar(20) DEFAULT NULL,
  `status` enum('pending','active','suspended','inactive') DEFAULT 'pending',
  `membershipDate` date DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `members`
--

INSERT INTO `members` (`memberID`, `userID`, `phone`, `address`, `employment`, `monthlyIncome`, `emergencyContact`, `emergencyPhone`, `status`, `membershipDate`, `createdAt`, `updatedAt`) VALUES
(8, 8, '09917198428', 'Secreet', 'Self-employed', 20000.00, 'Kate', 'Jun Gil', 'active', NULL, '2025-09-01 14:08:39', '2025-09-03 17:20:07'),
(9, 9, '09917198428', 'Cordova Cebu', 'Employed', 20000.00, 'Kate', 'Jun Gil', 'active', NULL, '2025-09-01 17:19:02', '2025-09-03 17:20:12'),
(10, 10, '09917198428', 'Cordova Cebu', 'Employed', 20000.00, 'Kate ', 'Jun Gil', 'active', NULL, '2025-09-01 17:20:10', '2025-09-03 17:20:16'),
(11, 11, '+639172218405', '151 Street, Barangay 28, City', 'Self-employed', 55274.00, 'John Doe Sr.', '+639176665782', 'active', '2024-12-12', '2025-09-04 02:17:15', '2025-09-04 02:17:15'),
(12, 12, '+639170469901', '517 Street, Barangay 35, City', 'Employed', 25903.00, 'Jane Smith Sr.', '+639172357964', 'active', '2025-02-17', '2025-09-04 02:17:16', '2025-09-04 02:17:16'),
(13, 13, '+639172748261', '668 Street, Barangay 44, City', 'Business Owner', 32517.00, 'Mike Wilson Sr.', '+639175191266', 'active', '2025-06-19', '2025-09-04 02:17:16', '2025-09-04 02:17:16'),
(14, 14, '+639175980406', '116 Street, Barangay 7, City', 'Business Owner', 49577.00, 'Sarah Johnson Sr.', '+639173157090', 'active', '2024-10-03', '2025-09-04 02:17:18', '2025-09-04 02:17:18'),
(15, 15, '+639178822517', '727 Street, Barangay 47, City', 'Self-employed', 29197.00, 'David Brown Sr.', '+639179375294', 'active', '2024-10-13', '2025-09-04 02:17:18', '2025-09-04 02:17:18'),
(16, 16, '+639175724559', '381 Street, Barangay 15, City', 'Employed', 29562.00, 'Lisa Garcia Sr.', '+639179599120', 'active', '2025-02-18', '2025-09-04 02:17:19', '2025-09-04 02:17:19'),
(17, 17, '+639174242783', '459 Street, Barangay 9, City', 'Employed', 40374.00, 'Robert Miller Sr.', '+639179215739', 'active', '2025-06-13', '2025-09-04 02:17:20', '2025-09-04 02:17:20'),
(18, 18, '+639174106216', '179 Street, Barangay 44, City', 'Employed', 23260.00, 'Emily Davis Sr.', '+639173166151', 'active', '2025-05-09', '2025-09-04 02:17:21', '2025-09-04 02:17:21'),
(19, 19, '09917198428', 'Poblacion Cordova Cebu', 'Employed', 10000.00, 'Honey Kate Padilla', 'Renz Kayle Ando', 'active', '2025-09-04', '2025-09-04 04:06:54', '2025-09-04 05:06:31'),
(20, 20, '09917198428', 'Poblacion Cordova Cebu', 'Employed', 20000.00, 'Glendy Casquejo', 'Roydine Casquejo', 'active', NULL, '2025-09-04 05:13:19', '2025-09-04 06:25:31');

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `messageID` int(11) NOT NULL,
  `senderID` int(11) NOT NULL,
  `receiverID` int(11) NOT NULL,
  `message` text NOT NULL,
  `isRead` tinyint(1) DEFAULT 0,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`messageID`, `senderID`, `receiverID`, `message`, `isRead`, `createdAt`, `updatedAt`) VALUES
(1, 15, 10, 'Is there any update on my pending request?', 1, '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(2, 11, 9, 'Hello, I have a question about my loan application.', 0, '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(3, 12, 9, 'Can you please update my contribution status?', 0, '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(4, 11, 8, 'Is there any update on my pending request?', 1, '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(5, 15, 8, 'Can you please update my contribution status?', 1, '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(6, 13, 10, 'Thank you for the quick response on my application.', 0, '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(7, 11, 8, 'Hello, I have a question about my loan application.', 1, '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(8, 14, 10, 'I need help with my withdrawal request.', 1, '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(9, 12, 8, 'Thank you for the quick response on my application.', 1, '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(10, 16, 9, 'Hello, I have a question about my loan application.', 0, '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(11, 19, 8, 'Hi admin naa rakoy ask', 0, '2025-09-04 04:16:30', '2025-09-04 04:16:30'),
(12, 8, 19, 'oo?', 1, '2025-09-04 04:16:36', '2025-09-04 04:16:49'),
(13, 20, 8, 'hi', 0, '2025-09-04 11:06:21', '2025-09-04 11:06:21'),
(14, 8, 20, 'hello', 1, '2025-09-04 11:06:38', '2025-09-04 11:06:47');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `notificationID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `type` enum('info','success','warning','error') DEFAULT 'info',
  `isRead` tinyint(1) DEFAULT 0,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`notificationID`, `userID`, `title`, `message`, `type`, `isRead`, `createdAt`, `updatedAt`) VALUES
(1, 11, 'Welcome to FundEases!', 'Thank you for joining our community. Your membership has been activated.', 'success', 1, '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(2, 11, 'Contribution Confirmed', 'Your recent contribution has been confirmed and added to your account.', 'success', 1, '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(3, 11, 'Welcome to FundEases!', 'Thank you for joining our community. Your membership has been activated.', 'success', 1, '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(4, 11, 'Withdrawal Approved', 'Your withdrawal request has been approved and will be processed soon.', 'success', 1, '2025-09-04 02:17:22', '2025-09-04 20:54:07'),
(5, 12, 'Welcome to FundEases!', 'Thank you for joining our community. Your membership has been activated.', 'success', 1, '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(6, 12, 'Loan Application Update', 'Your loan application status has been updated. Please check your account.', 'info', 0, '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(7, 12, 'Loan Application Update', 'Your loan application status has been updated. Please check your account.', 'info', 0, '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(8, 12, 'Contribution Confirmed', 'Your recent contribution has been confirmed and added to your account.', 'success', 1, '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(9, 13, 'Contribution Confirmed', 'Your recent contribution has been confirmed and added to your account.', 'success', 1, '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(10, 13, 'Welcome to FundEases!', 'Thank you for joining our community. Your membership has been activated.', 'success', 1, '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(11, 14, 'Loan Application Update', 'Your loan application status has been updated. Please check your account.', 'info', 1, '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(12, 14, 'Contribution Confirmed', 'Your recent contribution has been confirmed and added to your account.', 'success', 1, '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(13, 15, 'Welcome to FundEases!', 'Thank you for joining our community. Your membership has been activated.', 'success', 1, '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(14, 15, 'Welcome to FundEases!', 'Thank you for joining our community. Your membership has been activated.', 'success', 1, '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(15, 15, 'Payment Reminder', 'This is a friendly reminder about your upcoming loan payment.', 'warning', 0, '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(16, 16, 'Loan Application Update', 'Your loan application status has been updated. Please check your account.', 'info', 1, '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(17, 16, 'Payment Reminder', 'This is a friendly reminder about your upcoming loan payment.', 'warning', 1, '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(18, 17, 'Payment Reminder', 'This is a friendly reminder about your upcoming loan payment.', 'warning', 0, '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(19, 17, 'Contribution Confirmed', 'Your recent contribution has been confirmed and added to your account.', 'success', 1, '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(20, 18, 'Welcome to FundEases!', 'Thank you for joining our community. Your membership has been activated.', 'success', 0, '2025-09-04 02:17:22', '2025-09-04 02:17:22'),
(21, 19, 'Registration Approved!', 'Congratulations! Your membership has been approved. You can now access all member features.', 'success', 0, '2025-09-04 04:10:54', '2025-09-04 04:10:54'),
(22, 19, 'Membership Suspended', 'Your membership has been suspended. Reason: try ra nako ang sandbox', 'warning', 0, '2025-09-04 04:45:22', '2025-09-04 04:45:22'),
(23, 19, 'Membership Reactivated', 'Your membership has been reactivated. You can now access all member features.', 'success', 0, '2025-09-04 04:48:18', '2025-09-04 04:48:18'),
(24, 19, 'Membership Suspended', 'Your membership has been suspended. Reason: try lang', 'warning', 0, '2025-09-04 04:52:20', '2025-09-04 04:52:20'),
(25, 19, 'Membership Reactivated', 'Your membership has been reactivated. You can now access all member features.', 'success', 0, '2025-09-04 04:55:32', '2025-09-04 04:55:32'),
(26, 19, 'Membership Suspended', 'Your membership has been suspended. Reason: Sorry pero di taka bet huhuhuh', 'warning', 0, '2025-09-04 05:03:42', '2025-09-04 05:03:42'),
(27, 19, 'Membership Reactivated', 'Your membership has been reactivated. You can now access all member features.', 'success', 0, '2025-09-04 05:06:36', '2025-09-04 05:06:36'),
(28, 20, 'Registration Rejected', 'Your registration has been rejected. Reason: Waragud', 'error', 1, '2025-09-04 05:49:57', '2025-09-04 10:33:30'),
(29, 20, 'Membership Suspended', 'Your membership has been suspended. Reason: sorrryyyy', 'warning', 1, '2025-09-04 06:04:25', '2025-09-04 10:33:30'),
(30, 20, 'Membership Reactivated', 'Your membership has been reactivated. You can now access all member features.', 'success', 1, '2025-09-04 06:25:38', '2025-09-04 10:33:30');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `userID` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `role` enum('member','admin','screening_committee','treasurer') NOT NULL DEFAULT 'member',
  `isActive` tinyint(1) DEFAULT 1,
  `lastLogin` datetime DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `resetToken` varchar(255) DEFAULT NULL,
  `resetTokenExpiry` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`userID`, `username`, `password`, `email`, `firstName`, `lastName`, `role`, `isActive`, `lastLogin`, `createdAt`, `updatedAt`, `resetToken`, `resetTokenExpiry`) VALUES
(8, 'admin', '$2b$12$CEcMgeuGb9M8jJSrvv6QjuAwgoKSK88FcqedknrniSMgawmXMfLiq', 'admin@gmail.com', 'Admin', 'User', 'admin', 1, NULL, '2025-09-01 14:08:39', '2025-09-01 14:08:50', NULL, NULL),
(9, 'committee', '$2b$12$Jerx3UzGciwbu/nPAMPymuPN4U3xHZ6PLlxvf5IL3eQ.IYdTayOSS', 'committee@gmail.com', 'Committee', 'User', 'screening_committee', 1, NULL, '2025-09-01 17:19:02', '2025-09-01 17:19:15', NULL, NULL),
(10, 'treasurer', '$2b$12$ZVRQxjF4wlAO/XlCD/YmVeGRb4mjeHOtJOuuWWBTBNsduPQ.dN7ju', 'treasurer@gmail.com', 'Treasurer', 'User', 'treasurer', 1, NULL, '2025-09-01 17:20:10', '2025-09-01 17:20:23', NULL, NULL),
(11, 'john_doe', '$2b$12$Ru5mn9mOReIUo/1duAUz7Ol0I5nU7I2m3dr75HFQAo9ui2SDFkvQW', 'john.doe@email.com', 'John', 'Doe', 'member', 1, NULL, '2025-09-04 02:17:15', '2025-09-04 02:17:15', NULL, NULL),
(12, 'jane_smith', '$2b$12$le8/eSjAig1yhG7LOAM8nOKBOVFFI8b4xH3IrKnvfD8msLIdDhWIi', 'jane.smith@email.com', 'Jane', 'Smith', 'member', 1, NULL, '2025-09-04 02:17:16', '2025-09-04 02:17:16', NULL, NULL),
(13, 'mike_wilson', '$2b$12$yqV7KjxmhFgd5O3HmYJ1XuCl9MGTDecKIZ3rpZBGKpPYQWbTARwSu', 'mike.wilson@email.com', 'Mike', 'Wilson', 'member', 1, NULL, '2025-09-04 02:17:16', '2025-09-04 02:17:16', NULL, NULL),
(14, 'sarah_johnson', '$2b$12$Gt2Kak6f1IwEccNfA7jzbeoxEpzfqVZ95/nj6Y6SNKMu2RnWvnxJ.', 'sarah.johnson@email.com', 'Sarah', 'Johnson', 'member', 1, NULL, '2025-09-04 02:17:18', '2025-09-04 02:17:18', NULL, NULL),
(15, 'david_brown', '$2b$12$dPf0GdptarDE6dKA1KaZl.b7f1AXGIrc1oUnx9GQLedWkpfYOR5SK', 'david.brown@email.com', 'David', 'Brown', 'member', 1, NULL, '2025-09-04 02:17:18', '2025-09-04 02:17:18', NULL, NULL),
(16, 'lisa_garcia', '$2b$12$AAibkATDcoO5Rr18sa0X4u4J0GxhtjscjHv1f7jAWb8lDaDd/IbbO', 'lisa.garcia@email.com', 'Lisa', 'Garcia', 'member', 1, NULL, '2025-09-04 02:17:19', '2025-09-04 02:17:19', NULL, NULL),
(17, 'robert_miller', '$2b$12$d5bAy7WLbaoFFcrX1zmdZugTepTsVm/yqAVRZeMEEYozJiIyTSVua', 'robert.miller@email.com', 'Robert', 'Miller', 'member', 1, NULL, '2025-09-04 02:17:20', '2025-09-04 02:17:20', NULL, NULL),
(18, 'emily_davis', '$2b$12$4FwUv8aoj73kTMUXqSb2HuJVqKBvO15nrAQwDXMIaC.ElrqX6QKoK', 'emily.davis@email.com', 'Emily', 'Davis', 'member', 1, NULL, '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL, NULL),
(19, 'jungil', '$2b$12$J/U164nNgGYescPmpx3rq.zkOSmbps4WP5bct5oRDVNb.TJN0sDda', 'jungilcasquejo5@gmail.com', 'Jun Gil', 'Casquejo', 'member', 1, NULL, '2025-09-04 04:06:54', '2025-09-04 05:06:31', NULL, NULL),
(20, 'dondon', '$2b$12$qjY4veJQnED8ov67gvC9leEaGtgGXW4f5ORO/GjjSq9rztKxVeeae', 'dondonborres1@gmail.com', 'Don Don', 'Casquejo', 'member', 1, NULL, '2025-09-04 05:13:19', '2025-09-04 06:38:52', 'r838xz6j2rkx53dei197k', '2025-09-04 14:53:52');

-- --------------------------------------------------------

--
-- Table structure for table `withdrawals`
--

CREATE TABLE `withdrawals` (
  `withdrawalID` int(11) NOT NULL,
  `memberID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `reason` text NOT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `date` date NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `withdrawals`
--

INSERT INTO `withdrawals` (`withdrawalID`, `memberID`, `userID`, `amount`, `reason`, `status`, `date`, `createdAt`, `updatedAt`, `notes`) VALUES
(1, 11, 11, 8000.00, 'Medical expenses', 'approved', '2025-06-29', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL),
(2, 13, 13, 3000.00, 'Emergency fund', 'approved', '2025-08-10', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL),
(3, 14, 14, 3000.00, 'Travel expenses', 'approved', '2025-07-15', '2025-09-04 02:17:21', '2025-09-04 02:17:21', NULL),
(4, 18, 18, 5000.00, 'Travel expenses', 'rejected', '2025-06-23', '2025-09-04 02:17:22', '2025-09-04 02:17:22', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`adminID`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_username` (`username`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_role` (`role`);

--
-- Indexes for table `contributions`
--
ALTER TABLE `contributions`
  ADD PRIMARY KEY (`contributionID`),
  ADD KEY `idx_memberID` (`memberID`),
  ADD KEY `idx_userID` (`userID`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_contributionDate` (`contributionDate`),
  ADD KEY `idx_paymentMethod` (`paymentMethod`),
  ADD KEY `idx_contributions_amount` (`amount`),
  ADD KEY `idx_contributions_status` (`status`),
  ADD KEY `idx_contributions_date` (`contributionDate`),
  ADD KEY `idx_contributions_member` (`memberID`),
  ADD KEY `idx_contributions_user` (`userID`);

--
-- Indexes for table `loans`
--
ALTER TABLE `loans`
  ADD PRIMARY KEY (`loanID`),
  ADD KEY `idx_memberID` (`memberID`),
  ADD KEY `idx_userID` (`userID`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_approvedBy` (`approvedBy`),
  ADD KEY `idx_createdAt` (`createdAt`),
  ADD KEY `idx_loans_amount` (`amount`),
  ADD KEY `idx_loans_status` (`status`),
  ADD KEY `idx_loans_member` (`memberID`),
  ADD KEY `idx_loans_user` (`userID`),
  ADD KEY `idx_loans_created` (`createdAt`);

--
-- Indexes for table `loan_repayments`
--
ALTER TABLE `loan_repayments`
  ADD PRIMARY KEY (`repaymentID`),
  ADD KEY `idx_loanID` (`loanID`),
  ADD KEY `idx_userID` (`userID`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_paymentDate` (`paymentDate`),
  ADD KEY `idx_paymentMethod` (`paymentMethod`),
  ADD KEY `idx_loan_repayments_amount` (`amount`),
  ADD KEY `idx_repayments_status` (`status`),
  ADD KEY `idx_repayments_loan` (`loanID`),
  ADD KEY `idx_repayments_user` (`userID`),
  ADD KEY `idx_repayments_date` (`paymentDate`);

--
-- Indexes for table `members`
--
ALTER TABLE `members`
  ADD PRIMARY KEY (`memberID`),
  ADD KEY `idx_userID` (`userID`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_membershipDate` (`membershipDate`),
  ADD KEY `idx_members_status` (`status`),
  ADD KEY `idx_members_user` (`userID`),
  ADD KEY `idx_members_membership` (`membershipDate`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`messageID`),
  ADD KEY `idx_senderID` (`senderID`),
  ADD KEY `idx_receiverID` (`receiverID`),
  ADD KEY `idx_isRead` (`isRead`),
  ADD KEY `idx_createdAt` (`createdAt`),
  ADD KEY `idx_messages_created_at` (`createdAt`),
  ADD KEY `idx_messages_sender` (`senderID`),
  ADD KEY `idx_messages_receiver` (`receiverID`),
  ADD KEY `idx_messages_read` (`isRead`),
  ADD KEY `idx_messages_created` (`createdAt`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notificationID`),
  ADD KEY `idx_userID` (`userID`),
  ADD KEY `idx_isRead` (`isRead`),
  ADD KEY `idx_type` (`type`),
  ADD KEY `idx_createdAt` (`createdAt`),
  ADD KEY `idx_notifications_created_at` (`createdAt`),
  ADD KEY `idx_notifications_user` (`userID`),
  ADD KEY `idx_notifications_read` (`isRead`),
  ADD KEY `idx_notifications_type` (`type`),
  ADD KEY `idx_notifications_created` (`createdAt`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`userID`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_username` (`username`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_role` (`role`),
  ADD KEY `idx_users_role` (`role`),
  ADD KEY `idx_users_username` (`username`),
  ADD KEY `idx_users_email` (`email`),
  ADD KEY `idx_users_active` (`isActive`);

--
-- Indexes for table `withdrawals`
--
ALTER TABLE `withdrawals`
  ADD PRIMARY KEY (`withdrawalID`),
  ADD KEY `idx_memberID` (`memberID`),
  ADD KEY `idx_userID` (`userID`),
  ADD KEY `idx_withdrawals_status` (`status`),
  ADD KEY `idx_withdrawals_member` (`memberID`),
  ADD KEY `idx_withdrawals_user` (`userID`),
  ADD KEY `idx_withdrawals_date` (`date`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `adminID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `contributions`
--
ALTER TABLE `contributions`
  MODIFY `contributionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `loans`
--
ALTER TABLE `loans`
  MODIFY `loanID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `loan_repayments`
--
ALTER TABLE `loan_repayments`
  MODIFY `repaymentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `members`
--
ALTER TABLE `members`
  MODIFY `memberID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `messageID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notificationID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `userID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `withdrawals`
--
ALTER TABLE `withdrawals`
  MODIFY `withdrawalID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `contributions`
--
ALTER TABLE `contributions`
  ADD CONSTRAINT `contributions_ibfk_1` FOREIGN KEY (`memberID`) REFERENCES `members` (`memberID`) ON DELETE CASCADE,
  ADD CONSTRAINT `contributions_ibfk_2` FOREIGN KEY (`userID`) REFERENCES `users` (`userID`) ON DELETE CASCADE;

--
-- Constraints for table `loans`
--
ALTER TABLE `loans`
  ADD CONSTRAINT `loans_ibfk_1` FOREIGN KEY (`memberID`) REFERENCES `members` (`memberID`) ON DELETE CASCADE,
  ADD CONSTRAINT `loans_ibfk_2` FOREIGN KEY (`userID`) REFERENCES `users` (`userID`) ON DELETE CASCADE,
  ADD CONSTRAINT `loans_ibfk_3` FOREIGN KEY (`approvedBy`) REFERENCES `admins` (`adminID`) ON DELETE SET NULL;

--
-- Constraints for table `loan_repayments`
--
ALTER TABLE `loan_repayments`
  ADD CONSTRAINT `loan_repayments_ibfk_1` FOREIGN KEY (`loanID`) REFERENCES `loans` (`loanID`) ON DELETE CASCADE,
  ADD CONSTRAINT `loan_repayments_ibfk_2` FOREIGN KEY (`userID`) REFERENCES `users` (`userID`) ON DELETE CASCADE;

--
-- Constraints for table `members`
--
ALTER TABLE `members`
  ADD CONSTRAINT `members_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `users` (`userID`) ON DELETE CASCADE;

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`senderID`) REFERENCES `users` (`userID`) ON DELETE CASCADE,
  ADD CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`receiverID`) REFERENCES `users` (`userID`) ON DELETE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `users` (`userID`) ON DELETE CASCADE;

--
-- Constraints for table `withdrawals`
--
ALTER TABLE `withdrawals`
  ADD CONSTRAINT `withdrawals_ibfk_1` FOREIGN KEY (`memberID`) REFERENCES `members` (`memberID`) ON DELETE CASCADE,
  ADD CONSTRAINT `withdrawals_ibfk_2` FOREIGN KEY (`userID`) REFERENCES `users` (`userID`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
