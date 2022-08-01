CREATE DATABASE  IF NOT EXISTS `basket` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `basket`;
-- MySQL dump 10.13  Distrib 8.0.29, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: basket
-- ------------------------------------------------------
-- Server version	8.0.29

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cities`
--

DROP TABLE IF EXISTS `cities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cities` (
  `CityID` int NOT NULL,
  `City` text,
  `State` text,
  PRIMARY KEY (`CityID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `conferences`
--

DROP TABLE IF EXISTS `conferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `conferences` (
  `ConfAbbrev` varchar(10) NOT NULL,
  `Description` text,
  PRIMARY KEY (`ConfAbbrev`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mregularseasoncompactresults`
--

DROP TABLE IF EXISTS `mregularseasoncompactresults`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mregularseasoncompactresults` (
  `Season` int DEFAULT NULL,
  `DayNum` int DEFAULT NULL,
  `WTeamID` int DEFAULT NULL,
  `WScore` int DEFAULT NULL,
  `LTeamID` int DEFAULT NULL,
  `LScore` int DEFAULT NULL,
  `WLoc` text,
  `NumOT` int DEFAULT NULL,
  KEY `WTeamID` (`WTeamID`),
  KEY `LTeamID` (`LTeamID`),
  CONSTRAINT `mregularseasoncompactresults_ibfk_1` FOREIGN KEY (`WTeamID`) REFERENCES `mteams` (`TeamID`),
  CONSTRAINT `mregularseasoncompactresults_ibfk_2` FOREIGN KEY (`LTeamID`) REFERENCES `mteams` (`TeamID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mteamcoaches`
--

DROP TABLE IF EXISTS `mteamcoaches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mteamcoaches` (
  `Season` int DEFAULT NULL COMMENT 'the calendar year in which the final tournament occurs',
  `TeamID` int DEFAULT NULL COMMENT ' this is the TeamID of the team that was coached',
  `FirstDayNum` int DEFAULT NULL COMMENT 'this defines a continuous range of days within the season, during which the indicated coach was the head coach of the team',
  `LastDayNum` int DEFAULT NULL COMMENT 'this defines a continuous range of days within the season, during which the indicated coach was the head coach of the team',
  `CoachName` text COMMENT 'this is a text representation of the coach''s full name, in the format first_last, with underscores substituted in for spaces',
  KEY `TeamID` (`TeamID`),
  CONSTRAINT `mteamcoaches_ibfk_1` FOREIGN KEY (`TeamID`) REFERENCES `mteams` (`TeamID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mteams`
--

DROP TABLE IF EXISTS `mteams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mteams` (
  `TeamID` int NOT NULL COMMENT 'A 4 digit id number, from 1000-1999, uniquely identifying each NCAA® men''s team',
  `TeamName` text COMMENT 'a compact spelling of the team''s college name, 16 characters or fewer',
  `FirstD1Season` int DEFAULT NULL COMMENT 'the first season in our dataset that the school was a Division-I school',
  `LastD1Season` int DEFAULT NULL COMMENT 'the last season in our dataset that the school was a Division-I school',
  PRIMARY KEY (`TeamID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `wins_per_coach`
--

DROP TABLE IF EXISTS `wins_per_coach`;
/*!50001 DROP VIEW IF EXISTS `wins_per_coach`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `wins_per_coach` AS SELECT 
 1 AS `CoachName`,
 1 AS `TeamName`,
 1 AS `MostWin`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `wins_per_coach`
--

/*!50001 DROP VIEW IF EXISTS `wins_per_coach`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `wins_per_coach` AS select `c`.`CoachName` AS `CoachName`,`b`.`TeamName` AS `TeamName`,count(`a`.`WTeamID`) AS `MostWin` from (`mteamcoaches` `c` join (`mteams` `b` join `mregularseasoncompactresults` `a` on((`a`.`WTeamID` = `b`.`TeamID`))) on((`c`.`TeamID` = `b`.`TeamID`))) group by `c`.`CoachName`,`b`.`TeamName` order by `c`.`CoachName`,`MostWin` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-08-01 15:34:47
