-- MySQL dump 10.13  Distrib 5.7.23, for Linux (x86_64)
--
-- Host: zestylemon.mysql.pythonanywhere-services.com    Database: zestylemon$comments
-- ------------------------------------------------------
-- Server version	5.7.21-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `albums`
--

DROP TABLE IF EXISTS `albums`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `albums` (
  `album_id` int(11) NOT NULL,
  `album_name` varchar(250) DEFAULT NULL,
  `fk_user_id` int(11) DEFAULT NULL,
  `album_art` blob,
  PRIMARY KEY (`album_id`),
  KEY `fk_user_id` (`fk_user_id`),
  CONSTRAINT `albums_ibfk_1` FOREIGN KEY (`fk_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `albums`
--

LOCK TABLES `albums` WRITE;
/*!40000 ALTER TABLE `albums` DISABLE KEYS */;
/*!40000 ALTER TABLE `albums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alembic_version`
--

DROP TABLE IF EXISTS `alembic_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL,
  PRIMARY KEY (`version_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alembic_version`
--

LOCK TABLES `alembic_version` WRITE;
/*!40000 ALTER TABLE `alembic_version` DISABLE KEYS */;
INSERT INTO `alembic_version` VALUES ('abf9a61063e2');
/*!40000 ALTER TABLE `alembic_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` varchar(4096) DEFAULT NULL,
  `posted` datetime DEFAULT NULL,
  `commenter_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `commenter_id` (`commenter_id`),
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`commenter_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` VALUES (1,'hi',NULL,NULL),(2,'hi',NULL,NULL),(3,'test time\r\n','2019-02-23 21:27:13',NULL),(4,'hi','2019-02-23 21:47:28',1);
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fav_tracks`
--

DROP TABLE IF EXISTS `fav_tracks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fav_tracks` (
  `song_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  KEY `song_id` (`song_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `fav_tracks_ibfk_1` FOREIGN KEY (`song_id`) REFERENCES `songs` (`song_id`),
  CONSTRAINT `fav_tracks_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fav_tracks`
--

LOCK TABLES `fav_tracks` WRITE;
/*!40000 ALTER TABLE `fav_tracks` DISABLE KEYS */;
/*!40000 ALTER TABLE `fav_tracks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `songs`
--

DROP TABLE IF EXISTS `songs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `songs` (
  `song_id` int(11) NOT NULL AUTO_INCREMENT,
  `song_name` varchar(255) DEFAULT NULL,
  `mp3_file` blob,
  `fk_user_id` int(11) DEFAULT NULL,
  `fk_album_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`song_id`),
  KEY `fk_user_id` (`fk_user_id`),
  KEY `fk_album_id` (`fk_album_id`),
  CONSTRAINT `songs_ibfk_1` FOREIGN KEY (`fk_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `songs_ibfk_2` FOREIGN KEY (`fk_album_id`) REFERENCES `albums` (`album_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `songs`
--

LOCK TABLES `songs` WRITE;
/*!40000 ALTER TABLE `songs` DISABLE KEYS */;
/*!40000 ALTER TABLE `songs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(128) DEFAULT NULL,
  `password_hash` varchar(128) DEFAULT NULL,
  `artist_name` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `genre` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','pbkdf2:sha256:50000$7WlOyGmX$817b40821453d90ceb0a42f6941f59f7ddfe6191842e0a7c237d9cf877cc97de',NULL,NULL,NULL),(2,'bob','pbkdf2:sha256:50000$jQk07vYA$24f05655141bd52c0c65a5494a5bb99c3134be4665a8566e732761ebb0069e6d',NULL,NULL,NULL),(3,'caroline','pbkdf2:sha256:50000$lhW7oFeq$bcd2112d57e62005f75348c7bb06f259fdf84717210b1e7d6d4c5e4d82c8894b',NULL,NULL,NULL),(4,'zestylemon1826','pbkdf2:sha256:50000$ACTdZ23u$9909a029ee06bf8b133605a62b8a223ee1260b921ff396d42db3628286cd2b7c','zesty lemon','dc','pop');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-03-27 19:01:50
