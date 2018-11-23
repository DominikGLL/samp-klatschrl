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
-- Tabellenstruktur für Tabelle `gangs`
--

CREATE TABLE `gangs` (
  `ID` int(12) NOT NULL,
  `GangName` varchar(32) NOT NULL,
  `GangTag` varchar(4) NOT NULL,
  `GangType` int(12) NOT NULL,
  `GangLevel` int(12) NOT NULL,
  `GangExp` int(12) NOT NULL,
  `GangGruender` varchar(25) NOT NULL,
  `GangMember` int(12) NOT NULL,
  `GangMaxMember` int(12) NOT NULL,
  `GangMaxVeh` int(12) NOT NULL,
  `GangColor` int(12) NOT NULL,
  `GangVehColor1` int(12) NOT NULL,
  `GangVehColor2` int(12) NOT NULL,
  `GangRang0` varchar(32) NOT NULL,
  `GangRang1` varchar(32) NOT NULL,
  `GangRang2` varchar(32) NOT NULL,
  `GangRang3` varchar(32) NOT NULL,
  `GangRang4` varchar(32) NOT NULL,
  `GangRang5` varchar(32) NOT NULL,
  `GangRang6` varchar(32) NOT NULL,
  `GangRang7` varchar(32) NOT NULL,
  `GangRang8` varchar(32) NOT NULL,
  `GangRang9` varchar(32) NOT NULL,
  `GangRang10` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `gangs`
--
ALTER TABLE `gangs`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `gangs`
--
ALTER TABLE `gangs`
  MODIFY `ID` int(12) NOT NULL AUTO_INCREMENT;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
