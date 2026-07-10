/*
View Name: Q_BHN_SAVEDQUERY_DEPENDENCIES
Category: View Definitions

See docs/view-definitions/q-bhn-savedquery-dependencies.md for full documentation.
*/

USE BEHAVHEALT_LIVE;
GO

--ALTER VIEW dbo.Q_BHN_SAVEDQUERY_DEPENDENCIES AS
WITH [FILTERED] AS (
	SELECT
		ID,
		QUERYNAME,
		USERID,
		cleaned_sql = LTRIM(RTRIM(
			REPLACE(REPLACE(CAST(QuerySQL AS varchar(max)), CHAR(10), ' '), CHAR(13), ' ')
		))
	FROM SAVEDQUERIES
	WHERE
		QUERYNAME LIKE '[[]Exception Reports]%' OR
		QUERYNAME LIKE '[[]Compliance Reports]%' OR
		QUERYNAME LIKE '[[]Program Management]%' OR
		QUERYNAME LIKE '[[]R Child Doc Extracts]%'
),
[STRIP_BRACKETS] AS (
	SELECT
		ID,
		QUERYNAME,
		USERID,
		working_sql = cleaned_sql
	FROM FILTERED

	UNION ALL

	SELECT
		ID,
		QUERYNAME,
		USERID,
		working_sql = STUFF(
			working_sql,
			CHARINDEX('[', working_sql),
			CHARINDEX(']', working_sql + ']', CHARINDEX('[', working_sql))
				- CHARINDEX('[', working_sql) + 1,
			''
		)
	FROM STRIP_BRACKETS
	WHERE working_sql LIKE '%[[]%]%'
),
[NO_BRACKETS] AS (
	SELECT
		ID,
		QUERYNAME,
		USERID,
		cleaned_sql = LTRIM(RTRIM(working_sql))
	FROM STRIP_BRACKETS
	WHERE working_sql NOT LIKE '%[[]%]%'
),
[KEYWORDS] AS (
	SELECT
		ID,
		QUERYNAME,
		USERID,
		cleaned_sql,
		keyword =
			CASE 
				WHEN fpos = 0 THEN 'JOIN'
				WHEN jpos = 0 THEN 'FROM'
				WHEN fpos < jpos THEN 'FROM'
				ELSE 'JOIN'
			END,
		start_pos =
			CASE 
				WHEN fpos = 0 THEN jpos
				WHEN jpos = 0 THEN fpos
				WHEN fpos < jpos THEN fpos
				ELSE jpos
			END
	FROM (
		SELECT
			ID,
			QUERYNAME,
			USERID,
			cleaned_sql,
			fpos = CHARINDEX('FROM ', cleaned_sql),
			jpos = CHARINDEX('JOIN ', cleaned_sql)
		FROM NO_BRACKETS
	) x
	WHERE fpos > 0 OR jpos > 0

	UNION ALL

	SELECT
		ID,
		QUERYNAME,
		USERID,
		cleaned_sql,
		keyword =
			CASE 
				WHEN next_fpos = 0 THEN 'JOIN'
				WHEN next_jpos = 0 THEN 'FROM'
				WHEN next_fpos < next_jpos THEN 'FROM'
				ELSE 'JOIN'
			END,
		start_pos =
			CASE 
				WHEN next_fpos = 0 THEN next_jpos
				WHEN next_jpos = 0 THEN next_fpos
				WHEN next_fpos < next_jpos THEN next_fpos
				ELSE next_jpos
			END
	FROM (
		SELECT
			ID,
			QUERYNAME,
			USERID,
			cleaned_sql,
			start_pos,
			next_fpos = CHARINDEX('FROM ', cleaned_sql, start_pos + 1),
			next_jpos = CHARINDEX('JOIN ', cleaned_sql, start_pos + 1)
		FROM KEYWORDS
	) y
	WHERE next_fpos > 0 OR next_jpos > 0
),
[EXTRACTED] AS (
	SELECT
		ID,
		QUERYNAME,
		USERID,
		keyword,
		object_raw =
			LTRIM(RTRIM(
				SUBSTRING(
					cleaned_sql,
					start_pos + LEN(keyword) + 1,
					CHARINDEX(' ', cleaned_sql + ' ', start_pos + LEN(keyword) + 1)
						- (start_pos + LEN(keyword) + 1)
				)
			))
	FROM KEYWORDS
),
[CLEANED] AS (
	SELECT
		ID,
		QUERYNAME,
		USERID,
		referenced_object =
			LTRIM(RTRIM(
				REPLACE(REPLACE(REPLACE(REPLACE(object_raw, ';', ''), ',', ''), CHAR(9), ''), CHAR(13), '')
			)),
		cleaned_obj =
			LTRIM(RTRIM(
				REPLACE(REPLACE(REPLACE(REPLACE(object_raw, '[', ''), ']', ''), ';', ''), ',','')
			))
	FROM EXTRACTED
	WHERE object_raw NOT LIKE '(%'
	  AND LTRIM(RTRIM(
			REPLACE(REPLACE(REPLACE(REPLACE(object_raw, ';', ''), ',', ''), CHAR(9), ''), CHAR(13), '')
		  )) <> ''
)
SELECT DISTINCT
	ID,
	QUERYNAME,
	USERID,
	REFERENCED_OBJECT,
	NORMALIZED_OBJECT = PARSENAME(CLEANED_OBJ, 1),
	CASE
		WHEN QUERYNAME LIKE '%EPICC%' THEN 'single'
		WHEN QUERYNAME LIKE '%YERE%' THEN 'single'
		WHEN QUERYNAME LIKE '%COMPLEX CARE%' THEN 'single'
		WHEN QUERYNAME LIKE '%BCR%' THEN 'single'
		WHEN QUERYNAME LIKE '%ERE%' THEN 'single'
		WHEN QUERYNAME LIKE '%LINCS%' THEN 'single'
		-- If no program acronym appears, it is an all-program asset
		ELSE 'all'
	END AS [PROGRAM_SCOPE],
	CASE
		WHEN QUERYNAME LIKE '%EPICC%' THEN 'epicc'
		WHEN QUERYNAME LIKE '%YERE%' THEN 'yere'
		WHEN QUERYNAME LIKE '%COMPLEX CARE%' THEN 'complex-care'
		WHEN QUERYNAME LIKE '%BCR%' THEN 'bcr'
		WHEN QUERYNAME LIKE '%ERE%' THEN 'ere'
		WHEN QUERYNAME LIKE '%LINCS%' THEN 'lincs'
		-- If program_scope = all, programs must be empty
		ELSE ''
	END AS [PROGRAMS]

FROM CLEANED;
GO