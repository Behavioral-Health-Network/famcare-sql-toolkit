---
front-matter-title: BHN SAVEDQUERY Dependencies View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-bhn-savedquery-dependencies.sql
last_updated: 2026-02-04
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

# BHN SAVEDQUERY Dependencies View Definition

## Purpose

Identifies all SQL object dependencies referenced by Quick Reports saved queries to support governance, lineage mapping, and change‑impact analysis across BHN’s reporting ecosystem.

## Description

- Removes bracketed aliases, column labels, and other non‑object tokens bracketed aliases and labels
- Recursively identifies every `FROM` and `JOIN` clause, including those inside inline subqueries
- Extracts raw object references directly from saved query SQL
- Normalizes object names by removing database and schema prefixes (e.g., `BEHAVHEALT_LIVE.DBO.Q_CLIENT_BHN` to `Q_CLIENT_BHN`; `DBO.Q_EPICC_PATHCLIENT_ENROLLMENTS` to `Q_EPICC_PATHCLIENT_ENROLLMENTS`)
- Deduplicates dependencies per saved query
- Identifies and assigns values to `PROGRAM_SCOPE` and `PROGRAMS` in alignment with the documentation metadata model:
  - `PROGRAM_SCOPE` IN ('single', 'all', none')
  - `PROGRAMS` IN ('epicc', 'complex-care', 'epicc', 'ere', 'yere' 'none') or `PROGRAMS` = '' when `PROGRAM_SCOPE` = 'all'
- SQL Server 2014 compatible (no regex, no `STRING_SPLIT`, no JSON functions)

## Columns Returned

| Field                 | Description                                                                                                                    |
|-----------------------|--------------------------------------------------------------------------------------------------------------------------------|
| `ID`                  | Saved query ID                                                                                                                 |
| `QUERYNAME`           | Name of the saved Quick Report                                                                                                 |
| `USERID`              | Owner of the saved query                                                                                                       |
| `REFERENCED_OBJECT`   | Raw object reference extracted from SQL (may include db/schema prefixes)                                                       |
| `NORMALIZED_OBJECT`   | Clean object name for governance joins (schema/db removed)                                                                     |
| `PROGRAM_SCOPE`       | Classification describing whether an asset applies to one program, all programs, or no programs (administrative asset)         |
| `PROGRAMS`            | The program an asset belongs to, expressed as a normalized acronym                                                             |

## Maintenance Notes

- Inline subqueries may reference multiple objects; all are included.
- Alias leakage is prevented by recursive bracket stripping.
- Normalization uses `PARSENAME` to reliably extract the object name from 1‑, 2‑, or 3‑part identifiers.
- If SQL Server version is upgraded, consider replacing recursion with `STRING_SPLIT` + `CROSS APPLY` for performance and maintainability.
- Saved queries that wrap views (e.g., `SELECT * FROM Q_FOO_VIEW`) will only show the view name here; full lineage requires joining to SQL object dependency metadata.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

- **2026-02-04**: Adds columns `PROGRAM_SCOPE` and `PROGRAMS` to the final `SELECT`.
- **2026‑01‑27**: Adds initial definition. Adds initial Markdown documentation file for view definition.
<!---CHANGELOG-END--->
