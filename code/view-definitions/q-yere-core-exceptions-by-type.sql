/*
View Name: Q_YERE_CORE_EXCEPTIONS_BY_TYPE  
Category: View Definitions  

See docs/view-definitions/q-yere-core-exceptions-by-type.md for full documentation.
*/

USE BEHAVHEALT_LIVE;
GO

-- ALTER VIEW dbo.Q_YERE_CORE_EXCEPTIONS_BY_TYPE AS
WITH [ENROLLMENTS] AS (
	SELECT *
	FROM BEHAVHEALT_LIVE.DBO.Q_YERE_PATHCLIENT_ENROLLMENTS
	WHERE PP_DOCSERNO IS NOT NULL
		AND ENROLLMENT_STARTING_DATE >= '2024-07-01'
),

[DUPLICATE_PATHWAY_FORM_PER_ENROLLMENT] AS (
	SELECT 
		E.CLIENT_NUMBER,
		E.PWY_EVENT,
		E.PWY_START_DATE,
		E.EVENT_START_DATE,
		E.PEC_PATHCLIENT_DOCSERNO,
		COUNT(*) AS [FORM_COUNT]
	FROM ENROLLMENTS AS [E]
	WHERE E.PE_DATE_ACCOMPLISHED IS NOT NULL
	GROUP BY 
		E.CLIENT_NUMBER,
		E.PWY_EVENT,
		E.PWY_START_DATE,
		E.EVENT_START_DATE,
		E.PEC_PATHCLIENT_DOCSERNO
	HAVING COUNT(*) > 1
),

[INVALID_PATHWAY_DATE] AS (
	SELECT E.*
	FROM ENROLLMENTS AS [E]
	WHERE E.PATHWAY_DATE IS NOT NULL
		AND NOT (
			E.PATHWAY_DATE BETWEEN E.EARLIEST_START_DATE AND E.LATEST_END_DATE
		)
),

[PATHWAY_DATE_OUTSIDE_EVENT_RANGE] AS (
	SELECT 
		E.CLIENT_NUMBER,
		E.PWY_EVENT
	FROM ENROLLMENTS AS [E]
	WHERE E.PATHWAY_DATE IS NOT NULL
	  AND (
		-- Case 1: Pathway has ended, but PATHWAY_DATE is out of bounds
		(PWY_END_DATE IS NOT NULL AND (
			E.PATHWAY_DATE < E.PWY_START_DATE 
			OR E.PATHWAY_DATE > E.PWY_END_DATE
		))
		
		-- Case 2: Pathway still active, fallback to event bounds
		OR (PWY_END_DATE IS NULL AND (
			E.PATHWAY_DATE < E.PWY_START_DATE 
			OR E.PATHWAY_DATE > E.LATEST_END_DATE
		))
	)
),

[PATHWAY_DATE_OUTSIDE_ENROLLMENT] AS (
	SELECT 
		E.CLIENT_NUMBER, 
		E.PWY_EVENT
	FROM ENROLLMENTS AS [E]
	WHERE E.PATHWAY_DATE IS NOT NULL
		AND E.PATHWAY_DATE NOT BETWEEN E.ENROLLMENT_STARTING_DATE 
		AND ISNULL(E.ENROLLMENT_ENDING_DATE, GETDATE())
),

[ETO_ENROLLMENTS_NOT_IMPORTED] AS (
	SELECT E.*
	FROM ENROLLMENTS AS [E]
	WHERE 
		E.ENROLLMENT_STARTING_DATE >= '2024-07-01'
			AND E.ENROLLMENT_ENDING_DATE <= '2024-12-31'
			AND E.PWY_EVENT = 'YERE Referral'
			AND E.PWY_FORMS_DOCSERNO IS NULL
			AND E.PE_DATE_ACCOMPLISHED IS NULL
),

[MISSING_REQUIRED_REFERRAL] AS (
-- Includes both active and dismissed enrollments missing referral forms;
-- dismissal reasons like 'Reconnect', 'Transfer To Compass', and 'Client 
-- Admitted To Residential Treatment' are now unified under the same 
-- remediation path.
	SELECT E.*
	FROM ENROLLMENTS AS [E]
	WHERE E.PWY_EVENT = 'YERE Referral'
	  AND E.PWY_FORMS_DOCSERNO IS NULL
	  AND NOT EXISTS (
		SELECT 1
		FROM ETO_ENROLLMENTS_NOT_IMPORTED AS [L]
		WHERE L.CLIENT_NUMBER = E.CLIENT_NUMBER
		  AND L.PWY_EVENT = E.PWY_EVENT
	)
),

