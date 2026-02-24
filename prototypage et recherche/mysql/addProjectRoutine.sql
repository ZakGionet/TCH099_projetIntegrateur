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
END