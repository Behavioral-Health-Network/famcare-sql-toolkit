---
front-matter-title: Q_ERE_PATHCLIENT_ENROLLMENTS
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-ere-pathclient-enrollments.sql
last_updated: 2025-11-25
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - ere
tags:
  - pathway-join-view
  - multi-join
dependencies:
  - name: providerplacement
    type: html
    repo: famcare-html-form-code
  - name: providerplacement
    type: table
    repo: none
  - name: pathway
    type: table
    repo: none
  - name: pathwayevent
    type: table
    repo: none
  - name: pathwayclient
    type: table
    repo: none
  - name: pathwayeventclient
    type: table
    repo: none
  - name: closingreasons
    type: table
    repo: none
  - name: q-provider
    type: sql
    repo: famcare-sql-toolkit
  - name: q-hrform
    type: sql
    repo: famcare-sql-toolkit
  - name: q-ere-referral
    type: sql
    repo: famcare-sql-toolkit
  - name: q-ere-ihna
    type: sql
    repo: famcare-sql-toolkit
  - name: q-ere-three-month
    type: sql
    repo: famcare-sql-toolkit
  - name: q-ere-six-month
    type: sql
    repo: famcare-sql-toolkit
  - name: q-ere-bhs
    type: sql
    repo: famcare-sql-toolkit
  - name: q-client-bhn
    type: sql
    repo: famcare-sql-toolkit
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# Q_ERE_PATHCLIENT_ENROLLMENTS

## Purpose

Joins client enrollment, Pathway core forms, and the Pathway Event data collection forms to enable program management and to allow for reporting on program outcomes.

## Description

- Consolidates client enrollment and event-level form data for the ERE Pathway.
- Anchored in `PROVIDERPLACEMENT` (PP) as the enrollment source.
- Resolves attribution to `PATHWAYCLIENT` (PC) using dual logic:
  - **DOCSERNO Join**: Preferred linkage when enrollment DOCSERNO matches pathway DOCSERNO.
  - **Enrollment/Start Date Join**: Fallback logic for mismatches (e.g., imports).
- Joins to `PATHWAYEVENTCLIENT` (PEC) and `PATHWAYEVENT` (PE) for event-level metadata.
- Left joins to filtered views of ERE-specific forms to avoid row inflation. Uses the new `TIEDENROLLMENT` field for joins to `PATHWAYCLIENT.DOCSERNO`.
- Uses `COALESCE` and `[ENROLL_PATH_JOIN_SOURCE]` to trace attribution logic.
- Includes form-level metadata:
  - `PATHWAY_DATE`, `VISITDT`, `VISITTM`, `PE_DATE_ACCOMPLISHED`, `DAYS_UNTIL_FORM_DUE`
- Filters to `DOCREVNO = ' 0 '` across all relevant tables to suppress legacy versions.
- Filters to Pathway ID `55320250326123001961` (ERE).

### Logic Summary

- **Source Tables:**
  - `PROVIDERPLACEMENT`, `PATHWAYCLIENT`, `PATHWAYEVENTCLIENT`, `PATHWAYEVENT`, `PATHWAY`
  - ERE form views: `Q_ERE_REFERRAL`, `Q_ERE_IHNA`, `Q_ERE_THREE_MONTH`, `Q_ERE_SIX_MONTH`, `Q_YERE_BHS` (used for ERE BHS)

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client validation and test client exclusion
  - `LEFT JOIN PATHWAYCLIENT` using dual logic (DOCSERNO or start date alignment)
  - `INNER JOIN PATHWAYEVENTCLIENT`, `PATHWAYEVENT`, `PATHWAY`
  - `LEFT JOIN Q_PROVIDER`, `Q_HRFORM`, `CLOSINGREASONS`
  - `LEFT JOIN` to ERE orm views using `CLIENT_NUMBER`, `TIEDENROLLMENT`, and `EVENT_NAME`

- **Output Fields:**
  - Client identifiers and names
  - Enrollment and Pathway dates
  - Attribution source (`ENROLL_PATH_JOIN_SOURCE`)
  - Event metadata and form DOCSERNOs
  - Program worker and agency details

### Diagnostic Logic: TIEDENROLLMENT_MATCH

Validates whether the form-level `TIEDENROLLMENT` value correctly links to the enrollment record.

- Compares `TIEDENROLLMENT` from the ERE form views to the coalesced enrollment DOCSERNO (`COALESCE(PC_DOCSERNO.DOCSERNO, PC_START.DOCSERNO)`).
- Returns:
  - '1' (`TRUE`) - Match confirmed; form correctly tied to enrollment
  - '0' (`FALSE`) - Mismatch; potential patch failure or user selection error
  - `NULL` - No `TIEDENROLLMENT` value present (form not submitted or legacy data)

This column supports validation of the vendor’s historical patch and helps surface attribution anomalies for review.

## Maintenance Notes

- If new ERE event types or forms are introduced, extend the CASE logic and join structure accordingly.
- Ensure form views remain filtered to `DOCREVNO = ' 0 '` and include `EVENT_NAME` for alignment.
- Monitor for changes in event naming conventions that could affect CASE logic or join keys.
- Consider indexing `PATHWAYEVENTCLIENT` and form views on `CLIENT_NUMBER`, `PATHWAY_DATE`, and `EVENT_NAME` for performance.

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

- **2025-12-22**: Updates `PWY_FORMS_VISITDT` to `PWY_FORMS_VISIT_DATE`. Adds `PWY_FORMS_VISIT_TIME`. These may be named as `PARENT_VISIT_DATE` and `PARENT_VISIT_TIME` in exception reports confirming which duplicate Pathway Event form may be safely deleted without causing an orphaned child summation form in the case of duplication.
- **2025-11-25**: Adds `HR.EMPLOYEENUMBER AS [PROGRAM_WORKER_EMPLOYEE_NUMBER]` so that `HR.EMPLOYEENUMBER` will be available for filtering to program worker in the `WHERE` clause of Quick Reports using parameters.
- **2025-10-23**: Adds `FOO.TIEDENROLLMENT` = `PATHWAYEVENT.DOCSERNO` conditions to the Pathway Event form joins and comments out the default `FOO.PATHWAY_DATE` = `PATHWAYEVENTCLIENT.DATE_ACCOMPLISHED` join conditions. This enables one-to-one cardinality for joins to `PROVIDERPLACEMENT`.
- **2025-10-02**: Adds `TIEDENROLLMENT` and `TIEDENROLLMENT_MATCH` to allow aid with validating GVT's patch to update `TIEDENROLLMENT` values for forms entered prior to the implementation of `TIEDENROLLMENT` in the Pathway Event forms. This may also be useful for validation going forward as well.
- **2025-09-16**: Adds `DOCSERNO`, `VISITDT`, and `PATHWAY_DATE` from `Q_ERE_HOSPITAL_VISIT_NOTE` to the columns `PWY_FORMS_DOCSERNO`, `PWY_FORMS_VISITDT`, and `PATHWAY_DATE`.
- **2025-08-21**: Adds `VISITDT` from the Pathway Event forms as column `PWY_FORMS_VISITDT` to allow for the creation of a CareManager report that filters by VISITDT to show newly added or edited records that would need to be entered into CareManager.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation to support standardized view tracking.  
- **2025-07-22**: Adds initial view definition, adapted from YERE architecture with dual join logic and form-level traceability.

</details>
</detials>