[FILTERABLE_ENROLLMENTS] AS (
	SELECT DISTINCT 
		E.CLIENT_NUMBER, 
		E.PEC_PATHCLIENT_DOCSERNO,
		E.PWY_EVENT
	FROM ENROLLMENTS AS [E]
	WHERE 
	-- Case 1: Reconnect – Referral required
	(
		E.DISMISSAL_REASON_DESCRIPTION = 'Reconnect'
			AND E.PWY_EVENT IN (
				'YERE Referral'
				)
			AND E.PWY_FORMS_DOCSERNO IS NOT NULL
			)

	-- Case 2: 'Reconnect' - filter all non-Referral event rows.
		OR (
		E.DISMISSAL_REASON_DESCRIPTION = 'Reconnect'
			AND E.PWY_EVENT <> 'YERE Referral'
	)

	-- Case 2: 'Transfer To Compass' – Referral required
	OR (
		E.DISMISSAL_REASON_DESCRIPTION = 'Transfer To Compass'
			AND E.PWY_EVENT = 'YERE Referral'
			AND E.PWY_FORMS_DOCSERNO IS NOT NULL
	)

	-- Case 3: 'Client Admitted To Residential Treatment' – Referral required
	OR (
		E.DISMISSAL_REASON_DESCRIPTION = 'Client Admitted To Residential Treatment'
			AND E.PWY_EVENT = 'YERE Referral'
			AND E.PWY_FORMS_DOCSERNO IS NOT NULL
	)

	-- Case: 'Client Admitted To Residential Treatment' – filter all non-referral event rows
	OR (
		E.DISMISSAL_REASON_DESCRIPTION = 'Client Admitted To Residential Treatment'
			AND E.PWY_EVENT <> 'YERE Referral'
	)

	-- Case 4: 'Disengaged/Lost Contact After Engaging' – Referral present
	OR (
		E.DISMISSAL_REASON_DESCRIPTION = 'Disengaged/Lost Contact After Engaging'
			AND E.PWY_EVENT IN (
				'YERE Referral',
				'YERE Hospital Visit Note',
				'YERE Initial Assessment',
				'YERE 30 Day',
				'YERE 3 Month',
				'YERE 6 Month',
				'YERE Behavioral Health Services'
				)
			AND E.PWY_FORMS_DOCSERNO IS NOT NULL
	)

	-- Case: 'AnswerFirst Determined Ineligible' – Referral present
	OR (
		E.DISMISSAL_REASON_DESCRIPTION IN (
			'AnswerFirst Determined Ineligible',
			'No Longer Eligible'
		)
			AND E.PWY_EVENT = 'YERE Referral'
			AND E.PWY_FORMS_DOCSERNO IS NOT NULL
	)

	-- Case: 'AnswerFirst Determined Ineligible' - All other Pathway Event forms should be filtered after Referral
	OR (
		E.DISMISSAL_REASON_DESCRIPTION = 'AnswerFirst Determined Ineligible'
			AND E.PWY_EVENT IN (
				'YERE Hospital Visit Note',
				'YERE Initial Assessment',
				'YERE 30 Day',
				'YERE 3 Month',
				'YERE 6 Month',
				'YERE Behavioral Health Services'
			)
			AND E.PWY_FORMS_DOCSERNO IS NULL
			AND E.PATHWAY_DATE IS NULL
	)

	-- Case 4: 'Program Completion' dismissal with all forms required
	OR (
		E.DISMISSAL_REASON_DESCRIPTION = 'Program Completion'
			AND E.PWY_FORMS_DOCSERNO IS NOT NULL
	)

	-- Case 5: 'Administrative' dismissal reason - filter all PWY_EVENT rows for the enrollment except when Referral is missing
	OR(
		E.DISMISSAL_REASON_DESCRIPTION = 'Administrative'
			AND E.PWY_EVENT <> 'YERE Referral'
			AND E.PWY_FORMS_DOCSERNO IS NOT NULL
	)
	OR (
		E.DISMISSAL_REASON_DESCRIPTION = 'Administrative'
		AND (
			-- Filters when Referral present
			(
				E.PWY_EVENT = 'YERE Referral' 
					AND E.PWY_FORMS_DOCSERNO IS NOT NULL
					)
			-- Filters any other event form when an enrollment has this dismissal reason
			OR E.PWY_EVENT <> 'YERE Referral'
		)
	)

	-- Case 7: 'Unable To Locate' - filter Referral if present
	OR (
	E.DISMISSAL_REASON_DESCRIPTION = 'Unable To Locate'
		AND E.PWY_EVENT = 'YERE Referral'
		AND E.PWY_FORMS_DOCSERNO IS NOT NULL
)

	-- Case: 'Unable To Locate' – filter all events except Referral & Initial Assessment
	OR (
		E.DISMISSAL_REASON_DESCRIPTION = 'Unable To Locate/Make Contact Post-Referral'
			AND E.PWY_EVENT NOT IN (
				'YERE Referral',
				'YERE Initial Assessment'
				)
	)

	-- Case 6: 'Unable To Locate/Make Contact Post-Referral' dismissal – filter Referral and IA if present
	OR (
		E.DISMISSAL_REASON_DESCRIPTION = 'Unable To Locate/Make Contact Post-Referral'
			AND E.PWY_EVENT IN (
				'YERE Referral',
				'YERE Initial Assessment'
				)
			AND E.PWY_FORMS_DOCSERNO IS NOT NULL
	)

	-- Case 7: 'Caregiver Declined Services Post-Referral' dismissal – filter Referral and IA if present
	OR (
		E.DISMISSAL_REASON_DESCRIPTION = 'Caregiver Declined Services Post-Referral'
			AND E.PWY_EVENT IN (
				'YERE Referral', 
				'YERE Initial Assessment'
				)
			AND E.PWY_FORMS_DOCSERNO IS NOT NULL
	)

	-- Case 8: 'Caregiver Declined Services' - Referral is present
	OR (
	E.DISMISSAL_REASON_DESCRIPTION = 'Caregiver Declined Services'
		AND E.PWY_EVENT = 'YERE Referral'
		AND E.PWY_FORMS_DOCSERNO IS NOT NULL
)

	-- Case 8: Active enrollment with completed forms - filter out the rows with forms that 
	--	were completed as indicated by E.PWY_FORMS_DOCSERNO IS NOT NULL.
	OR (
		E.DISMISSAL_REASON_DESCRIPTION IS NULL
			AND E.PWY_EVENT IN (
				'YERE Referral',
				'YERE Hospital Visit Note',
				'YERE Initial Assessment', 
				'YERE 30 Day', 
				'YERE 3 Month', 
				'YERE 6 Month', 
				'YERE Behavioral Health Services'
				)
			AND E.PWY_FORMS_DOCSERNO IS NOT NULL
	)

	-- Case: ETO enrollment flagged for manual referral entry – exclude non-referral forms
	OR (
		E.ENROLLMENT_STARTING_DATE >= '2024-07-01'
		AND E.ENROLLMENT_ENDING_DATE <= '2024-12-31'
		AND E.PWY_EVENT <> 'YERE Referral'
		AND NOT EXISTS (
			SELECT 1
			FROM ENROLLMENTS AS [E2]
			WHERE E2.CLIENT_NUMBER = E.CLIENT_NUMBER
			  AND E2.PWY_EVENT = 'YERE Referral'
			  AND E2.PWY_FORMS_DOCSERNO IS NOT NULL
		)
	)

-- Future cases to be added here as OR blocks
),

