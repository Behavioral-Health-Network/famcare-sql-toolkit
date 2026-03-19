---
front-matter-title: BHN All Dependencies View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-bhn-all-dependencies.sql
last_updated: 2026-03-17
author: Bradley Wing
status: active
lifecycle: production
program_scope: none
programs:
  - none
tags:
  - view-layer
dependencies:
  - value1
  - value2
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# BHN All Dependencies View Definition

## Purpose

Provides a unified, normalized dependency list by combining SQL object dependencies and saved query dependencies into a single governance‑ready dataset. This view serves as the foundational layer for recursive lineage expansion and change‑impact analysis.

## Description

- Combines dependencies from:
  - `Q_BHN_SAVEDQUERY_DEPENDENCIES` (Quick Reports saved queries)
  - `Q_BHN_VIEW_AND_TABLE_DEPENDENCIES` (BHN SQL views and curated vendor tables)
- Normalizes object names to ensure consistent joins across lineage layers
- Assigns a `source_type` to distinguish between SQL objects and saved queries
- Ensures all dependencies begin at lineage level `1`
- Produces a clean, deduplicated dependency map suitable for recursive traversal
- SQL Server 2014 compatible

## Columns Returned

| Field               | Description                                                                                                                    |
|---------------------|--------------------------------------------------------------------------------------------------------------------------------|
| `SOURCE_TYPE`       | Type of asset (`SAVEDQUERY` or `SQL_OBJECT`)                                                                                   |
| `SOURCE_NAME`       | Name of the saved query or SQL object                                                                                          |
| `SOURCE_ID`         | Saved query ID (NULL for SQL objects)                                                                                          |
| `REFERENCED_OBJECT` | Raw referenced object name (may include schema/db prefixes)                                                                    |
| `NORMALIZED_OBJECT` | Clean object name for governance joins (schema/db removed)                                                                     |
| `LINEAGE_LEVEL`     | Initial lineage depth (always '1' in this view)                                                                                |
| `PROGRAM_SCOPE`     | Classification describing whether an asset applies to one program, all programs, or no programs (administrative asset)         |
| `PROGRAMS`          | The program an asset belongs to, expressed as a normalized acronym                                                             |

## Maintenance Notes

- This view does **not** perform recursive expansion; it only unifies direct dependencies.
- Program metadata (`PROGRAM_SCOPE`, `PROGRAMS`) is inherited from the source views.
- Downstream lineage expansion is performed by `Q_BHN_FULL_DEPENDENCY_LINEAGE`.
- If additional dependency sources are added in the future (e.g., stored procedures), they should be unioned here.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

- **2026‑02‑04**: Adds initial program metadata (`PROGRAM_SCOPE` and `PROGRAMS`) inheritance from source views. Adds initial Markdown documentation file.
- **2026‑01‑28**: Adds initial definition of unified dependency view.
<!---CHANGELOG-END--->
