-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 14, 2024 at 12:22 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hospital`
--

-- --------------------------------------------------------

--
-- Table structure for table `appointment`
--
-- Creation: Aug 13, 2024 at 09:15 PM
-- Last update: Aug 13, 2024 at 10:09 PM
--

DROP TABLE IF EXISTS `appointment`;
CREATE TABLE `appointment` (
  `id` int(10) NOT NULL,
  `Patient_id` int(10) NOT NULL,
  `Doctor_id` int(10) NOT NULL,
  `Reg_date` datetime NOT NULL DEFAULT current_timestamp(),
  `APP_date` date NOT NULL,
  `APP_time` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `appointment`:
--   `Patient_id`
--       `patient` -> `Patient_id`
--   `Doctor_id`
--       `doctor` -> `Doctor_id`
--

--
-- Dumping data for table `appointment`
--

INSERT INTO `appointment` (`id`, `Patient_id`, `Doctor_id`, `Reg_date`, `APP_date`, `APP_time`) VALUES
(1071, 101, 203, '2024-08-14 04:09:54', '2022-06-22', '08:00:00'),
(1072, 102, 204, '2024-08-14 04:09:54', '2022-06-20', '08:00:00'),
(1073, 103, 201, '2024-08-14 04:09:54', '2022-06-22', '10:00:00'),
(1074, 104, 206, '2024-08-14 04:09:54', '2022-06-22', '08:00:00'),
(1075, 105, 203, '2024-08-14 04:09:54', '2022-06-22', '09:00:00'),
(1076, 106, 205, '2024-08-14 04:09:54', '2022-06-24', '09:00:00'),
(1077, 107, 202, '2024-08-14 04:09:54', '2022-06-22', '08:00:00'),
(1078, 108, 201, '2024-08-14 04:09:54', '2022-06-22', '11:00:00'),
(1079, 109, 206, '2024-08-14 04:09:54', '2022-06-22', '10:00:00'),
(1080, 110, 203, '2024-08-14 04:09:54', '2022-06-23', '08:00:00');

--
-- Triggers `appointment`
--
DROP TRIGGER IF EXISTS `billing_and_update_charge`;
DELIMITER $$
CREATE TRIGGER `billing_and_update_charge` AFTER INSERT ON `appointment` FOR EACH ROW BEGIN
    -- Insert a new record into the Bill table and set Doctor_charge and Room_charge
    INSERT INTO Bill (Patient_id, Doctor_id, Doctor_charge, Room_charge)
    VALUES (
        NEW.Patient_id, 
        NEW.Doctor_id, 
        (SELECT Charge FROM Doctor WHERE Doctor_id = NEW.Doctor_id),
        (SELECT Charge FROM Room WHERE Patient_id = NEW.Patient_id)
    );

    -- Calculate and update the Total field in the Bill table
    UPDATE Bill
    SET Total = COALESCE(Doctor_charge, 0) + COALESCE(Service_charge, 0) + COALESCE(Room_charge, 0)
    WHERE Patient_id = NEW.Patient_id AND Doctor_id = NEW.Doctor_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `bill`
--
-- Creation: Aug 13, 2024 at 09:15 PM
-- Last update: Aug 13, 2024 at 10:09 PM
--

DROP TABLE IF EXISTS `bill`;
CREATE TABLE `bill` (
  `Bill_no` int(10) NOT NULL,
  `Patient_id` int(10) NOT NULL,
  `Doctor_id` int(10) NOT NULL,
  `Doctor_charge` decimal(7,2) DEFAULT NULL,
  `Service_charge` decimal(7,2) DEFAULT 600.00,
  `Room_charge` decimal(7,2) DEFAULT NULL,
  `Total` decimal(7,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `bill`:
--   `Patient_id`
--       `patient` -> `Patient_id`
--   `Doctor_id`
--       `doctor` -> `Doctor_id`
--

--
-- Dumping data for table `bill`
--

INSERT INTO `bill` (`Bill_no`, `Patient_id`, `Doctor_id`, `Doctor_charge`, `Service_charge`, `Room_charge`, `Total`) VALUES
(2021, 101, 203, 3000.00, 600.00, 200.00, 3800.00),
(2022, 102, 204, 2200.00, 600.00, 500.00, 3300.00),
(2023, 103, 201, 2500.00, 600.00, NULL, 3100.00),
(2024, 104, 206, 2500.00, 600.00, NULL, 3100.00),
(2025, 105, 203, 3000.00, 600.00, 200.00, 3800.00),
(2026, 106, 205, 2000.00, 600.00, NULL, 2600.00),
(2027, 107, 202, 2000.00, 600.00, NULL, 2600.00),
(2028, 108, 201, 2500.00, 600.00, NULL, 3100.00),
(2029, 109, 206, 2500.00, 600.00, NULL, 3100.00),
(2030, 110, 203, 3000.00, 600.00, NULL, 3600.00);

-- --------------------------------------------------------

--
-- Table structure for table `doctor`
--
-- Creation: Aug 13, 2024 at 09:15 PM
-- Last update: Aug 13, 2024 at 09:33 PM
--

DROP TABLE IF EXISTS `doctor`;
CREATE TABLE `doctor` (
  `Doctor_id` int(10) NOT NULL,
  `First_name` varchar(20) NOT NULL,
  `Last_name` varchar(20) NOT NULL,
  `Nationality` varchar(20) NOT NULL,
  `Specialist` varchar(20) NOT NULL,
  `Phone` int(15) NOT NULL,
  `Email` varchar(20) DEFAULT NULL,
  `Charge` decimal(7,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `doctor`:
--

--
-- Dumping data for table `doctor`
--

INSERT INTO `doctor` (`Doctor_id`, `First_name`, `Last_name`, `Nationality`, `Specialist`, `Phone`, `Email`, `Charge`) VALUES
(201, 'Tarek', 'hassan', 'BD', 'Nose', 553688, 'tarek@gmail.com', 2500.00),
(202, 'Akbar', 'Ali', 'BD', 'Diabetic', 53396397, 'akbar@gmail.com', 2000.00),
(203, 'Abdur', 'Rahim', 'USA', 'Bone', 7979676, 'abdur@gmail.com', 3000.00),
(204, 'Azizur', 'Rahman', 'BD', 'Psychiatry', 9771121, 'azizur@gmail.com', 2200.00),
(205, 'Shamsul', 'Haque', 'BD', 'Heart', 1363784178, 'shamsul@gmail.com', 2000.00),
(206, 'Rama', 'Dhar', 'IND', 'Neurological', 78912456, 'rama@gmail.com', 2500.00);

-- --------------------------------------------------------

--
-- Table structure for table `patient`
--
-- Creation: Aug 13, 2024 at 09:15 PM
-- Last update: Aug 13, 2024 at 09:33 PM
--

DROP TABLE IF EXISTS `patient`;
CREATE TABLE `patient` (
  `Patient_id` int(10) NOT NULL,
  `First_name` varchar(20) NOT NULL,
  `Last_name` varchar(20) NOT NULL,
  `Nationality` varchar(20) NOT NULL,
  `Gender` enum('Male','Female') DEFAULT NULL,
  `Address` varchar(40) NOT NULL,
  `DOB` date NOT NULL,
  `Phone` int(15) NOT NULL,
  `Email` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `patient`:
--

--
-- Dumping data for table `patient`
--

INSERT INTO `patient` (`Patient_id`, `First_name`, `Last_name`, `Nationality`, `Gender`, `Address`, `DOB`, `Phone`, `Email`) VALUES
(101, 'Akramul', 'Islam', 'BD', 'Male', 'Mirpur', '1999-02-25', 1812345678, 'akram@gmail.com'),
(102, 'Tahsin', 'Mahmud', 'BD', 'Male', 'Dhanmondi', '1997-04-13', 1715356489, 'tahsin@gmail.com'),
(103, 'Delowar', 'Hossain', 'Italy', 'Male', 'Rome', '1990-05-03', 2134679, 'delowar@gmail.com'),
(104, 'Sadia', 'Rahman', 'BD', 'Female', 'Shewrapara', '1998-09-18', 1736149782, 'sadia@gmail.com'),
(105, 'Tushar', 'Ahmed', 'BD', 'Male', 'Mirpur', '2000-01-20', 1912362145, 'tushar@gmail.com'),
(106, 'Kashfia', 'Islam', 'BD', 'Female', 'Jessore', '2003-02-15', 1423597888, 'kashfia@gmail.com'),
(107, 'Shawn', 'Michale', 'USA', 'Male', 'New York', '1988-06-22', 9134679, 'shawn@gmail.com'),
(108, 'Charlotte', 'Flair', 'USA', 'Female', 'San Fransico', '1993-02-28', 9361425, 'charlotte@gmail.com'),
(109, 'Chang', 'Lee', 'Japan', 'Male', 'Tokyo', '1990-08-26', 7132564, 'chang@gmail.com'),
(110, 'Fahad', 'Khan', 'Ind', 'Male', 'New Delhi', '2001-05-14', 1113467928, 'fahad@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `room`
--
-- Creation: Aug 13, 2024 at 09:15 PM
-- Last update: Aug 13, 2024 at 10:04 PM
--

DROP TABLE IF EXISTS `room`;
CREATE TABLE `room` (
  `Room_no` int(10) NOT NULL,
  `Patient_id` int(10) DEFAULT NULL,
  `Room_type` enum('Normal','Premium') DEFAULT NULL,
  `Statuss` enum('Full','Empty') DEFAULT NULL,
  `Charge` decimal(7,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `room`:
--   `Patient_id`
--       `patient` -> `Patient_id`
--

--
-- Dumping data for table `room`
--

INSERT INTO `room` (`Room_no`, `Patient_id`, `Room_type`, `Statuss`, `Charge`) VALUES
(501, 101, 'Normal', 'Full', 200.00),
(502, 102, 'Premium', 'Full', 500.00),
(503, NULL, 'Normal', 'Empty', 200.00),
(504, NULL, 'Premium', 'Empty', 500.00),
(505, 105, 'Normal', 'Full', 200.00),
(506, NULL, 'Premium', 'Empty', 500.00);

--
-- Triggers `room`
--
DROP TRIGGER IF EXISTS `upd_room`;
DELIMITER $$
CREATE TRIGGER `upd_room` BEFORE INSERT ON `room` FOR EACH ROW BEGIN
      IF (NEW.Patient_id IS NULL ) THEN
            SET NEW.Statuss = 'Empty';
      ELSE
           SET NEW.Statuss = 'Full';
      END IF;
    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--
-- Creation: Aug 13, 2024 at 09:15 PM
-- Last update: Aug 13, 2024 at 09:33 PM
--

DROP TABLE IF EXISTS `staff`;
CREATE TABLE `staff` (
  `Staff_id` int(10) NOT NULL,
  `Name` varchar(20) NOT NULL,
  `Salary` decimal(7,2) DEFAULT NULL,
  `Phone` int(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELATIONSHIPS FOR TABLE `staff`:
--

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`Staff_id`, `Name`, `Salary`, `Phone`) VALUES
(701, 'Rahim', 8000.00, 4854561),
(702, 'Masud', 10000.00, 63436693),
(703, 'Foysal', 5000.00, 365434),
(704, 'Shawana', 6000.00, 4638563),
(705, 'Toufiq', 9000.00, 634634),
(706, 'Samiha', 7500.00, 466346),
(707, 'Lita', 8000.00, 977635),
(708, 'Junaed', 9200.00, 4689634);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `appointment`
--
ALTER TABLE `appointment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Patient_id` (`Patient_id`),
  ADD KEY `Doctor_id` (`Doctor_id`);

--
-- Indexes for table `bill`
--
ALTER TABLE `bill`
  ADD PRIMARY KEY (`Bill_no`),
  ADD KEY `Patient_id` (`Patient_id`),
  ADD KEY `Doctor_id` (`Doctor_id`);

--
-- Indexes for table `doctor`
--
ALTER TABLE `doctor`
  ADD PRIMARY KEY (`Doctor_id`);

--
-- Indexes for table `patient`
--
ALTER TABLE `patient`
  ADD PRIMARY KEY (`Patient_id`);

--
-- Indexes for table `room`
--
ALTER TABLE `room`
  ADD PRIMARY KEY (`Room_no`),
  ADD KEY `Patient_id` (`Patient_id`);

--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`Staff_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `appointment`
--
ALTER TABLE `appointment`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1081;

--
-- AUTO_INCREMENT for table `bill`
--
ALTER TABLE `bill`
  MODIFY `Bill_no` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2031;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `appointment`
--
ALTER TABLE `appointment`
  ADD CONSTRAINT `appointment_ibfk_1` FOREIGN KEY (`Patient_id`) REFERENCES `patient` (`Patient_id`),
  ADD CONSTRAINT `appointment_ibfk_2` FOREIGN KEY (`Doctor_id`) REFERENCES `doctor` (`Doctor_id`);

--
-- Constraints for table `bill`
--
ALTER TABLE `bill`
  ADD CONSTRAINT `bill_ibfk_1` FOREIGN KEY (`Patient_id`) REFERENCES `patient` (`Patient_id`),
  ADD CONSTRAINT `bill_ibfk_2` FOREIGN KEY (`Doctor_id`) REFERENCES `doctor` (`Doctor_id`);

--
-- Constraints for table `room`
--
ALTER TABLE `room`
  ADD CONSTRAINT `room_ibfk_1` FOREIGN KEY (`Patient_id`) REFERENCES `patient` (`Patient_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
