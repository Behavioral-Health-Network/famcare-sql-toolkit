/*
View Name: Q_BHN_FULL_DEPENDENCY_LINEAGE
Category: View Definitions

See docs/view-definitions/q-bhn-full-dependency-lineage.md for full documentation.
*/

USE BEHAVHEALT_LIVE;
GO

/* 
-----------------------------------------------------------------------------------------
ROOT VS. HOP EXPLANATION
-----------------------------------------------------------------------------------------
root_* columns identify the original asset whose lineage is being traced. These values 
are fixed for the entire recursive chain. For example, if a saved query depends on a 
view, which depends on another view, which depends on a table, the root_* columns always 
refer to the saved query.

hop_* columns identify the asset at the current step ("hop") in the lineage traversal. 
At lineage_level = 1 (the anchor query), the hop is the same as the root because no 
traversal has occurred yet. This is intentional and required for recursion: the first 
join must match the root object to its direct dependencies.

As recursion proceeds, hop_* changes at each level to reflect the dependency being 
followed, while root_* remains constant. This allows the lineage view to represent 
complete dependency chains while preserving the identity of the original asset.
-----------------------------------------------------------------------------------------
*/

ALTER VIEW dbo.Q_BHN_FULL_DEPENDENCY_LINEAGE AS
WITH [RECURSIVE_DEPS] AS (
	-- Level 1: direct dependencies from unified view

/* 
ANCHOR QUERY NOTES
------------------
At lineage_level = 1, root_* and hop_* are intentionally identical. The root_* fields 
identify the original asset whose lineage is being expanded. The hop_* fields identify 
the object whose dependencies will be followed next. At the first level, the traversal 
has not yet moved, so the hop is the root.

This alignment is required for the recursive join:
    d.source_name = r.normalized_object

If hop_* were NULL or different at level 1, recursion would fail to locate the first 
dependency hop.
*/

	SELECT
		ROOT_SOURCE_TYPE  = D.SOURCE_TYPE,
		ROOT_SOURCE_NAME  = D.SOURCE_NAME,
		ROOT_SOURCE_ID    = D.SOURCE_ID,
		ROOT_PROGRAM_SCOPE = D.PROGRAM_SCOPE,
		ROOT_PROGRAMS     = D.PROGRAMS,

		HOP_SOURCE_TYPE   = D.SOURCE_TYPE,
		HOP_SOURCE_NAME   = D.SOURCE_NAME,
		HOP_PROGRAM_SCOPE = D.PROGRAM_SCOPE,
		HOP_PROGRAMS      = D.PROGRAMS,
		REFERENCED_OBJECT = D.REFERENCED_OBJECT,
		NORMALIZED_OBJECT = D.NORMALIZED_OBJECT,

		LINEAGE_LEVEL     = 1
	FROM dbo.Q_BHN_ALL_DEPENDENCIES AS [D]

	UNION ALL

	-- Deeper levels: follow SQL_OBJECT dependencies

/* 
RECURSIVE STEP NOTES
--------------------
Each recursive step advances the hop_* fields to the dependency identified at the 
previous level. The root_* fields remain unchanged, preserving the identity of the 
original asset throughout the lineage chain.

Recursion continues until:
  - no further SQL_OBJECT dependencies exist, or
  - lineage_level reaches the safety cap (10).
*/

	SELECT
		R.ROOT_SOURCE_TYPE,
		R.ROOT_SOURCE_NAME,
		R.ROOT_SOURCE_ID,
		R.ROOT_PROGRAM_SCOPE,
		R.ROOT_PROGRAMS,

		HOP_SOURCE_TYPE   = D.SOURCE_TYPE,
		HOP_SOURCE_NAME   = D.SOURCE_NAME,
		HOP_PROGRAM_SCOPE = D.PROGRAM_SCOPE,
		HOP_PROGRAMS      = D.PROGRAMS,

		REFERENCED_OBJECT = D.REFERENCED_OBJECT,
		NORMALIZED_OBJECT = D.NORMALIZED_OBJECT,

		LINEAGE_LEVEL     = R.LINEAGE_LEVEL + 1
	FROM RECURSIVE_DEPS AS [R]
	JOIN dbo.Q_BHN_ALL_DEPENDENCIES AS [D]
		ON D.source_type = 'SQL_OBJECT'
	   AND D.source_name = R.NORMALIZED_OBJECT
	WHERE R.LINEAGE_LEVEL < 10  -- safety cap
)
SELECT
	ROOT_SOURCE_TYPE,
	ROOT_SOURCE_NAME,
	ROOT_SOURCE_ID,
	ROOT_PROGRAM_SCOPE,
	ROOT_PROGRAMS,
	HOP_SOURCE_TYPE,
	HOP_SOURCE_NAME,
	HOP_PROGRAM_SCOPE,
	HOP_PROGRAMS,
	REFERENCED_OBJECT,
	NORMALIZED_OBJECT,
	LINEAGE_LEVEL,
	CASE 
		WHEN ROOT_SOURCE_TYPE = 'SQL_OBJECT'
		THEN 'SQL_' + LEFT(CONVERT(varchar(40), HASHBYTES('SHA1', NORMALIZED_OBJECT), 2), 8)
		WHEN ROOT_SOURCE_TYPE = 'SAVEDQUERY'
		THEN 'REP_' + LEFT(CONVERT(varchar(40), HASHBYTES('SHA1', ROOT_SOURCE_NAME), 2), 8)
		-- Optional future support for documentation assets
		-- WHEN ROOT_SOURCE_TYPE = 'DOCUMENTATION'
		-- THEN 'DOC_' + LEFT(CONVERT(varchar(40), HASHBYTES('SHA1', NORMALIZED_OBJECT), 2), 8)
	END AS [DEPENDENCY_CODE]
FROM RECURSIVE_DEPS;
GO
