---
front-matter-title: YERE Pathclient Enrollments View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-yere-pathclient-enrollments.sql
last_updated: 2026-05-04
status: active
lifecycle: production
program_scope: single
programs:
  - yere
tags:
  - pathway-join-view
  - multi-join
schema_version: 1.0
---

# YERE Pathclient Enrollments View Definition

## Purpose

Joins client enrollment, Pathway core forms, and the Pathway Event data collection forms to enable program management and to allow for reporting on program outcomes.

## Description

- Consolidates client enrollment and event-level form data for the YERE Pathway.
- Anchored in `PROVIDERPLACEMENT` (PP) as the enrollment source.
- Resolves attribution to `PATHWAYCLIENT` (PC) using dual logic:
  - **DOCSERNO Join**: Preferred linkage when enrollment DOCSERNO matches pathway DOCSERNO.
  - **Enrollment/Start Date Join**: Fallback logic for mismatches (e.g., imports).
- Joins to `PATHWAYCLIENT`, `PATHWAYEVENTCLIENT` (PEC), and `PATHWAYEVENT` (PE) for event-level metadata.
- Left joins to filtered views of YERE-specific forms to avoid row inflation. Uses the new `TIEDENROLLMENT` field for joins to `PATHWAYCLIENT.DOCSERNO`.
- Uses `COALESCE` and `[ENROLL_PATH_JOIN_SOURCE]` to trace attribution logic.
- Includes form-level metadata:
  - `PATHWAY_DATE`, `VISITDT`, `VISITTM`, `PE_DATE_ACCOMPLISHED`, `DAYS_UNTIL_FORM_DUE`
- Filters to `DOCREVNO = ' 0 '` across all relevant tables to suppress legacy versions.

### Logic Summary

- **Source Tables:**
  - `PROVIDERPLACEMENT`, `PATHWAYCLIENT`, `PATHWAYEVENTCLIENT`, `PATHWAYEVENT`, `PATHWAY`
  - YERE form views: `Q_YERE_REFERRAL`, `Q_YERE_IA`, `Q_YERE_THIRTY_DAY`, `Q_YERE_THREE_MONTH`, `Q_YERE_SIX_MONTH`, `Q_YERE_BHS`, `Q_YERE_HOSPITAL_VISIT`

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client validation and test client exclusion
  - `LEFT JOIN PATHWAYCLIENT` (dual logic)
  - `INNER JOIN PATHWAYEVENT`, `PATHWAY`
  - `LEFT JOIN Q_PROVIDER`, `Q_HRFORM`, `CLOSINGREASONS`
  - `LEFT JOIN` to YERE form views using `CLIENT_NUMBER`, `TIEDENROLLMENT`, and `EVENT_NAME`

- **Output Fields:**
  - Client identifiers and names
  - Enrollment and pathway dates
  - Attribution source (`ENROLL_PATH_JOIN_SOURCE`)
  - Event metadata and form DOCSERNOs
  - Program worker and agency details

### Diagnostic Logic: TIEDENROLLMENT_MATCH

Validates whether the form-level `TIEDENROLLMENT` value correctly links to the enrollment record.

- Compares `TIEDENROLLMENT` from the YERE form views to the coalesced enrollment DOCSERNO (`COALESCE(PC_DOCSERNO.DOCSERNO, PC_START.DOCSERNO)`).
- Returns:
  - '1' (`TRUE`) - Match confirmed; form correctly tied to enrollment
  - '0' (`FALSE`) - Mismatch; potential patch failure or user selection error
  - `NULL` - No `TIEDENROLLMENT` value present (form not submitted or legacy data)

This column supports validation of the vendor’s historical patch and helps surface attribution anomalies for review.

## Maintenance Notes

- If new YERE event types or forms are introduced, extend the CASE logic and join structure accordingly.
- Ensure form views remain filtered to `DOCREVNO = ' 0 '` and include `EVENT_NAME` for alignment.
- Monitor for changes in event naming conventions that could affect CASE logic or join keys.
- Consider indexing `PATHWAYEVENTCLIENT` and form views on `CLIENT_NUMBER`, `PATHWAY_DATE`, and `EVENT_NAME` for performance.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

- **2026-01-08**: Updates to use fields `YREF.VISIT_DATE`, `YHOSP.VISIT_DATE`, `YIA.VISIT_DATE`, `YTHIRTYD.VISIT_DATE`, `YTHREEM.VISIT_DATE`, `YSIXM.VISIT_DATE`, `YREF.VISIT_TIME`, `YHOSP.VISIT_TIME`, `YIA.VISIT_TIME`, `YTHIRTYD.VISIT_TIME`, `YTHREEM.VISIT_TIME`, `YSIXM.VISIT_TIME`.

</details>

<details markdown="1">
  <summary><strong>2025</strong></summary>

### 2025

- **2025-12-12**: Adds collapsible `<details>` elements to the Changelog section.
- **2025-11-25**: Adds `HR.EMPLOYEENUMBER AS [PROGRAM_WORKER_EMPLOYEE_NUMBER]` so that `HR.EMPLOYEENUMBER` will be available for filtering to program worker in the `WHERE` clause of Quick Reports using parameters.
- **2025-10-23**: Adds `FOO.TIEDENROLLMENT` = `PATHWAYEVENT.DOCSERNO` conditions to the Pathway Event form joins and comments out the default `FOO.PATHWAY_DATE` = `PATHWAYEVENTCLIENT.DATE_ACCOMPLISHED` join conditions. This enables one-to-one cardinality for joins to `PROVIDERPLACEMENT`.
- **2025-10-02**: Adds `TIEDENROLLMENT` and `TIEDENROLLMENT_MATCH` to aid with validating GVT's patch to update `TIEDENROLLMENT` values for forms entered prior to the implementation of `TIEDENROLLMENT` in the Pathway Event forms. This may also be useful for validation going forward as well.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-10**: Adds initial Markdown documentation.
- **2025-07-16**: Standardizes join logic for `Q_YERE_BHS` and `Q_YERE_HOSPITAL_VISIT` to match other form views.
- **2025-07-15**: Adds view-based joins for Behavioral Health Services (YBHS) and Hospital Visit Note (HOSP), resolving form-level duplication.
- **2025-07-13**: Adds column `[ENROLL_PATH_JOIN_SOURCE]` to trace how each enrollment was linked to a pathway. Replaces direct `INNER JOIN` to `PATHWAYCLIENT` with dual `LEFT JOIN` strategy using `DOCSERNO` and enrollment/start date alignment.
- **2025-05-04**: Adds initial view definition.

</details>
</details>
<!---CHANGELOG-END--->
