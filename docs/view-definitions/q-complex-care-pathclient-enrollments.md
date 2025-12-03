---
front-matter-title: Q_COMPLEX_CARE_PATHCLIENT_ENROLLMENTS
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-complex-care-pathclient-enrollments.sql
last_updated: 2025-11-25
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - complex-care
tags:
  - pathway-join-view
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

# Q_COMPLEX_CARE_PATHCLIENT_ENROLLMENTS

## Purpose

Extracts and consolidates enrollment and event data for clients participating in the **Complex Care** Pathway. Supports reporting on enrollment timelines, dismissal reasons, program worker assignments, and Pathway event completion.

## Description

- Consolidates client enrollment and event-level form data for the Complex Care Pathway.
- Anchored in `PROVIDERPLACEMENT` (PP) as the enrollment source.
- Resolves attribution to `PATHWAYCLIENT` (PC) using dual logic:
  - **DOCSERNO Join**: Preferred linkage when enrollment DOCSERNO matches pathway DOCSERNO.
  - **Enrollment/Start Date Join**: Fallback logic for mismatches (e.g., imports).
- Joins to `PATHWAYEVENTCLIENT` (PEC) and `PATHWAYEVENT` (PE) for event-level metadata.
- Left joins to filtered views of Complex Care-specific forms to avoid row inflation. Uses the new `TIEDENROLLMENT` field for joins to `PATHWAYCLIENT.DOCSERNO`.
- Uses `COALESCE` and `ENROLL_PATH_JOIN_SOURCE` to trace attribution logic.
- Includes form-level metadata:
  - `PATHWAY_DATE`, `PE_DATE_ACCOMPLISHED`, `DAYS_UNTIL_FORM_DUE`
  - `TREATMENT_PATH`, `PROGRAM_PARTICIPATION`, `PRO_OR_CORE`
- Filters to `DOCREVNO = ' 0 '` across all relevant tables to suppress legacy record versions.
- Filters to Pathway ID `55320240920114308822` (Complex Care).

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client validation and test client exclusion
  - `LEFT JOIN PATHWAYCLIENT` (dual logic)
  - `INNER JOIN PATHWAYEVENT`, `PATHWAY`
  - `LEFT JOIN Q_PROVIDER`, `Q_HRFORM`, `CLOSINGREASONS`
  - `LEFT JOIN` to Complex Care form views using `CLIENT_NUMBER`, `TIEDENROLLMENT`, and `EVENT_NAME`

## Output Fields

| Field Name                         | Description |
|------------------------------------|-------------|
| `CLIENT_NUMBER`                    | Unique client identifier |
| `ENROLLMENT_STARTING_DATE`, `ENROLLMENT_ENDING_DATE` | Program enrollment dates |
| `DISMISSAL_REASON_DESCRIPTION`     | Reason for program exit |
| `PP_DOCSERNO`, `PC_DOCSERNO`, `PEC_PATHCLIENT_DOCSERNO` | Document references |
| `AGENCY_DESCRIPTION`              | Name of assigned agency |
| `PWY_START_DATE`, `PWY_END_DATE`   | Pathway participation dates |
| `PWY_EVENT`                        | Name of Pathway event |
| `PWY_FORMS_DOCSERNO`              | Matched form DOCSERNO for Complex Care Roster |
| `EVENT_START_DATE`, `EVENT_END_DATE`, `PE_DATE_ACCOMPLISHED` | Event timing |
| `DAYS_UNTIL_FORM_DUE`             | Countdown to event deadline |
| `CURRENT_MESSAGE`                 | Status message from event record |
| `PROGRAM_WORKER_FIRST`, `PROGRAM_WORKER_LAST` | Assigned staff member |

### Diagnostic Logic: TIEDENROLLMENT_MATCH

Validates whether the form-level `TIEDENROLLMENT` value correctly links to the enrollment record.

- Compares `TIEDENROLLMENT` from the Complex Care form views to the coalesced enrollment DOCSERNO (`COALESCE(PC_DOCSERNO.DOCSERNO, PC_START.DOCSERNO)`).
- Returns:
  - '1' (`TRUE`) - Match confirmed; form correctly tied to enrollment
  - '0' (`FALSE`) - Mismatch; potential patch failure or user selection error
  - `NULL` - No `TIEDENROLLMENT` value present (form not submitted or legacy data)

This column supports validation of the vendor’s historical patch and helps surface attribution anomalies for review.

## Maintenance Notes

- **Pathway ID Filter**: Hardcoded to `55320240920114308822`; confirm this remains valid for Complex Care.
- **Form Matching Logic**: Ensure `ROSTER.EVENT_NAME = PE.SHORTDESCRIPTION` remains aligned with naming conventions.
- **Join Integrity**: Changes to `PROVIDERPLACEMENT`, `PATHWAYCLIENT`, `PATHWAYEVENTCLIENT`, or `Q_HRFORM` may affect logic.
- **Test Client Filtering**: Confirm `Q_CLIENT_BHN` continues to exclude test clients reliably.

## Changelog

- **2025-11-25**: Adds `HR.EMPLOYEENUMBER AS [PROGRAM_WORKER_EMPLOYEE_NUMBER]` so that `HR.EMPLOYEENUMBER` will be available for filtering to program worker in the `WHERE` clause of Quick Reports using parameters.
- **2025-11-12**: Adds joins to `Q_COMPLEX_CARE_MERCY_BEACN_BENCHMARKS` and `Q_COMPLEX_CARE_PFP_DISCHARGE` now that those have been created. Ensures that each condition includes these two forms joined using `TIEDENROLLMENT`.
- **2025-10-23**: Adds `FOO.TIEDENROLLMENT` = `PATHWAYEVENT.DOCSERNO` conditions to the Pathway Event form joins and comments out the default `FOO.PATHWAY_DATE` = `PATHWAYEVENTCLIENT.DATE_ACCOMPLISHED` join conditions. This enables one-to-one cardinality for joins to `PROVIDERPLACEMENT`.
- **2025-10-02**: Adds `TIEDENROLLMENT` and `TIEDENROLLMENT_MATCH` to allow aid with validating GVT's patch to update `TIEDENROLLMENT` values for forms entered prior to the implementation of `TIEDENROLLMENT` in the Pathway Event forms. This may also be useful for validation going forward as well.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-10**: Adds initial Markdown documentation.  
- **2025-08-10**: Adds initial view to support Complex Care Pathway enrollment and event tracking.
