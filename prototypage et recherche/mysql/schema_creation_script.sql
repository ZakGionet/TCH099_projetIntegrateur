-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema LifeDashboard
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema LifeDashboard
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LifeDashboard` DEFAULT CHARACTER SET utf8 ;
-- -----------------------------------------------------
-- Schema new_schema1
-- -----------------------------------------------------
USE `LifeDashboard` ;

-- -----------------------------------------------------
-- Table `LifeDashboard`.`Semesters`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LifeDashboard`.`Semesters` (
  `semesterId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `startDate` DATE NULL,
  `endDate` DATE NULL,
  PRIMARY KEY (`semesterId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LifeDashboard`.`Classes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LifeDashboard`.`Classes` (
  `classId` INT NOT NULL AUTO_INCREMENT,
  `semesterId` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL COMMENT 'Class name',
  `code` VARCHAR(45) NULL COMMENT '3 letter, 3 number unique class code',
  `startDate` DATE NULL COMMENT 'Starting date of the class, by default should take the date associated with the semester but should be able to be manually overwritten.',
  `endDate` DATE NULL COMMENT 'The last day of the semester.',
  `dateCreated` DATE GENERATED ALWAYS AS (CURRENT_DATE) VIRTUAL COMMENT 'The date at which the class was added to the database.',
  `lastAccessed` DATE NULL COMMENT 'The last time the class was accessed.',
  `classDay` VARCHAR(45) NULL COMMENT 'Class seminar day. Could possibly be a semi-colon separated string, such as monday;tuesday;friday',
  `classStartTime` VARCHAR(45) NULL COMMENT 'Class starting time, could be semi-colon or comma separated, like 12:30;9:00',
  `classEndTime` VARCHAR(45) NULL COMMENT 'Class ending time',
  `hasLab` TINYINT NULL COMMENT 'True (1) if class has a lab, false (0) otherwise.',
  `labDay` VARCHAR(45) NULL,
  `labStartTime` VARCHAR(45) NULL,
  `labEndTime` VARCHAR(45) NULL,
  `instructor` VARCHAR(45) NULL,
  `group` VARCHAR(45) NULL COMMENT 'Groupe for labs, usually lettered',
  `section` INT NULL COMMENT 'Cohort section, usually numbered.',
  PRIMARY KEY (`classId`),
  CONSTRAINT `semesterId`
    FOREIGN KEY (`semesterId`)
    REFERENCES `LifeDashboard`.`Semesters` (`semesterId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `semesterId_idx` ON `LifeDashboard`.`Classes` (`semesterId` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `LifeDashboard`.`UrgencyLabels`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LifeDashboard`.`UrgencyLabels` (
  `UrgencyLabelId` INT NOT NULL AUTO_INCREMENT,
  `label` VARCHAR(45) NULL,
  `minScore` DECIMAL(4,2) NULL,
  `maxScore` DECIMAL(4,2) NULL,
  `color` VARCHAR(45) NULL,
  PRIMARY KEY (`UrgencyLabelId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LifeDashboard`.`DifficultyLabels`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LifeDashboard`.`DifficultyLabels` (
  `difficultyLabelId` INT NOT NULL AUTO_INCREMENT,
  `label` VARCHAR(200) NULL,
  `minScore` DECIMAL(4,2) NULL,
  `maxScore` DECIMAL(4,2) NULL,
  `color` VARCHAR(45) NULL,
  PRIMARY KEY (`difficultyLabelId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LifeDashboard`.`Topics`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LifeDashboard`.`Topics` (
  `topicId` INT NOT NULL AUTO_INCREMENT,
  `classId` INT NOT NULL,
  `urgencyLevelId` INT NOT NULL,
  `difficultyId` INT NOT NULL,
  `name` VARCHAR(200) NOT NULL,
  `description` VARCHAR(200) NULL,
  `startDate` DATE NULL COMMENT 'The day of the week on which the slides were covered in class',
  `estimatedEndDate` DATE NULL COMMENT 'Calculated using the calculated difficulty of the material.',
  `actualEndDate` DATE NULL COMMENT 'Date on which the user considers the slides understood.',
  `progress` INT NULL DEFAULT 0 COMMENT 'Calculated based on the total number of slides and slides covered.',
  `urgencyStatus` DECIMAL(4,2) NULL COMMENT 'Calculated by looking at the dates of any projects related to it and how long it\'s estimated to take.',
  `perceivedDifficulty` INT NULL DEFAULT 'medium' COMMENT 'Initial perceived difficulty, can be updated throughout.',
  `calculatedDifficulty` INT NULL COMMENT 'Calculated based on the number of slides and the perceived difficulty.',
  `actualDifficulty` INT NULL COMMENT 'How hard the content was to learn',
  `contentLength` INT NULL,
  `timeSpentTotal` INT NULL DEFAULT 0,
  `noteLink` VARCHAR(100) NULL COMMENT 'Link to notes taken related to topic.',
  PRIMARY KEY (`topicId`),
  CONSTRAINT `classId`
    FOREIGN KEY (`classId`)
    REFERENCES `LifeDashboard`.`Classes` (`classId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `urgencyLevelId`
    FOREIGN KEY (`urgencyLevelId`)
    REFERENCES `LifeDashboard`.`UrgencyLabels` (`UrgencyLabelId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `difficultyId`
    FOREIGN KEY (`difficultyId`)
    REFERENCES `LifeDashboard`.`DifficultyLabels` (`difficultyLabelId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `classId_idx` ON `LifeDashboard`.`Topics` (`classId` ASC) VISIBLE;

CREATE INDEX `urgencyLevelId_idx` ON `LifeDashboard`.`Topics` (`urgencyLevelId` ASC) VISIBLE;

CREATE INDEX `difficultyId_idx` ON `LifeDashboard`.`Topics` (`difficultyId` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `LifeDashboard`.`ProjectTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LifeDashboard`.`ProjectTypes` (
  `projectTypeId` INT NOT NULL AUTO_INCREMENT,
  `name` INT NOT NULL,
  PRIMARY KEY (`projectTypeId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LifeDashboard`.`StatusLabels`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LifeDashboard`.`StatusLabels` (
  `StatusLabelId` INT NOT NULL AUTO_INCREMENT,
  `label` VARCHAR(45) NULL,
  `description` VARCHAR(45) NULL,
  PRIMARY KEY (`StatusLabelId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LifeDashboard`.`Projects`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LifeDashboard`.`Projects` (
  `projectId` INT NOT NULL AUTO_INCREMENT,
  `classId` INT NOT NULL,
  `projectTypeId` INT NOT NULL,
  `statusId` INT NOT NULL,
  `difficultyId` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL COMMENT 'Project name',
  `urgencyScore` DECIMAL(4,2) GENERATED ALWAYS AS (1 - (DATEDIFF(dueDate, CURDATE()) / estimatedDays)) VIRTUAL COMMENT 'Calculated using how many days are left and how many estimated days are needed.',
  `calculatedDifficultyScore` DECIMAL(4,2) NULL COMMENT 'Calculated with number of milestones, time given, time left.',
  `progressScore` DECIMAL(4,2) NULL DEFAULT 0 COMMENT 'Calculated based on the number of milestones, and maybe the difficulty of every milestone. ranges from 0-1. Calculation is something like milestones completed / milestones total.',
  `startDate` DATE NULL COMMENT 'Start date of the project (when it was made available). \n\nIf a project is unavailable, calculated based on the week the project is indicated for.',
  `dueDate` DATE NULL COMMENT 'Due date of the project.',
  `description` VARCHAR(200) NULL COMMENT 'Project description',
  `completedDate` DATE NULL COMMENT 'Set when a project has completed all milestones.',
  `estimatedDifficulty` DECIMAL(4,2) NULL COMMENT 'User-estimated difficulty.',
  `actualDifficulty` DECIMAL(4,2) NULL COMMENT 'Calculated based on time submitted before deadline.',
  `lastAccessed` DATE NULL COMMENT 'Last day a project was worked on.',
  `estimatedDays` INT NULL COMMENT 'Calculated based on the sum of all estimated days of milestones.',
  `actualDays` INT NULL COMMENT 'Calculated when project is done, completed date - due date.',
  `timeSpent` INT NULL DEFAULT 0 COMMENT 'Time spend in minutes on a project, cumulated by project session time.',
  `isAvailable` TINYINT NULL DEFAULT 0 COMMENT 'If project is available to start.',
  `hasStartDate` TINYINT NULL DEFAULT 0 COMMENT 'True (1) if project has a start date, this could be an estimate start date or a real one, otherwise false (0).',
  `milestoneCount` INT GENERATED ALWAYS AS () VIRTUAL,
  PRIMARY KEY (`projectId`),
  CONSTRAINT `classId`
    FOREIGN KEY (`classId`)
    REFERENCES `LifeDashboard`.`Classes` (`classId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `projectTypeId`
    FOREIGN KEY (`projectTypeId`)
    REFERENCES `LifeDashboard`.`ProjectTypes` (`projectTypeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `projectStatusId`
    FOREIGN KEY (`statusId`)
    REFERENCES `LifeDashboard`.`StatusLabels` (`StatusLabelId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `difficultyId`
    FOREIGN KEY (`difficultyId`)
    REFERENCES `LifeDashboard`.`DifficultyLabels` (`difficultyLabelId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `classId_idx` ON `LifeDashboard`.`Projects` (`classId` ASC) VISIBLE;

CREATE INDEX `typeId_idx` ON `LifeDashboard`.`Projects` (`projectTypeId` ASC) VISIBLE;

CREATE INDEX `projectStatusId_idx` ON `LifeDashboard`.`Projects` (`statusId` ASC) VISIBLE;

CREATE INDEX `difficultyId_idx` ON `LifeDashboard`.`Projects` (`difficultyId` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `LifeDashboard`.`TopicProjects`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LifeDashboard`.`TopicProjects` (
  `projectId` INT NOT NULL,
  `topicId` INT NOT NULL,
  PRIMARY KEY (`projectId`, `topicId`),
  CONSTRAINT `topicId`
    FOREIGN KEY (`topicId`)
    REFERENCES `LifeDashboard`.`Topics` (`topicId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `projectId`
    FOREIGN KEY (`projectId`)
    REFERENCES `LifeDashboard`.`Projects` (`projectId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `topicId_idx` ON `LifeDashboard`.`TopicProjects` (`topicId` ASC) INVISIBLE;


-- -----------------------------------------------------
-- Table `LifeDashboard`.`TopicVisits`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LifeDashboard`.`TopicVisits` (
  `topicVisitId` INT NOT NULL AUTO_INCREMENT,
  `topicId` INT NOT NULL,
  `visitDateTime` DATETIME GENERATED ALWAYS AS (CURRENT_TIMESTAMP) VIRTUAL,
  `visitLocation` VARCHAR(45) NULL COMMENT 'Location of the visit, could be tracked with IP or something.',
  `timeSpent` INT NULL DEFAULT 0,
  `visitSummary` VARCHAR(1000) NULL COMMENT 'User summary of what was seen during the visit.',
  `mood` VARCHAR(45) NULL COMMENT 'How user felt after session',
  `accomplishement` VARCHAR(45) NULL COMMENT 'How the user felt they performed during their session',
  `estimatedDifficulty` VARCHAR(45) NULL COMMENT 'How difficult the user felt the session was.',
  PRIMARY KEY (`topicVisitId`),
  CONSTRAINT `topicId`
    FOREIGN KEY (`topicId`)
    REFERENCES `LifeDashboard`.`Topics` (`topicId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `topicId_idx` ON `LifeDashboard`.`TopicVisits` (`topicId` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `LifeDashboard`.`MilestoneTemplates`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LifeDashboard`.`MilestoneTemplates` (
  `milestoneTemplateId` INT NOT NULL AUTO_INCREMENT,
  `projectTypeId` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`milestoneTemplateId`),
  CONSTRAINT `projectTypeId`
    FOREIGN KEY (`projectTypeId`)
    REFERENCES `LifeDashboard`.`ProjectTypes` (`projectTypeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `projectTypeId_idx` ON `LifeDashboard`.`MilestoneTemplates` (`projectTypeId` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `LifeDashboard`.`ProjectMilestones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LifeDashboard`.`ProjectMilestones` (
  `projectMilestoneId` INT NOT NULL,
  `projectId` INT NOT NULL,
  `projectTypeId` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `urgencyScore` DECIMAL(4,2) NULL COMMENT 'Calculated in relation to the current date and the expected due date. Could be between 0-1. If past the due date, it is 1.',
  `progressScore` DECIMAL(4,2) NULL,
  `status` INT NULL DEFAULT 'not started' COMMENT 'Status of the milestone, inputted by the user. A \"done\" status lets the project know that this milestone is completed. This updates the projects status. \n\nThe status being changed to \"done\" should also set the actualEndDate to the current date.',
  `expectedEndDate` DATE NULL COMMENT 'Calculated from the start date and the estimated number of days',
  `orderIndex` INT NOT NULL COMMENT 'Order of the milestone in it\'s associated project',
  `estimatedDays` INT NOT NULL COMMENT 'The estimated number of days a milestone will take to complete. This can be modified manually at anytime, and initialized using a template.',
  `actualDays` INT NULL COMMENT 'Updated when the status of a milestone is set to \"done\". Updates actualEndDate.',
  `startDate` DATE NULL COMMENT 'When a milestone is started. This could be upon the completion of the previous milestone, or when the user chooses to start it.',
  `actualEndDate` DATE NULL COMMENT 'Set when milestone is set to \"done\".',
  `ProjectMilestonescol` VARCHAR(45) NULL,
  PRIMARY KEY (`projectMilestoneId`),
  CONSTRAINT `projectId`
    FOREIGN KEY (`projectId`)
    REFERENCES `LifeDashboard`.`Projects` (`projectId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `projectTypeId`
    FOREIGN KEY (`projectTypeId`)
    REFERENCES `LifeDashboard`.`ProjectTypes` (`projectTypeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `projectId_idx` ON `LifeDashboard`.`ProjectMilestones` (`projectId` ASC) VISIBLE;

CREATE INDEX `projectTypeId_idx` ON `LifeDashboard`.`ProjectMilestones` (`projectTypeId` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `LifeDashboard`.`ProjectSessions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LifeDashboard`.`ProjectSessions` (
  `projectSessionId` INT NOT NULL AUTO_INCREMENT,
  `projectId` INT NOT NULL,
  `projectMilestoneId` INT NOT NULL,
  `sessionStartDateTime` DATETIME NULL COMMENT 'Date and time of the session',
  `sessionEndDateTime` DATETIME NULL,
  `timeSpent` INT NULL COMMENT 'Calculated from start dateTime and end dateTime.',
  `projectSummary` VARCHAR(1000) NULL COMMENT 'Summary of what was done on the project.',
  `mood` VARCHAR(45) NULL COMMENT 'How user felt after session',
  `accomplishement` VARCHAR(45) NULL COMMENT 'How the user felt they performed during their session',
  `estimatedDifficulty` VARCHAR(45) NULL COMMENT 'How difficult the user felt the session was.',
  `ProjectSessionscol` VARCHAR(45) NULL,
  PRIMARY KEY (`projectSessionId`),
  CONSTRAINT `projectId`
    FOREIGN KEY (`projectId`)
    REFERENCES `LifeDashboard`.`Projects` (`projectId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `projectMilestoneId`
    FOREIGN KEY (`projectMilestoneId`)
    REFERENCES `LifeDashboard`.`ProjectMilestones` (`projectMilestoneId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `projectId_idx` ON `LifeDashboard`.`ProjectSessions` (`projectId` ASC) VISIBLE;

CREATE INDEX `projectMilestoneId_idx` ON `LifeDashboard`.`ProjectSessions` (`projectMilestoneId` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `LifeDashboard`.`Weeks`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LifeDashboard`.`Weeks` (
  `weekId` INT NOT NULL AUTO_INCREMENT,
  `semesterId` INT NOT NULL,
  `weekNumber` INT NOT NULL COMMENT 'Week number, goes from 1 to 15 then loops.',
  PRIMARY KEY (`weekId`),
  CONSTRAINT `semesterId`
    FOREIGN KEY (`semesterId`)
    REFERENCES `LifeDashboard`.`Semesters` (`semesterId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `semesterId_idx` ON `LifeDashboard`.`Weeks` (`semesterId` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `LifeDashboard`.`WeeksTopics`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LifeDashboard`.`WeeksTopics` (
  `WeeksTopicId` INT NOT NULL AUTO_INCREMENT,
  `topicId` INT NOT NULL,
  `semesterId` INT NOT NULL,
  `weekId` INT NOT NULL,
  PRIMARY KEY (`WeeksTopicId`),
  CONSTRAINT `topicId`
    FOREIGN KEY (`topicId`)
    REFERENCES `LifeDashboard`.`Topics` (`topicId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `semesterId`
    FOREIGN KEY (`semesterId`)
    REFERENCES `LifeDashboard`.`Semesters` (`semesterId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `weekId`
    FOREIGN KEY (`weekId`)
    REFERENCES `LifeDashboard`.`Weeks` (`weekId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `topicId_idx` ON `LifeDashboard`.`WeeksTopics` (`topicId` ASC) VISIBLE;

CREATE INDEX `semesterId_idx` ON `LifeDashboard`.`WeeksTopics` (`semesterId` ASC) VISIBLE;

CREATE INDEX `weekId_idx` ON `LifeDashboard`.`WeeksTopics` (`weekId` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `LifeDashboard`.`WeeksProjects`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LifeDashboard`.`WeeksProjects` (
  `weeksProjectId` INT NOT NULL,
  `weekId` INT NOT NULL,
  `projectId` INT NOT NULL,
  `semesterId` INT NOT NULL,
  PRIMARY KEY (`weeksProjectId`),
  CONSTRAINT `projectId`
    FOREIGN KEY (`projectId`)
    REFERENCES `LifeDashboard`.`Projects` (`projectId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `weekId`
    FOREIGN KEY (`weekId`)
    REFERENCES `LifeDashboard`.`Weeks` (`weekId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `semesterId`
    FOREIGN KEY (`semesterId`)
    REFERENCES `LifeDashboard`.`Semesters` (`semesterId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `projectId_idx` ON `LifeDashboard`.`WeeksProjects` (`projectId` ASC) VISIBLE;

CREATE INDEX `weekId_idx` ON `LifeDashboard`.`WeeksProjects` (`weekId` ASC) VISIBLE;

CREATE INDEX `semesterId_idx` ON `LifeDashboard`.`WeeksProjects` (`semesterId` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `LifeDashboard`.`WeeksMilestones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LifeDashboard`.`WeeksMilestones` (
  `weeksMilestoneId` INT NOT NULL,
  `projectMilestoneId` INT NOT NULL,
  `weekId` INT NOT NULL,
  PRIMARY KEY (`weeksMilestoneId`),
  CONSTRAINT `projectMilestoneId`
    FOREIGN KEY (`projectMilestoneId`)
    REFERENCES `LifeDashboard`.`ProjectMilestones` (`projectMilestoneId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `weekId`
    FOREIGN KEY (`weekId`)
    REFERENCES `LifeDashboard`.`Weeks` (`weekId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `projectMilestoneId_idx` ON `LifeDashboard`.`WeeksMilestones` (`projectMilestoneId` ASC) VISIBLE;

CREATE INDEX `weekId_idx` ON `LifeDashboard`.`WeeksMilestones` (`weekId` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `LifeDashboard`.`ProjectUpdates`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LifeDashboard`.`ProjectUpdates` (
  `projectUpdateId` INT NOT NULL,
  `projectId` INT NULL,
  `changedField` VARCHAR(45) NULL COMMENT 'Name of the field in sql',
  `oldValue` VARCHAR(45) NULL COMMENT 'value of the old field',
  `newValue` VARCHAR(45) NULL COMMENT 'Value of the new field',
  `dataType` VARCHAR(45) NULL COMMENT 'Datatype being changed',
  `timestamp` DATETIME NULL COMMENT 'Time and date of the change',
  `ProjectUpdatescol` VARCHAR(45) NULL,
  PRIMARY KEY (`projectUpdateId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LifeDashboard`.`progressLabels`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LifeDashboard`.`progressLabels` (
  `progressLabelId` INT NOT NULL AUTO_INCREMENT,
  `label` VARCHAR(45) NULL,
  `minScore` DECIMAL(4,2) NULL,
  `maxScore` DECIMAL(4,2) NULL,
  `color` VARCHAR(45) NULL,
  PRIMARY KEY (`progressLabelId`))
ENGINE = InnoDB;

USE `LifeDashboard` ;

-- -----------------------------------------------------
-- Placeholder table for view `LifeDashboard`.`ProjectDisplay`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LifeDashboard`.`ProjectDisplay` (`projectId` INT, `projectName` INT, `dueDate` INT, `statusLabel` INT, `urgencyLabel` INT, `difficultyLabel` INT, `statusColor` INT, `urgencyColor` INT, `difficultyColor` INT, `semesterName` INT, `className` INT, `milestonesCompleted` INT, `milestonesTotal` INT, `progressRatio` INT);

-- -----------------------------------------------------
-- Placeholder table for view `LifeDashboard`.`milestoneDisplay`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LifeDashboard`.`milestoneDisplay` (`milestoneId` INT, `projectId` INT, `milestoneName` INT, `estimatedDays` INT, `expectedDueDate` INT, `statusLabel` INT, `urgencyLabel` INT, `difficultyLabel` INT, `statusColor` INT, `urgencyColor` INT, `difficultyColor` INT);

-- -----------------------------------------------------
-- procedure addProject
-- -----------------------------------------------------

DELIMITER $$
USE `LifeDashboard`$$
CREATE PROCEDURE `addProject` (
	IN pClassId INT,
	IN pProjectType INT,
	IN pName VARCHAR(45),
	IN pStartDate DATE,
	IN pDueDate DATE,
	IN pEstimatedDifficulty dec(4,2),
	IN pIsAvailable BOOL,
	IN pHasStartDate BOOL
)
BEGIN
	DECLARE daysLeft INT;
    DECLARE urgencyScore dec(4,2);
	INSERT INTO Projects(classId, projectType, name, startDate, dueDate, estimatedDifficulty, isAvailable, hasStartDate)
				VALUES (pClassId, pProjectType, pName, pStartDate, pDueDate, pEstimatedDifficulty, pIsAvailable, pHasStartDate);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `LifeDashboard`.`ProjectDisplay`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LifeDashboard`.`ProjectDisplay`;
USE `LifeDashboard`;
CREATE  OR REPLACE VIEW `ProjectDisplay` AS

SELECT
	-- Basic info
	p.projectId,
    p.name AS projectName,
    p.dueDate AS dueDate,
    sl.label AS statusLabel,
    
    -- Labels
	sl.label AS statusLabel,
    ul.label AS urgencyLabel,
    dl.label AS difficultyLabel,
    
    -- Colors
    sl.color AS statusColor,
    ul.color AS urgencyColor,
    dl.color AS difficultyColor,
    
    -- Class and Semester
    sem.name AS semesterName,
    c.name as className,
    

    -- Milestones Completed
    (
		SELECT COUNT(*)
        FROM ProjectMilestones pm2
        WHERE pm2.projectId = p.projectId
			AND pm2.ProgressScore = 1
    ) AS milestonesCompleted,
    
    -- Milestones total
    (
		SELECT COUNT(*)
        FROM ProjectMilestones pm3
        WHERE pm3.projectId = p.projectId
    ) AS milestonesTotal,
    
    -- Progress percentage
    (
    SELECT 
		-- Coalesce to return 0 instead of null if no milestones exist.
        COALESCE(
            (
                SELECT COUNT(*)
                FROM ProjectMilestones pm2
                WHERE pm2.projectId = p.projectId
                  AND pm2.progressScore = 1
            ) / NULLIF(
                (
                    SELECT COUNT(*)
                    FROM ProjectMilestones pm3
                    WHERE pm3.projectId = p.projectId
                ), 0
            )
        , 0)
) AS progressRatio
    
    
    
FROM Project p
-- Semester
JOIN Semesters sem 
	ON p.semesterId = sem.semesterId

-- Class
JOIN Classes c 
	ON p.classId = c.classId
    
-- Status
JOIN StatusLabels sl 
	ON p.status = sl.statusLabelId
    
-- Urgency
JOIN UrgencyLabels ul 
	ON p.urgencyScore BETWEEN ul.minScore AND ul.maxScore
    
-- Difficulty
JOIN DifficultyLabels dl 
	ON p.calculatedDifficultyScore BETWEEN dl.minScore AND dl.maxScore;

-- -----------------------------------------------------
-- View `LifeDashboard`.`milestoneDisplay`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LifeDashboard`.`milestoneDisplay`;
USE `LifeDashboard`;
CREATE  OR REPLACE VIEW `milestoneDisplay` AS

SELECT
	-- Basic info
	pm.projectMilestoneId as milestoneId,
    pm.projectId,
	pm.name AS milestoneName,
    
    -- Time-related
    pm.estimatedDays AS estimatedDays,
    pm.expectedDueDate AS expectedDueDate,
    
	-- Labels
	sl.label AS statusLabel,
    ul.label AS urgencyLabel,
    dl.label AS difficultyLabel,
    
    -- Colors
    sl.color AS statusColor,
    ul.color AS urgencyColor,
    dl.color AS difficultyColor
    
    
FROM projectMilestones pm
JOIN Projects p
	ON pm.projectId = p.projectId
JOIN Classes
	ON c.classId = p.classId
JOIN ProgressLabels pl
	ON pm.progressScore BETWEEN pl.minScore AND pl.maxScore
JOIN UrgencyLabels ul
	ON pm.urgencyScore BETWEEN ul.minScore AND ul.maxScore
JOIN StatusLabels sl
	ON pm.status = sl.statusLabelId;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `LifeDashboard`.`Semesters`
-- -----------------------------------------------------
START TRANSACTION;
USE `LifeDashboard`;
INSERT INTO `LifeDashboard`.`Semesters` (`semesterId`, `name`, `startDate`, `endDate`) VALUES (1, 'Fall 2025', '2025-08-02', '2025-12-20');
INSERT INTO `LifeDashboard`.`Semesters` (`semesterId`, `name`, `startDate`, `endDate`) VALUES (2, 'Winter 2026', '2026-01-10', '2026-05-10');

COMMIT;


-- -----------------------------------------------------
-- Data for table `LifeDashboard`.`UrgencyLabels`
-- -----------------------------------------------------
START TRANSACTION;
USE `LifeDashboard`;
INSERT INTO `LifeDashboard`.`UrgencyLabels` (`UrgencyLabelId`, `label`, `minScore`, `maxScore`, `color`) VALUES (1, 'Take your time', 0.00, 0.25, '\'#4CAF50\'');
INSERT INTO `LifeDashboard`.`UrgencyLabels` (`UrgencyLabelId`, `label`, `minScore`, `maxScore`, `color`) VALUES (2, 'Get started', 0.26, 0.50, '\'#FFC107\'');
INSERT INTO `LifeDashboard`.`UrgencyLabels` (`UrgencyLabelId`, `label`, `minScore`, `maxScore`, `color`) VALUES (3, 'Speed it up', 0.51, 0.75, '\'#FF9800\'');
INSERT INTO `LifeDashboard`.`UrgencyLabels` (`UrgencyLabelId`, `label`, `minScore`, `maxScore`, `color`) VALUES (4, 'Do right now', 0.76, 1.00, '\'#F44336\'');

COMMIT;


-- -----------------------------------------------------
-- Data for table `LifeDashboard`.`DifficultyLabels`
-- -----------------------------------------------------
START TRANSACTION;
USE `LifeDashboard`;
INSERT INTO `LifeDashboard`.`DifficultyLabels` (`difficultyLabelId`, `label`, `minScore`, `maxScore`, `color`) VALUES (1, 'Light work', 0, 0.2, '27D600');
INSERT INTO `LifeDashboard`.`DifficultyLabels` (`difficultyLabelId`, `label`, `minScore`, `maxScore`, `color`) VALUES (2, 'Ok it\'s got a little kick', 0.21, 0.4, '5DA600');
INSERT INTO `LifeDashboard`.`DifficultyLabels` (`difficultyLabelId`, `label`, `minScore`, `maxScore`, `color`) VALUES (3, 'Lucky you got vyvanse', 0.41, 0.6, '937600');
INSERT INTO `LifeDashboard`.`DifficultyLabels` (`difficultyLabelId`, `label`, `minScore`, `maxScore`, `color`) VALUES (4, 'Only way forward is unafraid and focused', 0.61, 0.8, 'C94500');
INSERT INTO `LifeDashboard`.`DifficultyLabels` (`difficultyLabelId`, `label`, `minScore`, `maxScore`, `color`) VALUES (5, 'No amount of sugar gon\' help with the taste', 0.81, 1, 'FF1500');

COMMIT;


-- -----------------------------------------------------
-- Data for table `LifeDashboard`.`StatusLabels`
-- -----------------------------------------------------
START TRANSACTION;
USE `LifeDashboard`;
INSERT INTO `LifeDashboard`.`StatusLabels` (`StatusLabelId`, `label`, `description`) VALUES (1, 'Not Started', NULL);
INSERT INTO `LifeDashboard`.`StatusLabels` (`StatusLabelId`, `label`, `description`) VALUES (2, 'In Progress', NULL);
INSERT INTO `LifeDashboard`.`StatusLabels` (`StatusLabelId`, `label`, `description`) VALUES (3, 'Completed', NULL);
INSERT INTO `LifeDashboard`.`StatusLabels` (`StatusLabelId`, `label`, `description`) VALUES (4, 'Late', NULL);
INSERT INTO `LifeDashboard`.`StatusLabels` (`StatusLabelId`, `label`, `description`) VALUES (5, 'Paused', NULL);
INSERT INTO `LifeDashboard`.`StatusLabels` (`StatusLabelId`, `label`, `description`) VALUES (6, 'Cancelled', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `LifeDashboard`.`progressLabels`
-- -----------------------------------------------------
START TRANSACTION;
USE `LifeDashboard`;
INSERT INTO `LifeDashboard`.`progressLabels` (`progressLabelId`, `label`, `minScore`, `maxScore`, `color`) VALUES (1, 'Not Started', 0, 0, NULL);
INSERT INTO `LifeDashboard`.`progressLabels` (`progressLabelId`, `label`, `minScore`, `maxScore`, `color`) VALUES (2, 'Just Started', 0.01, 0.2, NULL);
INSERT INTO `LifeDashboard`.`progressLabels` (`progressLabelId`, `label`, `minScore`, `maxScore`, `color`) VALUES (3, 'A bit worked on', 0.21, 0.40, NULL);
INSERT INTO `LifeDashboard`.`progressLabels` (`progressLabelId`, `label`, `minScore`, `maxScore`, `color`) VALUES (4, 'Halfway there', 0.41, 0.6, NULL);
INSERT INTO `LifeDashboard`.`progressLabels` (`progressLabelId`, `label`, `minScore`, `maxScore`, `color`) VALUES (5, 'Mostly done', 0.61, 0.8, NULL);
INSERT INTO `LifeDashboard`.`progressLabels` (`progressLabelId`, `label`, `minScore`, `maxScore`, `color`) VALUES (6, 'Almost done', 0.81, 0.99, NULL);
INSERT INTO `LifeDashboard`.`progressLabels` (`progressLabelId`, `label`, `minScore`, `maxScore`, `color`) VALUES (7, 'Completed', 1, 1, NULL);

COMMIT;

