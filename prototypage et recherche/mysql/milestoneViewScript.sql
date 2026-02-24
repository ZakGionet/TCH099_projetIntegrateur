CREATE VIEW `milestoneDisplay` AS

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
	ON pm.status = sl.statusLabelId