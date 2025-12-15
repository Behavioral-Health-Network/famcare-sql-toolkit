---
front-matter-title: Q_CLIENTS_WITH_MULTIPLE_ACTIVE_PATHWAYS
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-clients-with-multiple-active-pathways.sql
last_updated: 2025-08-09
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

# Q_CLIENTS_WITH_MULTIPLE_ACTIVE_PATHWAYS

## Purpose

Identifies clients with more than one active Pathway enrollment at the same time. Supports exception reporting and program monitoring by surfacing potential duplication or misalignment in Pathway assignments.

## Description

- Built on `PATHWAY`, `PATHWAYCLIENT`, and `Q_PROVIDERPLACEMENT`, joined with `Q_CLIENT_BHN` for client metadata and test client exclusion.
- Filters to include only active Pathway records (`ENDDATE IS NULL`, `DOCREVNO = ' 0 '`).
- Uses a window function to count active Pathways per client.
- Returns one row per active Pathway for clients with more than one.

### Logic Summary

- **Client Join**
  - Uses `Q_CLIENT_BHN` to exclude test clients based on last name variants.

- **Active Pathway Filter**
  - Includes only records where `ENDDATE IS NULL` and `DOCREVNO = ' 0 '`.

- **Window Function**
  - `COUNT(CLIENT_NUMBER) OVER (PARTITION BY CLIENT_NUMBER)` calculates the number of active Pathways per client.

- **Final Filter**
  - `WHERE COUNT_PATHWAY > 1` restricts output to clients with multiple concurrent Pathways.

## Output Fields

| Field Name             | Description |
|------------------------|-------------|
| `CLIENT_NAME`, `CLIENT_NUMBER` | Client identifiers |
| `WHODUNIT`             | User ID who entered the Pathway |
| `PP DOCSERNO`          | `PROVIDERPLACEMENT` document reference |
| `PROGRAM_CODE`, `PROGRAM_DESCRIPTION` | Program assignment |
| `AGENCY_CODE`, `AGENCY_DESCRIPTION`   | Agency assignment |
| `PATHWAYNAME`          | Name of the Pathway |
| `COUNT_PATHWAY`        | Number of active Pathways for the client |

## Usage Notes

- **Ad Hoc Compatibility**: Designed as a view to support tools that do not allow CTEs.
- **Security Group Access**: Available to GVT and System Administrator groups.
- **Review Frequency**: Recommended periodic review to ensure business rules and filters remain aligned.

## Maintenance Notes

- **Test Client Filtering**: Based on last name variants in `Q_CLIENT_BHN`; update if naming conventions change.
- **Join Integrity**: Ensure `PATHWAY`, `PATHWAYCLIENT`, and `Q_PROVIDERPLACEMENT` remain structurally aligned.
- **Window Function Behavior**: Confirm that `COUNT_PATHWAY` reflects only active records.

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
- **2025-06-24**: Adds initial view definition to support exception reporting for concurrent pathway enrollments.

</details>
</details>
