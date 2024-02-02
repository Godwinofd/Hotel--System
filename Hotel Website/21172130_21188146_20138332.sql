-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 31, 2024 at 04:26 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.1.17

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `aaramhotel`
--

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `booking_id` varchar(10) NOT NULL,
  `user_id` varchar(10) DEFAULT NULL,
  `room_id` varchar(10) DEFAULT NULL,
  `check_in_date` date DEFAULT NULL,
  `check_out_date` date DEFAULT NULL,
  `num_guests` int(11) DEFAULT NULL,
  `booking_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hotels`
--

CREATE TABLE `hotels` (
  `hotel_id` varchar(10) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `address` varchar(255) NOT NULL,
  `city` varchar(100) NOT NULL,
  `country` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `hotels`
--

INSERT INTO `hotels` (`hotel_id`, `name`, `description`, `address`, `city`, `country`) VALUES
('HOT001', 'Grand Hotel', 'Luxurious accommodations', '123 Main Street', 'New York', 'USA'),
('HOT002', 'Beach Resort', 'Beautiful oceanfront views', '456 Beach Avenue', 'Miami', 'USA');

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `payment_id` varchar(10) NOT NULL,
  `booking_id` varchar(10) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `room_id` varchar(10) NOT NULL,
  `hotel_id` varchar(10) DEFAULT NULL,
  `room_type` varchar(50) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `capacity` int(11) NOT NULL,
  `available` tinyint(1) NOT NULL DEFAULT 1,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `rooms`
--

INSERT INTO `rooms` (`room_id`, `hotel_id`, `room_type`, `price`, `capacity`, `available`, `description`) VALUES
('RM001', 'HOT001', 'Standard', 100.00, 2, 1, 'Comfortable and cozy, the standard room offers essential amenities for a relaxing stay.'),
('RM002', 'HOT001', 'Suite', 200.00, 4, 1, 'Indulge in opulence and exclusivity in the suite room, where luxury meets refinement for an unforgettable stay.'),
('RM003', 'HOT002', 'Executive', 300.00, 2, 1, 'Modern comfort meets functionality in the executive room, perfect for discerning travelers seeking style and efficiency.'),
('RM004', 'HOT002', 'Deluxe', 250.00, 3, 1, 'Experience luxury and modern comfort in the deluxe room, ideal for both leisure and business travelers.');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` varchar(10) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `email`, `password_hash`, `first_name`, `last_name`) VALUES
('USR001', 'TRY', 'emeka.nweke@mail.bcu.ac.uk', '$2y$10$edrYvcEh6/DExzLAOjHCbuBfKFr9jupoNFweoEeaIRurJrB1fwwrW', 'EMEKA AKIM', 'NWEKE'),
('USR002', 'TRY', 'emeka.nweke@mail.bcu.ac.uk', '$2y$10$WHNE7.qzsw6dufuPaWYxqeXHYEYGAUFTec239tSK/Nq5okPIpS.9i', 'EMEKA AKIM', 'NWEKE'),
('USR003', 'niko', 'sales@nwkdigital.com', '$2y$10$ZpaPWHNuhn9YlH8sahjXJ.F2o8w/GyTfprUDfgMeymqLbD0P5pIN.', 'NWK', 'ENTERPRISES'),
('USR004', 'kkk', 'sales@nwkdigital.com', '$2y$10$zGCAafGbTaVmJXhq6Z2M5uRobFvS4LCKWAwAR1X2rBZiIrkAsEBb2', 'NWK', 'ENTERPRISES'),
('USR005', 'now', 'sales@nwkdigital.com', '$2y$10$PXGyQ6tMepG6kdwSQuiF7eWlw0GArjGAgag.Zd9eCTj8QiYw2q1HK', 'NWK', 'ENTERPRISES');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`booking_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `room_id` (`room_id`);

--
-- Indexes for table `hotels`
--
ALTER TABLE `hotels`
  ADD PRIMARY KEY (`hotel_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `booking_id` (`booking_id`);

--
-- Indexes for table `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`room_id`),
  ADD KEY `hotel_id` (`hotel_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`);

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`);

--
-- Constraints for table `rooms`
--
ALTER TABLE `rooms`
  ADD CONSTRAINT `rooms_ibfk_1` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`hotel_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
