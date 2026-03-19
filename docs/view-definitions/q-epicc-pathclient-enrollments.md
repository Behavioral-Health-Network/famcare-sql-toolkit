---
front-matter-title: EPICC Pathclient Enrollments View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-epicc-pathclient-enrollments.sql
last_updated: 2025-12-19
status: active
lifecycle: production
program_scope: single
programs:
  - epicc
tags:
  - pathway-join-view
  - multi-join
  - view-layer
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# EPICC Pathclient Enrollments View Definition

## Purpose

Joins client enrollment, Pathway core forms, and the Pathway Event data collection forms to enable program management and to allow for reporting on program outcomes.

## Description

- Consolidates client enrollment and event-level form data for the EPICC Pathway.
- Anchored in `PROVIDERPLACEMENT` (PP) as the enrollment source.
- Resolves attribution to `PATHWAYCLIENT` (PC) using dual logic:
  - **DOCSERNO Join**: Preferred linkage when enrollment DOCSERNO matches pathway DOCSERNO.
  - **Enrollment/Start Date Join**: Fallback logic for mismatches (e.g., imports).
- Joins to `PATHWAYEVENTCLIENT` (PEC) and `PATHWAYEVENT` (PE) for event-level metadata.
- Left joins to filtered views of EPICC-specific forms to avoid row inflation. Uses the new `TIEDENROLLMENT` field for joins to `PATHWAYCLIENT.DOCSERNO`.
- Uses `COALESCE` and `ENROLL_PATH_JOIN_SOURCE` to trace attribution logic.
- Includes form-level metadata:
  - `PATHWAY_DATE`, `VISITDT`, `VISITTM`, `PE_DATE_ACCOMPLISHED`, `DAYS_UNTIL_FORM_DUE`
  - `TREATMENT_PATH`, `PROGRAM_PARTICIPATION`, `PRO_OR_CORE`
- Filters to `DOCREVNO = ' 0 '` across all relevant tables to suppress legacy record versions.
- Filters to Pathway ID `55320240807113504583` (EPICC).

### Logic Summary

- **Source Tables:**
  - `PROVIDERPLACEMENT`, `PATHWAYCLIENT`, `PATHWAYEVENTCLIENT`, `PATHWAYEVENT`, `PATHWAY`
  - EPICC form views: `Q_EPICC_REFERRAL`, `Q_EPICC_IC`, `Q_EPICC_TWO_WEEK`, `Q_EPICC_THIRTY_DAY`, `Q_EPICC_THREE_MONTH`, `Q_EPICC_SIX_MONTH`

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client validation and test client exclusion
  - `LEFT JOIN PATHWAYCLIENT` (dual logic)
  - `INNER JOIN PATHWAYEVENT`, `PATHWAY`
  - `LEFT JOIN Q_PROVIDER`, `Q_HRFORM`, `CLOSINGREASONS`
  - `LEFT JOIN` to EPICC orm views using `CLIENT_NUMBER`, `TIEDENROLLMENT`, and `EVENT_NAME`

- **Output Fields:**
  - Client identifiers and names
  - Enrollment and pathway dates
  - Attribution source (`ENROLL_PATH_JOIN_SOURCE`)
  - Event metadata and form DOCSERNOs
  - Treatment path and program participation descriptions
  - Program worker and agency details

### Diagnostic Logic: TIEDENROLLMENT_MATCH

Validates whether the form-level `TIEDENROLLMENT` value correctly links to the enrollment record.

- Compares `TIEDENROLLMENT` from the EPICC form views to the coalesced enrollment DOCSERNO (`COALESCE(PC_DOCSERNO.DOCSERNO, PC_START.DOCSERNO)`).
- Returns:
  - '1' (`TRUE`) - Match confirmed; form correctly tied to enrollment
  - '0' (`FALSE`) - Mismatch; potential patch failure or user selection error
  - `NULL` - No `TIEDENROLLMENT` value present (form not submitted or legacy data)

This column supports validation of the vendor’s historical patch and helps surface attribution anomalies for review.

## Maintenance Notes

- If new EPICC event types or forms are introduced, extend the CASE logic and join structure accordingly.
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

</details>

<details markdown="1">
  <summary><strong>2025</strong></summary>

### 2025

- **2025-12-30**: Updates to use fields `EREF.VISIT_DATE`, `EIC.VISIT_DATE`, `ETWOW.VISIT_DATE`, `ETHIRTYD.VISIT_DATE`, `ETHREEM.VISIT_DATE`, `ESIXM.VISIT_DATE`, `EREF.VISIT_TIME`, `EIC.VISIT_TIME`, `ETWOW.VISIT_TIME`, `ETHIRTYD.VISIT_TIME`, `ETHREEM.VISIT_TIME`, `ESIXM.VISIT_TIME`.
- **2025-12-19**: Adds fields `VISITDT AS [PWY_FORMS_VISIT_DATE]` and `VISITTM AS [PWY_FORMS_VISIT_TIME]` to give context for making decisions when deleting duplicate forms.
- **2025-11-25**: Adds `HR.EMPLOYEENUMBER AS [PROGRAM_WORKER_EMPLOYEE_NUMBER]` so that `HR.EMPLOYEENUMBER` will be available for filtering to program worker in the `WHERE` clause of Quick Reports using parameters.
- **2025-10-23**: Adds `FOO.TIEDENROLLMENT` = `PATHWAYEVENT.DOCSERNO` conditions to the Pathway Event form joins and comments out the default `FOO.PATHWAY_DATE` = `PATHWAYEVENTCLIENT.DATE_ACCOMPLISHED` join conditions. This enables one-to-one cardinality for joins to `PROVIDERPLACEMENT`.
- **2025-10-02**: Adds `TIEDENROLLMENT` and `TIEDENROLLMENT_MATCH` to allow aid with validating GVT's patch to update `TIEDENROLLMENT` values for forms entered prior to the implementation of `TIEDENROLLMENT` in the Pathway Event forms. This may also be useful for validation going forward as well.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-10**: Adds initial Markdown documentation.  
- **2025-07-13**: Adds column `[ENROLL_PATH_JOIN_SOURCE]` to trace how each enrollment was linked to a pathway. Replaces direct `INNER JOIN` to `PATHWAYCLIENT` with dual `LEFT JOIN` strategy using `DOCSERNO` and enrollment/start date alignment.
- **2025-05-07**: Adds initial view definition.

</details>
</details>
<!---CHANGELOG-END--->
