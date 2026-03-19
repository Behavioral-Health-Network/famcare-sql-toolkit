---
front-matter-title: Placement Program Worker History View Definition
category: view-definitions
category-label: View Definitions
source_file: code/view-definitions/q-placement-program-worker-history.sql
last_updated: 2026-03-18
status: active
lifecycle: production
tags:
  - program-worker-history
program-scope: all
programs:
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# Placement Program Worker History View Definition

## Purpose

Supports program management reporting by extracting program worker assignment and transfer history for specific enrollments. Filters out test clients and non-current records.

## Description

- Pulls structured data from the `PLACEMENTPROGRAMWORKERHISTORY` form.
- Joins with `Q_CLIENT_BHN` for client metadata and test client exclusion.
- Enriches change reason codes with descriptions via `CHANGEREASON_BASE`.

### Logic Summary

- **Source Table:**
  - `PLACEMENTPROGRAMWORKERHISTORY` (aliased as `WORKER_HISTORY`)

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client metadata and test client exclusion
  - `LEFT JOIN CLOSINGREASONS_BASE` for program worker change reason code descriptions

- **Key Filters:**
  - `DOCREVNO = ' 0 '` to isolate current records

- **Output Fields:**
  - Follow-up metadata: `VISITDT`, `USERID`, `PARENT_DOCSERNO`
  - Enrollment: `PP.DOCSERNO` (ALIASED AS `PP_DOCSERNO`)`ENROLLMENT_STARTING_DATE`, `ENROLLMENT_ENDING_DATE`
  - Program Worker History: `PROGRAM_WORKER_CODE`, `PROGRAM_WORKER_LAST`, `PROGRAM_WORKER_FIRST`, `BEGIN_DATE`, `END_DATE`
  - Change Reason: `CHANGE_REASON_CODE`, `CHANGE_REASON_DESCRIPTION`

## Maintenance Notes

- Monitor for changes in change reason codes and update descriptions accordingly.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

- **2026-03-18**: Renames `PARENTDOCSERNO` to `PARENT_DOCSERNO`.

</details>

<details markdown="1">
  <summary><strong>2025</strong></summary>

### 2025

- **2025-09-18**: Adds initial view definition to support program worker change reporting. Adds initial Markdown documentation to support standardized view tracking.

</details>
</details>
<!---CHANGELOG-END--->