[TAGGED_EXCEPTIONS_RAW] AS (
	SELECT 
		E.CLIENT_NUMBER,
		E.PWY_EVENT,
		'Missing Required Referral Form' AS [EXCEPTION_TYPE],
		1 AS [PRIORITY]
	FROM MISSING_REQUIRED_REFERRAL AS [E]

	UNION ALL

	SELECT 
		E.CLIENT_NUMBER,
		E.PWY_EVENT,
		'ETO Referrals Not Imported - Manual Entry Needed' AS [EXCEPTION_TYPE],
		2 AS [PRIORITY]
	FROM ETO_ENROLLMENTS_NOT_IMPORTED AS [E]

	UNION ALL

	SELECT 
		E.CLIENT_NUMBER,
		E.PWY_EVENT,
		'Invalid Pathway Date - Outside Event Range' AS [EXCEPTION_TYPE],
		3 AS [PRIORITY]
	FROM INVALID_PATHWAY_DATE AS [E]

	UNION ALL

	SELECT 
		E.CLIENT_NUMBER,
		E.PWY_EVENT,
		'Duplicate Form Entry - Review Required' AS [EXCEPTION_TYPE],
		4 AS [PRIORITY]
	FROM DUPLICATE_PATHWAY_FORM_PER_ENROLLMENT AS [E]
),

