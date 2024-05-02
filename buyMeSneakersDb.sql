DROP DATABASE IF EXISTS `projectDB`;
CREATE DATABASE IF NOT EXISTS `projectDB`;
USE `projectDB`;



DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE users(
`username` varchar(30) 	NOT NULL,
`password` varchar(30) 	NOT NULL,
primary key(`username`));


DROP TABLE IF EXISTS `createListing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
create table createListing(
`listID` int auto_increment,
`name` varchar(40),
`brand` varchar(6), 
`gender` varchar(10),
`size` float, 
`startingPrice` float, 
`minPrice` float, 
`closingDateTime` datetime, 
`status` varchar(10) default 'Open',
`originalPrice` float,
primary key(`listID`));

DROP TABLE IF EXISTS `userPosts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
create table userPosts(
`listID` int, 
`username` varchar(30), 
foreign key(`username`) references users(`username`)
	on delete cascade
    on update cascade, 
foreign key(`listID`) references createListing(`listID`)
	on delete cascade,
primary key(`listID`));


DROP TABLE IF EXISTS `bids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
create table `bids`(
`bidID` int auto_increment, 
`price` float, 
`dateTime` datetime, 
`username` varchar(30), 
foreign key (`username`) references users(`username`)
	on delete cascade
    on update cascade,
primary key(`bidID`));


DROP TABLE IF EXISTS `autoBids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
create table `autoBids`(
`username` varchar(30), 
`listID` int, 
`increment` float, 
`currentPrice` float, 
`bidLimit` float, 
foreign key(`username`) references users(`username`)
	on delete cascade
    on update cascade, 
foreign key(`listID`) references createListing(`listID`)
	on delete cascade
    on update cascade, 
primary key(`username`, `listID`));


DROP TABLE IF EXISTS `onListing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
create table `onListing`(
`bidID` int, 
`listID` int, 
foreign key(`bidID`) references bids(`bidID`)
	on delete cascade,
foreign key(`listID`) references createListing(`listID`)
	on delete cascade,
primary key(`bidID`));


DROP TABLE IF EXISTS `places`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
create table `places`(
`bidID` int, 
`username` varchar(30), 
foreign key(`bidID`) references bids(`bidID`)
	on delete cascade
    on update cascade, 
foreign key(`username`) references users(`username`)
	on delete cascade
    on update cascade);
    

DROP TABLE IF EXISTS `interests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
create table `interests`(
`username` varchar(30), 
`interests` varchar(30), 
foreign key(`username`) references users(`username`) 
	on delete cascade
    on update cascade, 
primary key(`username`, `interests`));


DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
create table `admin`(
`adminID` int, 
`password` varchar(30), 
primary key(`adminID`));

insert into `admin` values(123, "adminPassword");


DROP TABLE IF EXISTS `custRep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
create table `custRep`(
`repID` int, 
`password` varchar(30), 
primary key(`repID`));


DROP TABLE IF EXISTS `adminCreatesRep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
create table `adminCreatesRep`(
`adminID` int, 
`repID` int, 
foreign key(`adminID`) references admin(`adminID`), 
foreign key(`repID`) references custRep(`repID`));


DROP TABLE IF EXISTS `questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `questions`(
    `questionID` int AUTO_INCREMENT,
    `subject` varchar(30) NOT NULL,
    `questionText` varchar(255) NOT NULL,
    `customerUsername` varchar(30),
    `repID` int,
    `answerText` varchar(255),
    `isResolved` boolean DEFAULT FALSE,
    `questionDate` datetime NOT NULL,
    PRIMARY KEY (`questionID`),
    FOREIGN KEY (`customerUsername`) REFERENCES users(`username`),
    FOREIGN KEY (`repID`) REFERENCES custRep(`repID`),
    INDEX `rep_idx` (`repID`)
);
