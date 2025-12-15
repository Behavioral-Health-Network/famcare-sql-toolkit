---
front-matter-title: Q_PLACEMENT_PROGRAM_WORKER_HISTORY
category: view-definitions
category-label: View Definitions
source_file: code/view-definitions/q-placement-program-worker-history.sql
last_updated: 2025-09-18
author: Bradley Wing
status: active
lifecycle: production
tags:
  - program-worker-history
program-scope: multi
programs:
  - bcr
  - complex-care
  - ere
  - epicc
  - yere
dependencies:
  - name: placementprogramworkerhistory
    type: html
    repo: famcare-html-form-code
  - name: placementprogramworkerhistory
    type: table
    repo: none
  - name: q-client-bhn
    type: sql
    repo: famcare-sql-toolkit
  - name: q-provider-placement
    type: sql
    repo: famcare-sql-toolkit
  - name: changereason-base
    type: table
    repo: none
  - name: q-hrform
    type: sql
    repo: famcare-sql-toolkit
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
  - date: 2025-09-18
last_reviewed: 2025-09-18
schema_version: 1.0
---


# Q_PLACEMENT_PROGRAM_WORKER_HISTORY

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
  - Follow-up metadata: `VISITDT`, `USERID`, `PARENTDOCSERNO`
  - Enrollment: `PP.DOCSERNO` (ALIASED AS `PP_DOCSERNO`)`ENROLLMENT_STARTING_DATE`, `ENROLLMENT_ENDING_DATE`
  - Program Worker History: `PROGRAM_WORKER_CODE`, `PROGRAM_WORKER_LAST`, `PROGRAM_WORKER_FIRST`, `BEGIN_DATE`, `END_DATE`
  - Change Reason: `CHANGE_REASON_CODE`, `CHANGE_REASON_DESCRIPTION`

## Maintenance Notes

- Monitor for changes in change reason codes and update descriptions accordingly.

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

- **2025-09-18**: Adds initial Markdown documentation to support standardized view tracking.  
- **2025-09-18**: Adds initial view definition to support program worker change reporting.

</details>
</details>