[TAGGED_EXCEPTIONS] AS (
	SELECT 
		CLIENT_NUMBER,
		PWY_EVENT,
		EXCEPTION_TYPE
	FROM (
		SELECT 
			CLIENT_NUMBER,
			PWY_EVENT,
			EXCEPTION_TYPE,
			ROW_NUMBER() OVER (
				PARTITION BY CLIENT_NUMBER, PWY_EVENT 
				ORDER BY PRIORITY
			) AS [RN]
		FROM TAGGED_EXCEPTIONS_RAW
	) AS [Ranked]
	WHERE RN = 1
)

SELECT 
	E.CLIENT_NUMBER,
	E.CLIENT_LAST,
	E.CLIENT_FIRST,
	E.PWY_EVENT,
	ISNULL(TE.EXCEPTION_TYPE, 'Uncategorized Exception') AS [EXCEPTION_TYPE],
	E.DISMISSAL_REASON_DESCRIPTION,
	E.PATHWAY_DATE,
	E.PE_DATE_ACCOMPLISHED,
	E.PWY_FORMS_DOCSERNO,
	E.PP_DOCSERNO,
	E.PC_DOCSERNO,
	E.PEC_PATHCLIENT_DOCSERNO,
	E.PWY_START_DATE,
	E.PWY_END_DATE,
	E.ENROLLMENT_STARTING_DATE,
	E.ENROLLMENT_ENDING_DATE,
	E.EARLIEST_START_DATE,
	E.EVENT_START_DATE,
	E.EVENT_END_DATE,
	E.LATEST_END_DATE,
	E.DAYS_UNTIL_FORM_DUE,
	E.PEC_USERID,
 	ISNULL(DPFE.FORM_COUNT, 1) AS [DUPLICATE_FORM_COUNT],
	CASE 
		WHEN PDOEVNT.CLIENT_NUMBER IS NOT NULL 
		THEN 1 
		ELSE 0 
	END AS [PATHWAY_DATE_OUTSIDE_EVENT_RANGE],
	CASE 
		WHEN PDOENRL.CLIENT_NUMBER IS NOT NULL 
		THEN 1 
		ELSE 0 
	END AS [PATHWAY_DATE_OUTSIDE_ENROLLMENT]
FROM ENROLLMENTS AS [E]
LEFT JOIN TAGGED_EXCEPTIONS AS [TE] 
	ON E.CLIENT_NUMBER = TE.CLIENT_NUMBER 
	AND E.PWY_EVENT = TE.PWY_EVENT
LEFT JOIN DUPLICATE_PATHWAY_FORM_PER_ENROLLMENT AS [DPFE]
	ON E.CLIENT_NUMBER = DPFE.CLIENT_NUMBER
	AND E.PWY_EVENT = DPFE.PWY_EVENT
	AND E.PWY_START_DATE = DPFE.PWY_START_DATE
	AND E.EVENT_START_DATE = DPFE.EVENT_START_DATE
	AND E.PEC_PATHCLIENT_DOCSERNO = DPFE.PEC_PATHCLIENT_DOCSERNO
LEFT JOIN PATHWAY_DATE_OUTSIDE_EVENT_RANGE AS [PDOEVNT]
	ON E.CLIENT_NUMBER = PDOEVNT.CLIENT_NUMBER 
	AND E.PWY_EVENT = PDOEVNT.PWY_EVENT
LEFT JOIN PATHWAY_DATE_OUTSIDE_ENROLLMENT AS [PDOENRL]
	ON E.CLIENT_NUMBER = PDOENRL.CLIENT_NUMBER 
	AND E.PWY_EVENT = PDOENRL.PWY_EVENT
WHERE NOT(
	EXCEPTION_TYPE = 'Dismissed Without Referral Form'
		AND E.PWY_EVENT <> 'YERE Referral'
	)
	AND NOT EXISTS (
		SELECT 1
		FROM FILTERABLE_ENROLLMENTS AS [F]
		WHERE F.CLIENT_NUMBER = E.CLIENT_NUMBER
			AND F.PEC_PATHCLIENT_DOCSERNO = E.PEC_PATHCLIENT_DOCSERNO
			AND F.PWY_EVENT = E.PWY_EVENT
	)
	AND EXCEPTION_TYPE LIKE ('ETO%');