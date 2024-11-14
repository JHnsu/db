-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 14, 2024 at 06:51 AM
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
-- Database: `techinventory`
--

-- --------------------------------------------------------

--
-- Table structure for table `audittrail`
--

CREATE TABLE `audittrail` (
  `AuditID` int(11) NOT NULL,
  `UserID` int(11) DEFAULT NULL,
  `ItemID` int(11) DEFAULT NULL,
  `Action` varchar(50) NOT NULL,
  `ActionDate` timestamp NOT NULL DEFAULT current_timestamp(),
  `PreviousStockLevel` int(11) DEFAULT NULL,
  `NewStockLevel` int(11) DEFAULT NULL,
  `Description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

CREATE TABLE `inventory` (
  `ItemID` int(11) NOT NULL,
  `ItemName` varchar(100) NOT NULL,
  `Category` varchar(50) DEFAULT NULL,
  `Location` varchar(50) DEFAULT NULL,
  `StockLevel` int(11) DEFAULT 0,
  `MinimumStockLevel` int(11) DEFAULT 0,
  `SupplierID` int(11) DEFAULT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `UpdatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `purchaseorders`
--

CREATE TABLE `purchaseorders` (
  `PurchaseOrderID` int(11) NOT NULL,
  `SupplierID` int(11) DEFAULT NULL,
  `CreatedBy` int(11) DEFAULT NULL,
  `OrderDate` timestamp NOT NULL DEFAULT current_timestamp(),
  `Status` enum('Pending','Completed','Cancelled') DEFAULT 'Pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `restockrequests`
--

CREATE TABLE `restockrequests` (
  `RequestID` int(11) NOT NULL,
  `ItemID` int(11) DEFAULT NULL,
  `RequestedBy` int(11) DEFAULT NULL,
  `QuantityRequested` int(11) DEFAULT NULL,
  `RequestStatus` enum('Pending','Approved','Rejected') DEFAULT 'Pending',
  `RequestDate` timestamp NOT NULL DEFAULT current_timestamp(),
  `ApprovedBy` int(11) DEFAULT NULL,
  `ApprovalDate` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `SupplierID` int(11) NOT NULL,
  `SupplierName` varchar(100) NOT NULL,
  `ContactEmail` varchar(100) DEFAULT NULL,
  `ContactPhone` varchar(20) DEFAULT NULL,
  `Address` text DEFAULT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `UserID` int(11) NOT NULL,
  `FirstName` varchar(100) NOT NULL,
  `SurName` varchar(100) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `AccountPassword` varchar(255) NOT NULL,
  `Role` enum('Admin','Staff') NOT NULL,
  `ProfilePicture` varchar(255) DEFAULT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `UpdatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `audittrail`
--
ALTER TABLE `audittrail`
  ADD PRIMARY KEY (`AuditID`),
  ADD KEY `UserID` (`UserID`),
  ADD KEY `ItemID` (`ItemID`);

--
-- Indexes for table `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`ItemID`),
  ADD KEY `SupplierID` (`SupplierID`);

--
-- Indexes for table `purchaseorders`
--
ALTER TABLE `purchaseorders`
  ADD PRIMARY KEY (`PurchaseOrderID`),
  ADD KEY `SupplierID` (`SupplierID`),
  ADD KEY `CreatedBy` (`CreatedBy`);

--
-- Indexes for table `restockrequests`
--
ALTER TABLE `restockrequests`
  ADD PRIMARY KEY (`RequestID`),
  ADD KEY `ItemID` (`ItemID`),
  ADD KEY `RequestedBy` (`RequestedBy`),
  ADD KEY `ApprovedBy` (`ApprovedBy`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`SupplierID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `Email` (`Email`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `audittrail`
--
ALTER TABLE `audittrail`
  ADD CONSTRAINT `audittrail_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`),
  ADD CONSTRAINT `audittrail_ibfk_2` FOREIGN KEY (`ItemID`) REFERENCES `inventory` (`ItemID`);

--
-- Constraints for table `inventory`
--
ALTER TABLE `inventory`
  ADD CONSTRAINT `inventory_ibfk_1` FOREIGN KEY (`SupplierID`) REFERENCES `suppliers` (`SupplierID`);

--
-- Constraints for table `purchaseorders`
--
ALTER TABLE `purchaseorders`
  ADD CONSTRAINT `purchaseorders_ibfk_1` FOREIGN KEY (`SupplierID`) REFERENCES `suppliers` (`SupplierID`),
  ADD CONSTRAINT `purchaseorders_ibfk_2` FOREIGN KEY (`CreatedBy`) REFERENCES `users` (`UserID`);

--
-- Constraints for table `restockrequests`
--
ALTER TABLE `restockrequests`
  ADD CONSTRAINT `restockrequests_ibfk_1` FOREIGN KEY (`ItemID`) REFERENCES `inventory` (`ItemID`),
  ADD CONSTRAINT `restockrequests_ibfk_2` FOREIGN KEY (`RequestedBy`) REFERENCES `users` (`UserID`),
  ADD CONSTRAINT `restockrequests_ibfk_3` FOREIGN KEY (`ApprovedBy`) REFERENCES `users` (`UserID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
