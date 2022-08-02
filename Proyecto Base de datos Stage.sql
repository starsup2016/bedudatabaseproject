-- Selecting the Database
use basket;

-- -------------------------------------
-- 			  CITIES TABLE 			  --
-- -------------------------------------
-- Checking structure
describe cities;
show create table cities;
-- adding primary key
alter table cities add primary key (CityID); 
select * from cities;

-- -------------------------------------
-- 			  MTEAMS TABLE 			  --
-- -------------------------------------
-- Checking structure
describe mteams;
-- addign primary key to table mteams
alter table mteams add primary key (TeamID);

-- Regular Query
Select * from mteams;

show create table mteams;
CREATE TABLE `mteams` (
   `TeamID` int NOT NULL,
   `TeamName` text,
   `FirstD1Season` int DEFAULT NULL,
   `LastD1Season` int DEFAULT NULL,
   PRIMARY KEY (`TeamID`)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
 
-- adding comments to fields to transactionals fields
 alter table mteams modify column `TeamID` int comment "A 4 digit id number, from 1000-1999, uniquely identifying each NCAA® men's team";
 alter table mteams modify column `TeamName` text comment "a compact spelling of the team's college name, 16 characters or fewer";
 alter table mteams modify column `FirstD1Season` int comment "the first season in our dataset that the school was a Division-I school";
 alter table mteams modify column `LastD1Season` int comment "the last season in our dataset that the school was a Division-I school";
 
 
 



-- -------------------------------------
-- MREGULARSEASONCOMPACTRESULTS TABLE --
-- -------------------------------------
describe mregularseasoncompactresults;
-- Adding foreign key to mregularseasoncompactresults
alter table mregularseasoncompactresults add foreign key (WTeamID) references mteams(TeamID);
alter table mregularseasoncompactresults add foreign key (LTeamID) references mteams(TeamID);
-- listing all values
select * from mregularseasoncompactresults;

-- -------------------------------------
-- 			CONFERENCES TABLE 		  --
-- -------------------------------------
describe conferences;
-- adding primary key to table
alter table conferences add primary key (ConfAbbrev);
--
select * from conferences;
-- Checking max length of the content of the field 'ConfAbbrev'
select length(ConfAbbrev) as lo from conferences order by lo desc;
-- transforming the length of the field 'ConfAbbrev'
alter table conferences modify column ConfAbbrev varchar(10);

-- -------------------------------------
-- 			MTEAMCOACHES TABLE 		  --
-- -------------------------------------
describe mteamcoaches;
alter table mteamcoaches add foreign key (TeamID) references mteams(TeamID);
show create table mteamcoaches;
CREATE TABLE `mteamcoaches` (
   `Season` int DEFAULT NULL,
   `TeamID` int DEFAULT NULL,
   `FirstDayNum` int DEFAULT NULL,
   `LastDayNum` int DEFAULT NULL,
   `CoachName` text,
   KEY `TeamID` (`TeamID`),
   CONSTRAINT `mteamcoaches_ibfk_1` FOREIGN KEY (`TeamID`) REFERENCES `mteams` (`TeamID`)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
 
 -- adding comments to fields to transactionals fields
 alter table mteamcoaches modify column `Season` int comment "the calendar year in which the final tournament occurs";
 alter table mteamcoaches modify column `TeamID` int comment " this is the TeamID of the team that was coached";
 alter table mteamcoaches modify column `FirstDayNum` int comment "this defines a continuous range of days within the season, during which the indicated coach was the head coach of the team";
 alter table mteamcoaches modify column `LastDayNum` int comment "this defines a continuous range of days within the season, during which the indicated coach was the head coach of the team";
 alter table mteamcoaches modify column `CoachName` text comment "this is a text representation of the coach's full name, in the format first_last, with underscores substituted in for spaces";


-- -------------------------------------
-- 				Queries 		      --
-- -------------------------------------
select * from mteamcoaches;
-- Get max number of seasons per coach
select CoachName, count(CoachName) as num from mteamcoaches group by CoachName order by num desc;
-- Get seasons per each Coach Name
select CoachName, season from mteamcoaches where CoachName = 'aaron_james' order by CoachName, season asc;

-- Let get the top 5 total wins per team and total loss per team and show its name
select b.TeamName, count(a.WTeamID) as MostWin from mregularseasoncompactresults as a join mteams as b on WTeamID = TeamID group by b.TeamName order by MostWin Desc limit 5;
-- Basically the same but counting LTeamID field to get the top 5 losses
select b.TeamName, count(a.LTeamID) as MostLosses from mregularseasoncompactresults as a join mteams as b on LTeamID = TeamID group by b.TeamName order by MostLosses Desc limit 5;

-- Average wins in the past (38 seasons from 1985 to 2022)
select b.TeamName, avg(a.WTeamID) as Average from mregularseasoncompactresults as a join mteams as b on WTeamID = TeamID group by b.TeamName order by b.TeamName Desc;
-- Average losses in the past (38 seasons from 1985 to 2022)
select b.TeamName, avg(a.LTeamID) as Average from mregularseasoncompactresults as a join mteams as b on LTeamID = TeamID group by b.TeamName order by b.TeamName Desc;

select distinct Season from mregularseasoncompactresults order by Season;
select count(distinct Season) from mregularseasoncompactresults order by Season;

-- Let get the total wins per coach per team 
select c.CoachName, b.TeamName, count(a.WTeamID) as MostWin from mteamcoaches as c join mteams as b join mregularseasoncompactresults as a on a.WTeamID = b.TeamID on c.TeamID = b.TeamID Group by c.CoachName, b.TeamName order by c.CoachName, MostWin;

-- Now we create a view since the query is tough
create view wins_per_coach as select c.CoachName, b.TeamName, count(a.WTeamID) as MostWin from mteamcoaches as c join mteams as b join mregularseasoncompactresults as a on a.WTeamID = b.TeamID on c.TeamID = b.TeamID Group by c.CoachName, b.TeamName order by c.CoachName, MostWin;
-- Let list from view
Select * from wins_per_coach order by MostWin desc limit 10;

