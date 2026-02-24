CREATE VIEW `ProjectDisplay` AS

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
	ON p.calculatedDifficultyScore BETWEEN dl.minScore AND dl.maxScore