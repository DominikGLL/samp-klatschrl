-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Erstellungszeit: 16. Okt 2016 um 11:47
-- Server-Version: 10.1.16-MariaDB
-- PHP-Version: 7.0.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `samp`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `accounts`
--

CREATE TABLE `accounts` (
  `ID` int(12) NOT NULL,
  `Name` varchar(25) NOT NULL,
  `Password` varchar(128) NOT NULL,
  `Admin` int(12) NOT NULL,
  `GangMember` int(12) NOT NULL,
  `GangRank` int(12) NOT NULL,
  `GangRequestLead` int(12) NOT NULL,
  `GangRequestMember` int(12) NOT NULL,
  `GangRequestMembers` int(12) NOT NULL,
  `Money` int(12) NOT NULL,
  `Level` int(12) NOT NULL,
  `Skin` int(12) NOT NULL,
  `AdminDuty` int(12) NOT NULL,
  `AdminDutyTime` int(12) NOT NULL,
  `Hunger` int(12) NOT NULL,
  `HungerCount` int(12) NOT NULL,
  `Thirst` int(12) NOT NULL,
  `ThirstCount` int(12) NOT NULL,
  `Faction` int(12) NOT NULL,
  `Rank` int(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
