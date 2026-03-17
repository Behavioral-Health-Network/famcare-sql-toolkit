---
front-matter-title: BHN Full Dependency Lineage View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-bhn-full-dependency-lineage.sql
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

# BHN Full Dependency Lineage View Definition

## Purpose

Expands direct dependencies into full recursive lineage chains to support change‑impact analysis, dependency visualization, and governance workflows across BHN’s reporting and SQL ecosystems.

## Description

- Performs recursive traversal of dependencies defined in `Q_BHN_ALL_DEPENDENCIES`
- Expands lineage up to 10 levels deep (safety cap)
- Tracks both:
  - **root source** (the original saved query or SQL object)
  - **hop source** (the object at each step in the lineage chain)
- Normalizes object names to ensure consistent joins
- Includes program metadata inherited from source views
- SQL Server 2014 compatible (uses recursive CTEs)

## Columns Returned

| Field               | Description                                                                                                                    |
|---------------------|--------------------------------------------------------------------------------------------------------------------------------|
| `ROOT_SOURCE_TYPE`  | Type of the original asset (`SAVEDQUERY` or `SQL_OBJECT`)                                                                      |
| `ROOT_SOURCE_NAME`  | Name of the original saved query or SQL object                                                                                 |
| `ROOT_SOURCE_ID`    | Saved query ID (NULL for SQL objects)                                                                                          |
| `HOP_SOURCE_TYPE`   | Type of the dependency at the current hop                                                                                      |
| `HOP_SOURCE_NAME`   | Name of the dependency at the current hop                                                                                      |
| `REFERENCED_OBJECT` | Raw referenced object name                                                                                                     |
| `NORMALIZED_OBJECT` | Clean object name for governance joins                                                                                         |
| `LINEAGE_LEVEL`     | Depth of the dependency chain (1 = direct dependency)                                                                          |
| `PROGRAM_SCOPE`     | Classification describing whether an asset applies to one program, all programs, or no programs (administrative asset)         |
| `PROGRAMS`          | The program an asset belongs to, expressed as a normalized acronym                                                             |

## Lineage Behavior

- Level 1 dependencies come directly from `Q_BHN_ALL_DEPENDENCIES`
- Deeper levels follow only `SQL_OBJECT` dependencies
- Saved queries do **not** recursively expand into other saved queries
- Recursion stops when:
  - No further dependencies exist, or
  - The lineage depth reaches 10 (safety cap)

### Root vs. Hop Semantics

The lineage model distinguishes between **root** and **hop** fields to represent both the
origin of a dependency chain and the current position within that chain.

- **root\_** fields identify the original asset whose lineage is being traced. These values remain constant for the entire recursive expansion.
- **hop\_** fields identify the asset at the current step (“hop”) in the lineage traversal. At lineage level 1, the hop is intentionally the same as the root because no traversal has occurred yet. This alignment is required for the recursive join to locate the first dependency.

As recursion proceeds, **hop\_** fields change at each level to reflect the dependency being followed, while **root\_** fields remain fixed. This structure allows the view to represent complete dependency chains while preserving the identity of the original asset.

## Maintenance Notes

- Program metadata is inherited from the source views and can be joined externally if needed.
- Recursive expansion relies on normalized object names; ensure upstream normalization remains consistent.
- If SQL Server version is upgraded, consider using `sys.dm_sql_referenced_entities` for richer dependency metadata.
- This view is the authoritative source for dependency lineage used in change‑scope filtering and governance dashboards.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

- **2026‑02‑04**: Adds initial Markdown documentation file documentation. Confirms compatibility with program metadata model.
- **2026‑01‑28**: Adds initial definition of recursive lineage view.
<!---CHANGELOG-END--->
