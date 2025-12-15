---
front-matter-title: Q_DUPLICATE_ENROLLMENTS_WITH_PROGRAM
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-duplicate-enrollments-with-program.sql
last_updated: 2025-08-07
author: Bradley Wing
status: active
lifecycle: production
program_scope: multi
programs:
  - bcr
  - complex-care
  - epicc
  - ere
  - yere
tags:
  - exception-logic
  - multi-join
dependencies:
  - value1
  - value2
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# Q_DUPLICATE_ENROLLMENTS_WITH_PROGRAM

## Purpose

Surfaces cases where a client has multiple enrollments with the same `ENROLLMENT_STARTING_DATE`, indicating potential duplication. Includes program context and enrollment metadata to support audit and remediation.

## Description

- Source table: `Q_PROVIDERPLACEMENT_BHN`
- Identifies duplicate enrollment groups by grouping on `CLIENT_NUMBER` and `ENROLLMENT_STARTING_DATE` in `Q_PROVIDERPLACEMENT_BHN`
- Filters to groups with `COUNT(*) > 1`
- Joins back to the source table to return full enrollment records for affected clients
- Flags each record with `'Duplicate Start Date'` in the `ENROLLMENT_ISSUE` column
- Intended for internal audit and data quality review  
- Can be extended to include dismissal logic or additional program metadata if needed

## Columns Returned

| Field                        | Description                                     |
|-----------------------------|-------------------------------------------------|
| `CLIENT_NUMBER`         | Unique client identifier                         |
| `ENROLLMENT_STARTING_DATE` | Start date of the duplicated enrollment       |
| `PROGRAM_DESCRIPTION`   | Name of the program associated with the enrollment |
| `ENROLLMENT_DOCSERNO`   | Document serial number for the enrollment form   |
| `USERID`                | User who submitted the enrollment                |
| `ENROLLMENT_ISSUE`      | Hardcoded label: `'Duplicate Start Date'`        |

## Maintenance Notes

- Source logic depends on `Q_PROVIDERPLACEMENT_BHN`; changes to that view may affect results.
- May surface legitimate duplicates (e.g. multiple programs starting on same day); review context before remediation  

## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

</details>

<details markdown="1">
  <summary><strong>2025</strong></summary>

### 2025

- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation.  
- **2025-08-07**: Adds initial view definition.

</details>
</details>
