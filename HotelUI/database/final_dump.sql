-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: airbnb_clone
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `amenities`
--

DROP TABLE IF EXISTS `amenities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `amenities` (
  `amenity_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `icon` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`amenity_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amenities`
--

LOCK TABLES `amenities` WRITE;
/*!40000 ALTER TABLE `amenities` DISABLE KEYS */;
INSERT INTO `amenities` VALUES (1,'WiFi','fa-wifi'),(2,'Pool','fa-swimming-pool'),(3,'Air Conditioning','fa-snowflake'),(4,'Kitchen','fa-utensils'),(5,'Parking','fa-car'),(6,'TV','fa-tv');
/*!40000 ALTER TABLE `amenities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookingguests`
--

DROP TABLE IF EXISTS `bookingguests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookingguests` (
  `guest_info_id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `full_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `relationship` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `age` int DEFAULT NULL,
  PRIMARY KEY (`guest_info_id`),
  KEY `booking_id` (`booking_id`),
  CONSTRAINT `bookingguests_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookingguests`
--

LOCK TABLES `bookingguests` WRITE;
/*!40000 ALTER TABLE `bookingguests` DISABLE KEYS */;
INSERT INTO `bookingguests` VALUES (1,2,'Deneme','Diğer',15);
/*!40000 ALTER TABLE `bookingguests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookings` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `property_id` int NOT NULL,
  `guest_id` int NOT NULL,
  `check_in` date NOT NULL,
  `check_out` date NOT NULL,
  `guest_count` int DEFAULT '1',
  `total_price` decimal(10,2) NOT NULL,
  `status` enum('pending','confirmed','cancelled','completed') COLLATE utf8mb4_general_ci DEFAULT 'pending',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`booking_id`),
  KEY `property_id` (`property_id`),
  KEY `guest_id` (`guest_id`),
  CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`) ON DELETE CASCADE,
  CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`guest_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
INSERT INTO `bookings` VALUES (1,1,3,'2026-04-01','2026-04-05',1,4800.00,'completed','2026-04-17 00:39:45'),(2,2,3,'2026-04-19','2026-04-22',1,3600.00,'confirmed','2026-04-17 00:45:55'),(3,3,3,'2026-04-17','2026-04-18',1,800.00,'confirmed','2026-04-17 10:45:30'),(4,2,3,'2026-04-26','2026-04-29',1,1350.00,'confirmed','2026-04-17 10:59:49'),(5,4,3,'2026-03-10','2026-03-13',2,2850.00,'completed','2026-04-17 12:07:11'),(6,4,8,'2026-05-20','2026-05-23',2,2850.00,'confirmed','2026-04-17 12:07:11'),(7,5,9,'2026-05-01','2026-05-05',3,4400.00,'confirmed','2026-04-17 12:07:11'),(8,5,10,'2026-03-15','2026-03-18',4,3300.00,'completed','2026-04-17 12:07:11'),(9,6,3,'2026-07-01','2026-07-07',5,13200.00,'confirmed','2026-04-17 12:07:11'),(10,6,8,'2026-08-10','2026-08-14',2,8800.00,'pending','2026-04-17 12:07:11'),(11,7,18,'2026-07-15','2026-07-19',1,5800.00,'pending','2026-04-17 12:10:21'),(12,7,21,'2026-05-10','2026-05-13',2,4350.00,'confirmed','2026-04-17 12:10:21'),(13,7,17,'2026-06-05','2026-06-09',3,5800.00,'confirmed','2026-04-17 12:10:21'),(14,8,16,'2026-05-10','2026-05-13',3,1860.00,'confirmed','2026-04-17 12:10:21'),(15,8,17,'2026-05-20','2026-05-24',3,2480.00,'confirmed','2026-04-17 12:10:21'),(16,9,18,'2026-02-10','2026-02-13',2,2640.00,'completed','2026-04-17 12:10:21'),(17,9,20,'2026-07-15','2026-07-19',1,3520.00,'pending','2026-04-17 12:10:21'),(18,10,19,'2026-02-10','2026-02-13',1,1650.00,'completed','2026-04-17 12:10:21'),(19,10,20,'2026-02-20','2026-02-23',1,1650.00,'completed','2026-04-17 12:10:21'),(20,10,17,'2026-04-01','2026-04-04',1,1650.00,'completed','2026-04-17 12:10:21'),(21,11,16,'2026-03-05','2026-03-08',1,5700.00,'completed','2026-04-17 12:10:21'),(22,11,20,'2026-05-20','2026-05-24',1,7600.00,'confirmed','2026-04-17 12:10:21'),(23,12,17,'2026-07-15','2026-07-19',1,3000.00,'pending','2026-04-17 12:10:21'),(24,12,16,'2026-06-05','2026-06-09',3,3000.00,'confirmed','2026-04-17 12:10:21'),(25,13,19,'2026-08-01','2026-08-05',2,1920.00,'pending','2026-04-17 12:10:21'),(26,13,17,'2026-02-20','2026-02-23',1,1440.00,'completed','2026-04-17 12:10:21'),(27,13,17,'2026-06-05','2026-06-09',1,1920.00,'confirmed','2026-04-17 12:10:21'),(28,14,20,'2026-03-18','2026-03-21',1,1260.00,'completed','2026-04-17 12:10:21'),(29,14,18,'2026-02-20','2026-02-23',3,1260.00,'completed','2026-04-17 12:10:21'),(30,15,18,'2026-05-20','2026-05-24',2,3920.00,'confirmed','2026-04-17 12:10:21'),(31,15,21,'2026-08-01','2026-08-05',1,3920.00,'pending','2026-04-17 12:10:21'),(32,16,17,'2026-04-01','2026-04-04',3,3750.00,'completed','2026-04-17 12:10:21'),(33,16,20,'2026-06-05','2026-06-09',3,5000.00,'confirmed','2026-04-17 12:10:21'),(34,16,20,'2026-02-20','2026-02-23',1,3750.00,'completed','2026-04-17 12:10:21'),(35,17,16,'2026-03-05','2026-03-08',3,1680.00,'completed','2026-04-17 12:10:21'),(36,17,20,'2026-05-20','2026-05-24',3,2240.00,'confirmed','2026-04-17 12:10:21'),(37,18,21,'2026-02-10','2026-02-13',3,5040.00,'completed','2026-04-17 12:10:21'),(38,18,17,'2026-07-15','2026-07-19',1,6720.00,'pending','2026-04-17 12:10:21'),(39,19,18,'2026-07-15','2026-07-19',2,3680.00,'pending','2026-04-17 12:10:21'),(40,19,18,'2026-03-05','2026-03-08',2,2760.00,'completed','2026-04-17 12:10:21'),(41,19,17,'2026-02-20','2026-02-23',2,2760.00,'completed','2026-04-17 12:10:21'),(42,20,16,'2026-05-10','2026-05-13',1,2430.00,'confirmed','2026-04-17 12:10:21'),(43,20,19,'2026-07-15','2026-07-19',1,3240.00,'pending','2026-04-17 12:10:21'),(44,21,17,'2026-05-10','2026-05-13',1,2550.00,'confirmed','2026-04-17 12:10:21'),(45,21,20,'2026-07-15','2026-07-19',1,3400.00,'pending','2026-04-17 12:10:21'),(46,22,21,'2026-03-05','2026-03-08',2,2310.00,'completed','2026-04-17 12:10:21'),(47,22,18,'2026-05-10','2026-05-13',2,2310.00,'confirmed','2026-04-17 12:10:21'),(48,22,16,'2026-08-01','2026-08-05',3,3080.00,'pending','2026-04-17 12:10:21'),(49,23,18,'2026-04-01','2026-04-04',1,1950.00,'completed','2026-04-17 12:10:21'),(50,23,17,'2026-03-18','2026-03-21',3,1950.00,'completed','2026-04-17 12:10:21'),(51,24,21,'2026-02-10','2026-02-13',2,1440.00,'completed','2026-04-17 12:10:21'),(52,24,19,'2026-04-01','2026-04-04',3,1440.00,'completed','2026-04-17 12:10:21'),(53,25,21,'2026-05-10','2026-05-13',2,3300.00,'confirmed','2026-04-17 12:10:21'),(54,25,17,'2026-06-05','2026-06-09',1,4400.00,'confirmed','2026-04-17 12:10:21'),(55,25,19,'2026-08-01','2026-08-05',3,4400.00,'pending','2026-04-17 12:10:21'),(56,26,18,'2026-02-20','2026-02-23',3,1560.00,'completed','2026-04-17 12:10:21'),(57,26,21,'2026-04-01','2026-04-04',3,1560.00,'completed','2026-04-17 12:10:21'),(58,1,8,'2026-03-28','2026-04-02',1,500.00,'completed','2026-04-17 22:38:44'),(59,2,9,'2026-03-27','2026-04-01',1,500.00,'completed','2026-04-17 22:38:44'),(60,3,10,'2026-03-26','2026-03-31',1,500.00,'completed','2026-04-17 22:38:44'),(61,4,16,'2026-03-25','2026-03-30',1,500.00,'completed','2026-04-17 22:38:44'),(62,5,17,'2026-03-24','2026-03-29',1,500.00,'completed','2026-04-17 22:38:45'),(63,6,8,'2026-03-23','2026-03-28',1,500.00,'completed','2026-04-17 22:38:45'),(64,7,9,'2026-03-22','2026-03-27',1,500.00,'completed','2026-04-17 22:38:45'),(65,8,10,'2026-03-21','2026-03-26',1,500.00,'completed','2026-04-17 22:38:45'),(66,9,16,'2026-03-20','2026-03-25',1,500.00,'completed','2026-04-17 22:38:45'),(67,10,17,'2026-03-19','2026-03-24',1,500.00,'completed','2026-04-17 22:38:45'),(68,6,8,'2024-03-01','2024-03-05',1,400.00,'completed','2026-04-17 22:41:33'),(69,7,9,'2024-03-01','2024-03-05',1,400.00,'completed','2026-04-17 22:41:33'),(70,8,10,'2024-03-01','2024-03-05',1,400.00,'completed','2026-04-17 22:41:33');
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `hms_citystatistics`
--

DROP TABLE IF EXISTS `hms_citystatistics`;
/*!50001 DROP VIEW IF EXISTS `hms_citystatistics`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `hms_citystatistics` AS SELECT 
 1 AS `city`,
 1 AS `total_properties`,
 1 AS `min_price`,
 1 AS `max_price`,
 1 AS `avg_price`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `hms_detailedreservations`
--

DROP TABLE IF EXISTS `hms_detailedreservations`;
/*!50001 DROP VIEW IF EXISTS `hms_detailedreservations`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `hms_detailedreservations` AS SELECT 
 1 AS `booking_id`,
 1 AS `guest_name`,
 1 AS `property_title`,
 1 AS `city`,
 1 AS `check_in`,
 1 AS `check_out`,
 1 AS `total_price`,
 1 AS `booking_status`,
 1 AS `payment_status`,
 1 AS `paid_amount`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `hms_monthlyguesttracker`
--

DROP TABLE IF EXISTS `hms_monthlyguesttracker`;
/*!50001 DROP VIEW IF EXISTS `hms_monthlyguesttracker`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `hms_monthlyguesttracker` AS SELECT 
 1 AS `property_id`,
 1 AS `property_title`,
 1 AS `primary_guest_name`,
 1 AS `additional_guest_name`,
 1 AS `relationship`,
 1 AS `check_in`,
 1 AS `stay_month`,
 1 AS `stay_year`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `hms_propertyanalytics`
--

DROP TABLE IF EXISTS `hms_propertyanalytics`;
/*!50001 DROP VIEW IF EXISTS `hms_propertyanalytics`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `hms_propertyanalytics` AS SELECT 
 1 AS `property_id`,
 1 AS `title`,
 1 AS `city`,
 1 AS `review_count`,
 1 AS `average_rating`,
 1 AS `total_stays`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `hms_propertybookingsummary`
--

DROP TABLE IF EXISTS `hms_propertybookingsummary`;
/*!50001 DROP VIEW IF EXISTS `hms_propertybookingsummary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `hms_propertybookingsummary` AS SELECT 
 1 AS `property_id`,
 1 AS `property_title`,
 1 AS `host_name`,
 1 AS `total_bookings`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `hms_successfulhosts`
--

DROP TABLE IF EXISTS `hms_successfulhosts`;
/*!50001 DROP VIEW IF EXISTS `hms_successfulhosts`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `hms_successfulhosts` AS SELECT 
 1 AS `full_name`,
 1 AS `email`,
 1 AS `listing_count`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `installments`
--

DROP TABLE IF EXISTS `installments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `installments` (
  `installment_id` int NOT NULL AUTO_INCREMENT,
  `payment_id` int NOT NULL,
  `installment_number` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `due_date` date NOT NULL,
  `status` enum('pending','paid','overdue') COLLATE utf8mb4_general_ci DEFAULT 'pending',
  PRIMARY KEY (`installment_id`),
  KEY `payment_id` (`payment_id`),
  CONSTRAINT `installments_ibfk_1` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`payment_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `installments`
--

LOCK TABLES `installments` WRITE;
/*!40000 ALTER TABLE `installments` DISABLE KEYS */;
/*!40000 ALTER TABLE `installments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_method` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `payment_status` enum('pending','completed','refunded','failed') COLLATE utf8mb4_general_ci DEFAULT 'pending',
  `transaction_ref` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `payment_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`),
  UNIQUE KEY `booking_id` (`booking_id`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (1,1,4800.00,'Credit Card','completed',NULL,'2026-04-17 00:39:45'),(2,2,3600.00,'Credit Card','completed','TRANS-2','2026-04-17 11:01:01'),(3,4,1350.00,'Credit Card','completed','TRANS-4','2026-04-17 11:42:06'),(4,5,2850.00,'Credit Card','completed',NULL,'2026-04-17 12:07:11'),(5,7,4400.00,'Credit Card','completed',NULL,'2026-04-17 12:07:11'),(6,8,3300.00,'Bank Transfer','completed',NULL,'2026-04-17 12:07:11'),(7,9,13200.00,'Credit Card','completed',NULL,'2026-04-17 12:07:11'),(8,12,4350.00,'Credit Card','pending',NULL,'2026-04-17 12:10:21'),(9,13,5800.00,'Credit Card','pending',NULL,'2026-04-17 12:10:21'),(10,14,1860.00,'Credit Card','pending',NULL,'2026-04-17 12:10:21'),(11,15,2480.00,'Credit Card','pending',NULL,'2026-04-17 12:10:21'),(12,16,2640.00,'Credit Card','completed',NULL,'2026-04-17 12:10:21'),(13,18,1650.00,'Credit Card','completed',NULL,'2026-04-17 12:10:21'),(14,19,1650.00,'Credit Card','completed',NULL,'2026-04-17 12:10:21'),(15,20,1650.00,'Credit Card','completed',NULL,'2026-04-17 12:10:21'),(16,21,5700.00,'Credit Card','completed',NULL,'2026-04-17 12:10:21'),(17,22,7600.00,'Credit Card','pending',NULL,'2026-04-17 12:10:21'),(18,24,3000.00,'Credit Card','pending',NULL,'2026-04-17 12:10:21'),(19,26,1440.00,'Credit Card','completed',NULL,'2026-04-17 12:10:21'),(20,27,1920.00,'Credit Card','pending',NULL,'2026-04-17 12:10:21'),(21,28,1260.00,'Credit Card','completed',NULL,'2026-04-17 12:10:21'),(22,29,1260.00,'Credit Card','completed',NULL,'2026-04-17 12:10:21'),(23,30,3920.00,'Credit Card','pending',NULL,'2026-04-17 12:10:21'),(24,32,3750.00,'Credit Card','completed',NULL,'2026-04-17 12:10:21'),(25,33,5000.00,'Credit Card','pending',NULL,'2026-04-17 12:10:21'),(26,34,3750.00,'Credit Card','completed',NULL,'2026-04-17 12:10:21'),(27,35,1680.00,'Credit Card','completed',NULL,'2026-04-17 12:10:21'),(28,36,2240.00,'Credit Card','pending',NULL,'2026-04-17 12:10:21'),(29,37,5040.00,'Credit Card','completed',NULL,'2026-04-17 12:10:21'),(30,40,2760.00,'Credit Card','completed',NULL,'2026-04-17 12:10:21'),(31,41,2760.00,'Credit Card','completed',NULL,'2026-04-17 12:10:21'),(32,42,2430.00,'Credit Card','pending',NULL,'2026-04-17 12:10:21'),(33,44,2550.00,'Credit Card','pending',NULL,'2026-04-17 12:10:21'),(34,46,2310.00,'Credit Card','completed',NULL,'2026-04-17 12:10:21'),(35,47,2310.00,'Credit Card','pending',NULL,'2026-04-17 12:10:21'),(36,49,1950.00,'Credit Card','completed',NULL,'2026-04-17 12:10:21'),(37,50,1950.00,'Credit Card','completed',NULL,'2026-04-17 12:10:21'),(38,51,1440.00,'Credit Card','completed',NULL,'2026-04-17 12:10:21'),(39,52,1440.00,'Credit Card','completed',NULL,'2026-04-17 12:10:21'),(40,53,3300.00,'Credit Card','pending',NULL,'2026-04-17 12:10:21'),(41,54,4400.00,'Credit Card','pending',NULL,'2026-04-17 12:10:21'),(42,56,1560.00,'Credit Card','completed',NULL,'2026-04-17 12:10:21'),(43,57,1560.00,'Credit Card','completed',NULL,'2026-04-17 12:10:21'),(44,58,500.00,'credit_card','completed','TRANS-EXTRA-58','2026-04-17 22:38:44'),(45,59,500.00,'credit_card','completed','TRANS-EXTRA-59','2026-04-17 22:38:44'),(46,60,500.00,'credit_card','completed','TRANS-EXTRA-60','2026-04-17 22:38:44'),(47,61,500.00,'credit_card','completed','TRANS-EXTRA-61','2026-04-17 22:38:44'),(48,62,500.00,'credit_card','completed','TRANS-EXTRA-62','2026-04-17 22:38:45'),(49,63,500.00,'credit_card','completed','TRANS-EXTRA-63','2026-04-17 22:38:45'),(50,64,500.00,'credit_card','completed','TRANS-EXTRA-64','2026-04-17 22:38:45'),(51,65,500.00,'credit_card','completed','TRANS-EXTRA-65','2026-04-17 22:38:45'),(52,66,500.00,'credit_card','completed','TRANS-EXTRA-66','2026-04-17 22:38:45'),(53,67,500.00,'credit_card','completed','TRANS-EXTRA-67','2026-04-17 22:38:45');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `properties`
--

DROP TABLE IF EXISTS `properties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `properties` (
  `property_id` int NOT NULL AUTO_INCREMENT,
  `host_id` int NOT NULL,
  `title` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `property_type` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `room_type` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `city` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `district` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `address_line` text COLLATE utf8mb4_general_ci,
  `base_price` decimal(10,2) NOT NULL,
  `cleaning_fee` decimal(10,2) DEFAULT '0.00',
  `max_guests` int DEFAULT '1',
  `bedroom_count` int DEFAULT '1',
  `bathroom_count` int DEFAULT '1',
  `status` enum('active','inactive','maintenance') COLLATE utf8mb4_general_ci DEFAULT 'active',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`property_id`),
  KEY `host_id` (`host_id`),
  CONSTRAINT `properties_ibfk_1` FOREIGN KEY (`host_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `properties`
--

LOCK TABLES `properties` WRITE;
/*!40000 ALTER TABLE `properties` DISABLE KEYS */;
INSERT INTO `properties` VALUES (1,2,'Luxury Villa with Bosphorus View','Enjoy a wonderful stay at Luxury Villa with Bosphorus View. This property offers great amenities and a perfect location.','Villa','Entire place','Istanbul','Beşiktaş',NULL,1200.00,0.00,6,1,1,'active','2026-04-17 00:39:45'),(2,2,'Charming Studio on Alanya Coast','Enjoy a wonderful stay at Charming Studio on Alanya Coast. This property offers great amenities and a perfect location.','Apartment','Entire place','Antalya','Alanya',NULL,450.00,0.00,2,1,1,'active','2026-04-17 00:39:45'),(3,2,'Modern Loft in Kadikoy Center','Enjoy a wonderful stay at Modern Loft in Kadikoy Center. This property offers great amenities and a perfect location.','Apartment','Entire place','Istanbul','Kadıköy',NULL,800.00,0.00,4,1,1,'active','2026-04-17 00:39:45'),(4,4,'Cappadocia Cave House','Enjoy a wonderful stay at Cappadocia Cave House. This property offers great amenities and a perfect location.','Villa','Entire place','Nevsehir','Urgup',NULL,950.00,0.00,4,1,1,'active','2026-04-17 12:07:11'),(5,7,'Alacati Stone Boutique','Enjoy a wonderful stay at Alacati Stone Boutique. This property offers great amenities and a perfect location.','House','Entire place','Izmir','Alacati',NULL,1100.00,0.00,6,1,1,'active','2026-04-17 12:07:11'),(6,7,'Bodrum Infinity Villa','Enjoy a wonderful stay at Bodrum Infinity Villa. This property offers great amenities and a perfect location.','Villa','Entire place','Mugla','Bodrum',NULL,2200.00,0.00,8,1,1,'active','2026-04-17 12:07:11'),(7,11,'Sariyer Bosphorus Mansion','Enjoy a wonderful stay at Sariyer Bosphorus Mansion. This property offers great amenities and a perfect location.','Villa','Entire place','Istanbul','Sariyer',NULL,1450.00,0.00,8,1,1,'active','2026-04-17 12:10:21'),(8,12,'Uskudar Cozy Apart','Enjoy a wonderful stay at Uskudar Cozy Apart. This property offers great amenities and a perfect location.','Apartment','Entire place','Istanbul','Uskudar',NULL,620.00,0.00,3,1,1,'active','2026-04-17 12:10:21'),(9,13,'Moda Chic Loft','Enjoy a wonderful stay at Moda Chic Loft. This property offers great amenities and a perfect location.','Apartment','Entire place','Istanbul','Kadikoy',NULL,880.00,0.00,4,1,1,'active','2026-04-17 12:10:21'),(10,14,'Cihangir Art House','Enjoy a wonderful stay at Cihangir Art House. This property offers great amenities and a perfect location.','House','Private room','Istanbul','Cihangir',NULL,550.00,0.00,2,1,1,'active','2026-04-17 12:10:21'),(11,15,'Bebek Waterfront Residence','Enjoy a wonderful stay at Bebek Waterfront Residence. This property offers great amenities and a perfect location.','Apartment','Entire place','Istanbul','Bebek',NULL,1900.00,0.00,5,1,1,'active','2026-04-17 12:10:21'),(12,11,'Kas Mediterranean Mansion','Enjoy a wonderful stay at Kas Mediterranean Mansion. This property offers great amenities and a perfect location.','House','Entire place','Antalya','Kas',NULL,750.00,0.00,4,1,1,'active','2026-04-17 12:10:21'),(13,12,'Side Antique Suit','Enjoy a wonderful stay at Side Antique Suit. This property offers great amenities and a perfect location.','Apartment','Private room','Antalya','Side',NULL,480.00,0.00,2,1,1,'active','2026-04-17 12:10:21'),(14,13,'Olympos Bungalow','Enjoy a wonderful stay at Olympos Bungalow. This property offers great amenities and a perfect location.','House','Entire place','Antalya','Olympos',NULL,420.00,0.00,3,1,1,'active','2026-04-17 12:10:21'),(15,14,'Cesme Wind House','Enjoy a wonderful stay at Cesme Wind House. This property offers great amenities and a perfect location.','House','Entire place','Izmir','Cesme',NULL,980.00,0.00,6,1,1,'active','2026-04-17 12:10:21'),(16,15,'Urla Olive Garden Villa','Enjoy a wonderful stay at Urla Olive Garden Villa. This property offers great amenities and a perfect location.','Villa','Entire place','Izmir','Urla',NULL,1250.00,0.00,7,1,1,'active','2026-04-17 12:10:21'),(17,11,'Karsiyaka Seaside Apart','Enjoy a wonderful stay at Karsiyaka Seaside Apart. This property offers great amenities and a perfect location.','Apartment','Entire place','Izmir','Karsiyaka',NULL,560.00,0.00,3,1,1,'active','2026-04-17 12:10:21'),(18,12,'Bitez Garden Villa','Enjoy a wonderful stay at Bitez Garden Villa. This property offers great amenities and a perfect location.','Villa','Entire place','Mugla','Bitez',NULL,1680.00,0.00,6,1,1,'active','2026-04-17 12:10:21'),(19,13,'Gokova Village House','Enjoy a wonderful stay at Gokova Village House. This property offers great amenities and a perfect location.','House','Entire place','Mugla','Gokova',NULL,920.00,0.00,5,1,1,'active','2026-04-17 12:10:21'),(20,14,'Datca Stone House','Enjoy a wonderful stay at Datca Stone House. This property offers great amenities and a perfect location.','House','Entire place','Mugla','Datca',NULL,810.00,0.00,4,1,1,'active','2026-04-17 12:10:21'),(21,15,'Goreme Balloon Suite','Enjoy a wonderful stay at Goreme Balloon Suite. This property offers great amenities and a perfect location.','Villa','Entire place','Nevsehir','Goreme',NULL,850.00,0.00,2,1,1,'active','2026-04-17 12:10:21'),(22,11,'Uchisar Castle Apart','Enjoy a wonderful stay at Uchisar Castle Apart. This property offers great amenities and a perfect location.','Apartment','Entire place','Nevsehir','Uchisar',NULL,770.00,0.00,3,1,1,'active','2026-04-17 12:10:21'),(23,12,'Uzungol Mountain House','Enjoy a wonderful stay at Uzungol Mountain House. This property offers great amenities and a perfect location.','House','Entire place','Trabzon','Uzungol',NULL,650.00,0.00,6,1,1,'active','2026-04-17 12:10:21'),(24,13,'Rize Tea Garden Village House','Enjoy a wonderful stay at Rize Tea Garden Village House. This property offers great amenities and a perfect location.','House','Entire place','Rize','Guneysu',NULL,480.00,0.00,4,1,1,'active','2026-04-17 12:10:21'),(25,14,'Bursa Uludag Ski House','Enjoy a wonderful stay at Bursa Uludag Ski House. This property offers great amenities and a perfect location.','House','Entire place','Bursa','Uludag',NULL,1100.00,0.00,8,1,1,'active','2026-04-17 12:10:21'),(26,15,'Eskisehir Porsuk Loft','Enjoy a wonderful stay at Eskisehir Porsuk Loft. This property offers great amenities and a perfect location.','Apartment','Entire place','Eskisehir','Odunpazari',NULL,520.00,0.00,3,1,1,'active','2026-04-17 12:10:21');
/*!40000 ALTER TABLE `properties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `propertyamenities`
--

DROP TABLE IF EXISTS `propertyamenities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `propertyamenities` (
  `property_id` int NOT NULL,
  `amenity_id` int NOT NULL,
  PRIMARY KEY (`property_id`,`amenity_id`),
  KEY `amenity_id` (`amenity_id`),
  CONSTRAINT `propertyamenities_ibfk_1` FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`) ON DELETE CASCADE,
  CONSTRAINT `propertyamenities_ibfk_2` FOREIGN KEY (`amenity_id`) REFERENCES `amenities` (`amenity_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `propertyamenities`
--

LOCK TABLES `propertyamenities` WRITE;
/*!40000 ALTER TABLE `propertyamenities` DISABLE KEYS */;
INSERT INTO `propertyamenities` VALUES (1,1),(2,1),(3,1),(4,1),(5,1),(6,1),(7,1),(8,1),(9,1),(10,1),(11,1),(12,1),(13,1),(14,1),(15,1),(16,1),(17,1),(18,1),(19,1),(20,1),(21,1),(22,1),(23,1),(24,1),(25,1),(26,1),(1,2),(6,2),(7,2),(11,2),(16,2),(18,2),(25,2),(1,3),(4,3),(5,3),(6,3),(7,3),(8,3),(11,3),(12,3),(13,3),(14,3),(15,3),(16,3),(17,3),(18,3),(19,3),(20,3),(21,3),(22,3),(24,3),(25,3),(3,4),(5,4),(9,4),(10,4),(12,4),(15,4),(20,4),(23,4),(26,4),(1,5),(6,5),(7,5),(11,5),(16,5),(18,5),(25,5),(4,6),(9,6),(10,6),(14,6),(19,6),(21,6),(22,6),(23,6),(24,6),(26,6);
/*!40000 ALTER TABLE `propertyamenities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `propertyphotos`
--

DROP TABLE IF EXISTS `propertyphotos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `propertyphotos` (
  `photo_id` int NOT NULL AUTO_INCREMENT,
  `property_id` int NOT NULL,
  `image_url` text COLLATE utf8mb4_general_ci NOT NULL,
  `is_primary` tinyint(1) DEFAULT '0',
  `sort_order` int DEFAULT '0',
  PRIMARY KEY (`photo_id`),
  KEY `property_id` (`property_id`),
  CONSTRAINT `propertyphotos_ibfk_1` FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `propertyphotos`
--

LOCK TABLES `propertyphotos` WRITE;
/*!40000 ALTER TABLE `propertyphotos` DISABLE KEYS */;
INSERT INTO `propertyphotos` VALUES (1,1,'luxurious_villa_istanbul.png',1,0),(2,1,'villa_int_1.png',0,1),(3,1,'villa_int_2.png',0,2),(4,2,'cozy_studio_beach.png',1,0),(5,2,'studio_int_1.png',0,1),(6,2,'studio_int_2.png',0,2),(7,3,'loft_ext.png',1,0),(8,3,'loft_int_1.png',0,1),(9,3,'loft_int_2.png',0,2),(10,4,'kapadokya_ext.png',1,0),(11,4,'kapadokya_int_1.png',0,1),(12,4,'kapadokya_int_2.png',0,2),(13,5,'alacati_ext.png',1,0),(14,5,'alacati_int_1.png',0,1),(15,5,'alacati_int_2.png',0,2),(16,6,'bodrum_ext.png',1,0),(17,6,'bodrum_int_1.png',0,1),(18,6,'bodrum_int_2.png',0,2),(19,7,'luxurious_villa_istanbul.png',1,0),(20,7,'villa_int_1.png',0,1),(21,7,'villa_int_2.png',0,2),(22,8,'cozy_studio_beach.png',1,0),(23,8,'studio_int_1.png',0,1),(24,8,'studio_int_2.png',0,2),(25,9,'loft_ext.png',1,0),(26,9,'loft_int_1.png',0,1),(27,9,'loft_int_2.png',0,2),(28,10,'loft_ext.png',1,0),(29,10,'loft_int_1.png',0,1),(30,10,'loft_int_2.png',0,2),(31,11,'luxurious_villa_istanbul.png',1,0),(32,11,'villa_int_1.png',0,1),(33,11,'villa_int_2.png',0,2),(34,12,'alacati_ext.png',1,0),(35,12,'alacati_int_1.png',0,1),(36,12,'alacati_int_2.png',0,2),(37,13,'cozy_studio_beach.png',1,0),(38,13,'studio_int_1.png',0,1),(39,13,'studio_int_2.png',0,2),(40,14,'kapadokya_ext.png',1,0),(41,14,'kapadokya_int_1.png',0,1),(42,14,'kapadokya_int_2.png',0,2),(43,15,'alacati_ext.png',1,0),(44,15,'alacati_int_1.png',0,1),(45,15,'alacati_int_2.png',0,2),(46,16,'luxurious_villa_istanbul.png',1,0),(47,16,'villa_int_1.png',0,1),(48,16,'villa_int_2.png',0,2),(49,17,'cozy_studio_beach.png',1,0),(50,17,'studio_int_1.png',0,1),(51,17,'studio_int_2.png',0,2),(52,18,'bodrum_ext.png',1,0),(53,18,'bodrum_int_1.png',0,1),(54,18,'bodrum_int_2.png',0,2),(55,19,'kapadokya_ext.png',1,0),(56,19,'kapadokya_int_1.png',0,1),(57,19,'kapadokya_int_2.png',0,2),(58,20,'alacati_ext.png',1,0),(59,20,'alacati_int_1.png',0,1),(60,20,'alacati_int_2.png',0,2),(61,21,'kapadokya_ext.png',1,0),(62,21,'kapadokya_int_1.png',0,1),(63,21,'kapadokya_int_2.png',0,2),(64,22,'kapadokya_ext.png',1,0),(65,22,'kapadokya_int_1.png',0,1),(66,22,'kapadokya_int_2.png',0,2),(67,23,'loft_ext.png',1,0),(68,23,'loft_int_1.png',0,1),(69,23,'loft_int_2.png',0,2),(70,24,'kapadokya_ext.png',1,0),(71,24,'kapadokya_int_1.png',0,1),(72,24,'kapadokya_int_2.png',0,2),(73,25,'luxurious_villa_istanbul.png',1,0),(74,25,'villa_int_1.png',0,1),(75,25,'villa_int_2.png',0,2),(76,26,'loft_ext.png',1,0),(77,26,'loft_int_1.png',0,1),(78,26,'loft_int_2.png',0,2);
/*!40000 ALTER TABLE `propertyphotos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `review_id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `guest_id` int NOT NULL,
  `property_id` int NOT NULL,
  `rating` tinyint DEFAULT NULL,
  `comment` text COLLATE utf8mb4_general_ci,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `ai_sentiment` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ai_status` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`review_id`),
  UNIQUE KEY `booking_id` (`booking_id`),
  KEY `guest_id` (`guest_id`),
  KEY `property_id` (`property_id`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`guest_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_ibfk_3` FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_chk_1` CHECK ((`rating` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (1,1,3,1,5,'It was clean and just like the photos.','2026-04-17 11:00:15','POSITIVE','APPROVED'),(2,5,3,4,5,'It was excellent!','2026-04-17 12:07:11','POSITIVE','APPROVED'),(3,8,10,5,4,'A charming place that truly captures the spirit of Alacati. Breakfast was amazing, only the parking is a bit tricky.','2026-04-17 12:07:11','POSITIVE','APPROVED'),(4,16,18,9,4,'Waking up to a delicious breakfast was wonderful. The atmosphere was exactly what we were looking for.','2026-04-17 12:10:21','POSITIVE','APPROVED'),(5,18,19,10,3,'Met our expectations, good value for money. Would consider staying again.','2026-04-17 12:10:21','NEUTRAL','APPROVED'),(6,19,20,10,5,'The host was very attentive and the place is even more beautiful than the photos.','2026-04-17 12:10:21','POSITIVE','APPROVED'),(7,20,17,10,4,'Check-in was very easy. The location was close to the center, everything was at hand.','2026-04-17 12:10:21','POSITIVE','APPROVED'),(8,21,16,11,3,'Overall nice but we had trouble with parking. Still reasonable for a city stay.','2026-04-17 12:10:21','NEUTRAL','APPROVED'),(9,26,17,13,4,'The sleep quality was excellent and the view was breathtaking. See you next time!','2026-04-17 12:10:21','POSITIVE','APPROVED'),(10,28,20,14,5,'Highly recommended! We had a wonderful, peaceful family vacation.','2026-04-17 12:10:21','POSITIVE','APPROVED'),(11,29,18,14,4,'Waking up to a delicious breakfast was wonderful. The atmosphere was exactly what we were looking for.','2026-04-17 12:10:21','POSITIVE','APPROVED'),(12,32,17,16,4,'Waking up to a delicious breakfast was wonderful. The atmosphere was exactly what we were looking for.','2026-04-17 12:10:21','POSITIVE','APPROVED'),(13,34,20,16,5,'Highly recommended! We had a wonderful, peaceful family vacation.','2026-04-17 12:10:21','POSITIVE','APPROVED'),(14,35,16,17,5,'Perfect for a romantic getaway. Every detail has been carefully thought out.','2026-04-17 12:10:21','POSITIVE','APPROVED'),(15,37,21,18,5,'One of the best vacations of my life! Everything was perfect, I will definitely come back.','2026-04-17 12:10:21','POSITIVE','APPROVED'),(16,40,18,19,5,'The host was very attentive and the place is even more beautiful than the photos.','2026-04-17 12:10:21','POSITIVE','APPROVED'),(17,41,17,19,3,'Met our expectations, good value for money. Would consider staying again.','2026-04-17 12:10:21','NEUTRAL','APPROVED'),(18,46,21,22,5,'One of the best vacations of my life! Everything was perfect, I will definitely come back.','2026-04-17 12:10:21','POSITIVE','APPROVED'),(19,49,18,23,3,'Overall nice but we had trouble with parking. Still reasonable for a city stay.','2026-04-17 12:10:21','NEUTRAL','APPROVED'),(20,50,17,23,5,'One of the best vacations of my life! Everything was perfect, I will definitely come back.','2026-04-17 12:10:21','POSITIVE','APPROVED'),(21,51,21,24,3,'Met our expectations, good value for money. Would consider staying again.','2026-04-17 12:10:21','NEUTRAL','APPROVED'),(22,52,19,24,4,'Waking up to a delicious breakfast was wonderful. The atmosphere was exactly what we were looking for.','2026-04-17 12:10:21','POSITIVE','APPROVED'),(23,56,18,26,5,'One of the best vacations of my life! Everything was perfect, I will definitely come back.','2026-04-17 12:10:21','POSITIVE','APPROVED'),(24,57,21,26,3,'Met our expectations, good value for money. Would consider staying again.','2026-04-17 12:10:21','NEUTRAL','APPROVED'),(28,58,8,1,1,'Horrible experience. The room was dirty, there was no hot water, and the host was very rude. Avoid this place at all costs!','2026-04-17 22:38:44','NEGATIVE','APPROVED'),(29,59,9,2,1,'Disappointing stay. The photos are totally misleading. The place is falling apart and smells like mold. Never again.','2026-04-17 22:38:44','NEGATIVE','APPROVED'),(30,60,10,3,2,'Extremely noisy and unsafe. I couldn\'t sleep at all because of the loud music next door. The lock on the door was broken too.','2026-04-17 22:38:44','NEGATIVE','APPROVED'),(31,61,16,4,1,'The place was freezing cold and the heater didn\'t work. When I called the host, they completely ignored me. Very unprofessional.','2026-04-17 22:38:45','NEGATIVE','APPROVED'),(32,62,17,5,2,'Waste of money. It was overpriced for what it was. Breakfast was stale and the pool was closed for maintenance without notice.','2026-04-17 22:38:45','NEGATIVE','APPROVED'),(33,63,8,6,3,'It was just okay. Not great, but not bad either. The location is good but the room is quite small for the price.','2026-04-17 22:38:45','NEUTRAL','APPROVED'),(34,64,9,7,3,'Average stay. Everything worked fine, but there was nothing special about it. A bit noisy during the day.','2026-04-17 22:38:45','NEUTRAL','APPROVED'),(35,65,10,8,3,'Fine for a one-night stay. Clean enough, but the furniture is very old and the bed was a bit uncomfortable.','2026-04-17 22:38:45','NEUTRAL','APPROVED'),(36,66,16,9,3,'The apartment was clean and the host was nice, but the climb up 5 floors with no elevator was exhausting. Okay overall.','2026-04-17 22:38:45','NEUTRAL','APPROVED'),(37,67,17,10,4,'Good location and fast wifi, but the bathroom was quite cramped. It is a decent choice for budget travelers.','2026-04-17 22:38:45','NEUTRAL','APPROVED'),(38,68,8,6,1,'Terrible, dirty, and loud. I want a refund.','2026-04-17 22:41:33','NEGATIVE','APPROVED'),(39,69,9,7,1,'Avoid at all costs. The host scammed me.','2026-04-17 22:41:33','NEGATIVE','APPROVED'),(40,70,10,8,1,'Disgusting environment. Cockroaches everywhere.','2026-04-17 22:41:33','NEGATIVE','APPROVED');
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usercards`
--

DROP TABLE IF EXISTS `usercards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usercards` (
  `card_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `card_holder` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `card_number_masked` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `expiry_date` varchar(7) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`card_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `usercards_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usercards`
--

LOCK TABLES `usercards` WRITE;
/*!40000 ALTER TABLE `usercards` DISABLE KEYS */;
INSERT INTO `usercards` VALUES (1,3,'yasin','**** **** **** 3123','123123');
/*!40000 ALTER TABLE `usercards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `role` enum('host','guest','admin') COLLATE utf8mb4_general_ci DEFAULT 'guest',
  `account_status` enum('active','inactive','suspended') COLLATE utf8mb4_general_ci DEFAULT 'active',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'System Admin','admin@example.com',NULL,'scrypt:32768:8:1$1bBhvQ2iJf2WUhfA$7327e5a2ef8a40102bc7c2f8d5c2ec532399bc96fd681b1623aa04212417511a6e1dbe79330e406b689e9ad2e5d9adeb040fb7a90d92ac06784408c258bfe328','admin','active','2026-04-17 00:39:45'),(2,'Ahmet Evsahibi','host@example.com',NULL,'scrypt:32768:8:1$1bBhvQ2iJf2WUhfA$7327e5a2ef8a40102bc7c2f8d5c2ec532399bc96fd681b1623aa04212417511a6e1dbe79330e406b689e9ad2e5d9adeb040fb7a90d92ac06784408c258bfe328','host','active','2026-04-17 00:39:45'),(3,'Mehmet Misafir','guest@example.com',NULL,'scrypt:32768:8:1$1bBhvQ2iJf2WUhfA$7327e5a2ef8a40102bc7c2f8d5c2ec532399bc96fd681b1623aa04212417511a6e1dbe79330e406b689e9ad2e5d9adeb040fb7a90d92ac06784408c258bfe328','guest','active','2026-04-17 00:39:45'),(4,'Zeynep Hanım','zeynep@example.com','05321112233','scrypt:32768:8:1$e3kEcPH3S6muGV5V$c727d7935007148a73e26a9775180998cffefd940552be50319f8babbe2ef83f86bd4104ab4ae54c6afb228a87e3f18ddbba841b80b08f5951a84063ac4b8c0f','host','active','2026-04-17 12:05:41'),(7,'Burak Yilmaz','burak@example.com','05444556677','scrypt:32768:8:1$qHlUEeTx71MeYZYI$875154ad48ff01533fbb8904eb481e8ff7a8e589ac3199a2b5f84b595e4b89a5c2b3d74dde2e410b0b6e089bf647254d9e604694ba2c358b5475fcd844015689','host','active','2026-04-17 12:07:11'),(8,'Selin Arslan','selin@example.com','05559991122','scrypt:32768:8:1$qHlUEeTx71MeYZYI$875154ad48ff01533fbb8904eb481e8ff7a8e589ac3199a2b5f84b595e4b89a5c2b3d74dde2e410b0b6e089bf647254d9e604694ba2c358b5475fcd844015689','guest','active','2026-04-17 12:07:11'),(9,'Emre Demir','emre@example.com','05332223344','scrypt:32768:8:1$qHlUEeTx71MeYZYI$875154ad48ff01533fbb8904eb481e8ff7a8e589ac3199a2b5f84b595e4b89a5c2b3d74dde2e410b0b6e089bf647254d9e604694ba2c358b5475fcd844015689','guest','active','2026-04-17 12:07:11'),(10,'Ayse Kaya','ayse@example.com','05446667788','scrypt:32768:8:1$qHlUEeTx71MeYZYI$875154ad48ff01533fbb8904eb481e8ff7a8e589ac3199a2b5f84b595e4b89a5c2b3d74dde2e410b0b6e089bf647254d9e604694ba2c358b5475fcd844015689','guest','active','2026-04-17 12:07:11'),(11,'Can Ozdemir','can@host.com','05311234567','scrypt:32768:8:1$GxXj8toGnviLU650$1a67e4ed42ce106f5c3b9f31a9bec087c7a3df9a80810524a39386a7a7cdaf97fc253dea9f06da65109f228930c282cee30477a93d4767a5a19d4b0b902bc679','host','active','2026-04-17 12:10:21'),(12,'Deniz Aktug','deniz@host.com','05422345678','scrypt:32768:8:1$GxXj8toGnviLU650$1a67e4ed42ce106f5c3b9f31a9bec087c7a3df9a80810524a39386a7a7cdaf97fc253dea9f06da65109f228930c282cee30477a93d4767a5a19d4b0b902bc679','host','active','2026-04-17 12:10:21'),(13,'Fatma Bulut','fatma@host.com','05533456789','scrypt:32768:8:1$GxXj8toGnviLU650$1a67e4ed42ce106f5c3b9f31a9bec087c7a3df9a80810524a39386a7a7cdaf97fc253dea9f06da65109f228930c282cee30477a93d4767a5a19d4b0b902bc679','host','active','2026-04-17 12:10:21'),(14,'Haluk Erdem','haluk@host.com','05644567890','scrypt:32768:8:1$GxXj8toGnviLU650$1a67e4ed42ce106f5c3b9f31a9bec087c7a3df9a80810524a39386a7a7cdaf97fc253dea9f06da65109f228930c282cee30477a93d4767a5a19d4b0b902bc679','host','active','2026-04-17 12:10:21'),(15,'Ipek Sahin','ipek@host.com','05755678901','scrypt:32768:8:1$GxXj8toGnviLU650$1a67e4ed42ce106f5c3b9f31a9bec087c7a3df9a80810524a39386a7a7cdaf97fc253dea9f06da65109f228930c282cee30477a93d4767a5a19d4b0b902bc679','host','active','2026-04-17 12:10:21'),(16,'Murat Celik','murat@guest.com','05311112222','scrypt:32768:8:1$GxXj8toGnviLU650$1a67e4ed42ce106f5c3b9f31a9bec087c7a3df9a80810524a39386a7a7cdaf97fc253dea9f06da65109f228930c282cee30477a93d4767a5a19d4b0b902bc679','guest','active','2026-04-17 12:10:21'),(17,'Filiz Yildiz','filiz@guest.com','05422223333','scrypt:32768:8:1$GxXj8toGnviLU650$1a67e4ed42ce106f5c3b9f31a9bec087c7a3df9a80810524a39386a7a7cdaf97fc253dea9f06da65109f228930c282cee30477a93d4767a5a19d4b0b902bc679','guest','active','2026-04-17 12:10:21'),(18,'Oguz Cinar','oguz@guest.com','05533334444','scrypt:32768:8:1$GxXj8toGnviLU650$1a67e4ed42ce106f5c3b9f31a9bec087c7a3df9a80810524a39386a7a7cdaf97fc253dea9f06da65109f228930c282cee30477a93d4767a5a19d4b0b902bc679','guest','active','2026-04-17 12:10:21'),(19,'Tugce Aydın','tugce@guest.com','05644445555','scrypt:32768:8:1$GxXj8toGnviLU650$1a67e4ed42ce106f5c3b9f31a9bec087c7a3df9a80810524a39386a7a7cdaf97fc253dea9f06da65109f228930c282cee30477a93d4767a5a19d4b0b902bc679','guest','active','2026-04-17 12:10:21'),(20,'Baran Korkmaz','baran@guest.com','05755556666','scrypt:32768:8:1$GxXj8toGnviLU650$1a67e4ed42ce106f5c3b9f31a9bec087c7a3df9a80810524a39386a7a7cdaf97fc253dea9f06da65109f228930c282cee30477a93d4767a5a19d4b0b902bc679','guest','active','2026-04-17 12:10:21'),(21,'Nilay Duman','nilay@guest.com','05866667777','scrypt:32768:8:1$GxXj8toGnviLU650$1a67e4ed42ce106f5c3b9f31a9bec087c7a3df9a80810524a39386a7a7cdaf97fc253dea9f06da65109f228930c282cee30477a93d4767a5a19d4b0b902bc679','guest','active','2026-04-17 12:10:21');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `hms_citystatistics`
--

/*!50001 DROP VIEW IF EXISTS `hms_citystatistics`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `hms_citystatistics` AS select `properties`.`city` AS `city`,count(`properties`.`property_id`) AS `total_properties`,min(`properties`.`base_price`) AS `min_price`,max(`properties`.`base_price`) AS `max_price`,avg(`properties`.`base_price`) AS `avg_price` from `properties` group by `properties`.`city` having (count(`properties`.`property_id`) > 0) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `hms_detailedreservations`
--

/*!50001 DROP VIEW IF EXISTS `hms_detailedreservations`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `hms_detailedreservations` AS select `b`.`booking_id` AS `booking_id`,`u`.`full_name` AS `guest_name`,`p`.`title` AS `property_title`,`p`.`city` AS `city`,`b`.`check_in` AS `check_in`,`b`.`check_out` AS `check_out`,`b`.`total_price` AS `total_price`,`b`.`status` AS `booking_status`,`pay`.`payment_status` AS `payment_status`,`pay`.`amount` AS `paid_amount` from (((`bookings` `b` join `users` `u` on((`b`.`guest_id` = `u`.`user_id`))) join `properties` `p` on((`b`.`property_id` = `p`.`property_id`))) left join `payments` `pay` on((`b`.`booking_id` = `pay`.`booking_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `hms_monthlyguesttracker`
--

/*!50001 DROP VIEW IF EXISTS `hms_monthlyguesttracker`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `hms_monthlyguesttracker` AS select `p`.`property_id` AS `property_id`,`p`.`title` AS `property_title`,`u`.`full_name` AS `primary_guest_name`,`bg`.`full_name` AS `additional_guest_name`,`bg`.`relationship` AS `relationship`,`b`.`check_in` AS `check_in`,month(`b`.`check_in`) AS `stay_month`,year(`b`.`check_in`) AS `stay_year` from (((`bookings` `b` join `properties` `p` on((`b`.`property_id` = `p`.`property_id`))) join `users` `u` on((`b`.`guest_id` = `u`.`user_id`))) left join `bookingguests` `bg` on((`b`.`booking_id` = `bg`.`booking_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `hms_propertyanalytics`
--

/*!50001 DROP VIEW IF EXISTS `hms_propertyanalytics`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `hms_propertyanalytics` AS select `p`.`property_id` AS `property_id`,`p`.`title` AS `title`,`p`.`city` AS `city`,count(`r`.`review_id`) AS `review_count`,round(avg(`r`.`rating`),1) AS `average_rating`,(select count(0) from `bookings` `b` where ((`b`.`property_id` = `p`.`property_id`) and (`b`.`status` = 'completed'))) AS `total_stays` from (`properties` `p` left join `reviews` `r` on((`p`.`property_id` = `r`.`property_id`))) group by `p`.`property_id`,`p`.`title`,`p`.`city` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `hms_propertybookingsummary`
--

/*!50001 DROP VIEW IF EXISTS `hms_propertybookingsummary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `hms_propertybookingsummary` AS select `p`.`property_id` AS `property_id`,`p`.`title` AS `property_title`,`u`.`full_name` AS `host_name`,count(`b`.`booking_id`) AS `total_bookings` from ((`properties` `p` join `users` `u` on((`p`.`host_id` = `u`.`user_id`))) left join `bookings` `b` on((`p`.`property_id` = `b`.`property_id`))) group by `p`.`property_id`,`p`.`title`,`u`.`full_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `hms_successfulhosts`
--

/*!50001 DROP VIEW IF EXISTS `hms_successfulhosts`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `hms_successfulhosts` AS select `u`.`full_name` AS `full_name`,`u`.`email` AS `email`,count(`p`.`property_id`) AS `listing_count` from (`users` `u` join `properties` `p` on((`u`.`user_id` = `p`.`host_id`))) where `u`.`user_id` in (select `properties`.`host_id` from `properties` where `properties`.`property_id` in (select `reviews`.`property_id` from `reviews` where (`reviews`.`rating` = 5))) group by `u`.`user_id` */;
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

-- Dump completed on 2026-04-18  0:41:41
