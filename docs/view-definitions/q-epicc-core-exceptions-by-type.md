---
front-matter-title: Q_EPICC_CORE_EXCEPTIONS_BY_TYPE
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-epicc-core-exceptions-by-type.sql
last_updated: 2025-08-10
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - epicc
tags:
  - exception-logic
  - multi-join
dependencies:
  - name: q-epicc-pathclient-enrollments
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

# Q_EPICC_CORE_EXCEPTIONS_BY_TYPE

## Purpose

Encapsulate reusable logic for exception reporting on EPICC enrollments starting on or after July 1, 2024. Supports staff follow-up, data integrity reviews, and developer diagnostics by surfacing form-level and enrollment-level anomalies.

## Description

- Built on `Q_EPICC_PATHCLIENT_ENROLLMENTS`, filtered to post-2024 enrollments with valid `PP_DOCSERNO`.
- Tags exceptions using ranked prioritization across types:
  - `Missing Required Referral Form`
  - `ETO Referrals Not Imported - Manual Entry Needed`
  - `Invalid Pathway Date - Outside Event Range`
  - `Duplicate Form Entry - Review Required`
- Uses `ROW_NUMBER()` to retain only the highest-priority exception per `CLIENT_NUMBER` and `PWY_EVENT`.
- Excludes rows based on dismissal reason logic and form completion status via `FILTERABLE_ENROLLMENTS`.
- Includes diagnostics for:
  - Pathway date misalignment with event or enrollment bounds
  - Duplicate form entries per event
  - Referral form absence on dismissed or imported enrollments
- Filters final output to rows where `EXCEPTION_TYPE LIKE 'ETO%'`.

## Maintenance Notes

- Update `FILTERABLE_ENROLLMENTS` logic as new dismissal reasons or form expectations are introduced.
- Ensure `Q_EPICC_PATHCLIENT_ENROLLMENTS` remains aligned with enrollment and event metadata.
- Exception tagging logic is modular and DRY-compliant—changes may affect multiple reports.
- Future enhancements may include milestone form thresholds or coordinator-defined exception overrides.

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
- **2025-08-10**: Adds initial Markdown documentation.
- **2025-07-22**: Adds initial EPICC view definition. All changes prior to this were changes to the YERE version of this report, which I have copied here to provide context for the report.
- **2025-07-19**: Confirms alignment of filtered results (1,035 rows) post-refactor; improved integrity of exception attribution, especially for dismissal cases spanning multiple enrollments.
- **2025-07-30**: Replaces ambiguous joins in exception tagging logic with enrollment-level keys to ensure deterministic exception lineage and to prevent spillover from one enrollment to another within a shared client context.
- **2025-07-30**: Resolves misattribution of 'Check and Update Dismissal Reason' exception by scoping dismissal reason logic to unique enrollment slices using `PEC_PATHCLIENT_ENROLLMENT`.
- **2025-07-30**: Updates all exception classification logic to partition by `PEC_PATHCLIENT_ENROLLMENT` in `TAGGED_EXCEPTIONS_RAW` and `TAGGED_EXCEPTIONS`, ensuring accurate per-enrollment tagging for clients with multiple enrollments tied to identical event types.
- **2025-07-22**: Adapts from `Q_EPICC_CORE_EXCEPTIONS_BY_TYPE` for categorizing EPICC exceptions.
- Added logic to exclude all non-Referral forms for ETO enrollments flagged as 'ETO Referrals Not Imported - Manual Entry Needed'. The reason is that non-Referral forms may or may not need to be imported. For those that do not, the rows for those events would never be filtered from the results unless date parameters based on enrollment starting date and ending date were used to present the report from even querying those rows.
- **2025-07-18**: Merges 'Dismissed Without Referral Form' and 'Enrollment Missing Required Referral Form' into unified 'Missing Required Referral Form' exception; refined logic for clarity and staff actionability.
- **2025-07-18**: Refines dismissal logic for 'Reconnect' to exclude non-Referral event rows; only missing Referral form rows retained.
- **2025-07-18**: Updates 'Unable To Locate/Make Contact Post-Referral' dismissal logic to exclude all forms beyond Referral and Initial Assessment; retains only missing expected forms for exception review.
- **2025-07-18**: Adds logic to exclude all post-referral forms for dismissal reason 'Client Admitted To Residential Treatment'; referral form presence required, all other events filtered regardless of completion.
- **2025-07-18**: Filters empty post-referral event rows for 'AnswerFirst Determined Ineligible' dismissal; only 'YERE Referral' is retained for exception analysis.
- **2025-07-18**: Adds refined filtering for active and dismissed enrollments with completed forms; excluded milestone and non-referral forms where dismissal reason implies completion is acceptable; removed referral rows for 'Caregiver Declined Services' and 'Unable To Locate' when form is present.
- **2025-07-18**: Expands `FILTERABLE_ENROLLMENTS` to handle referral rows with completed forms for active and dismissed enrollments; added logic for 'Disengaged', 'Caregiver Declined Services', 'Ineligible', and null dismissal cases.
- **2025-07-18**: Refines 'Administrative' dismissal logic to exclude all event rows, including referral forms when completed; only retains missing referral rows.
- **2025-07-18**: Refactores `FILTERABLE_ENROLLMENTS` to separate 'Reconnect', 'Transfer To Compass', and 'Client Admitted To Residential Treatment' dismissal reasons into individual cases for clarity and future flexibility.
- **2025-07-18**: Expands `FILTERABLE_ENROLLMENTS` logic to handle dismissal reasons 'Administrative', 'Unable To Locate/Make Contact Post-Referral', and 'Caregiver Declined Services Post-Referral'. For 'Administrative' dismissal, Referral is required and all other rows are excluded. If Referral is present, it is filtered also. For 'Unable To Locate/Make Contact Post-Referral', and 'Caregiver Declined Services Post-Referral' dismissals, Referral and Initial Assessment about both required, and all other rows are excluded. Rows for Referral and Initial Assessment are also filtered out if each is complete with a value for `PWY_FORMS_DOCSERNO`.
- **2025-07-18**: Adds `FILTERABLE_ENROLLMENTS` CTE to exclude rows for enrollments with complete form coverage based on dismissal reason logic; initial cases include 'Reconnect', 'Transfer To Compass', 'Client Admitted To Residential Treatment', and 'Program Completion'.
- **2025-07-17**: Filters non-referral events for dismissed enrollments to align report with operational priorities.
- **2025-07-17**: Refactores duplication logic to group by enrollment-level keys, enabling detection of user-generated form duplication.
- **2025-07-17**: Renames 'Legacy Enrollment - No Form or Dismissal' to 'ETO Referrals Not Imported - Manual Entry Needed' for staff clarity.
- **2025-07-17**: Removes obsolete 'Import Mislink' exception type; re-ranked 'Dismissed Without Referral Form' to ensure correct classification.
- **2025-07-17**: Refactores duplication logic to use ENROLLMENTS CTE as source, reducing redundant view evaluation and improving query performance.
- **2025-07-16**: Refines duplication logic to count and join per form (`PWY_FORMS_DOCSERNO`), resolving overcounting when forms matched multiple enrollments. `YENROLL.PWY_FORMS_DOCSERNO` was added to the `SELECT` and `GROUP BY` in the `DUPLICATE_PATHWAY_FORM_PER_ENROLLMENT` CTE and in the `LEFT JOIN` of this CTE in the final select.
- **2025-07-16**: Addes `FORM_MISATTRIBUTION_BY_DATE` diagnostic logic to support detection of forms linked to incorrect enrollments based on out-of-range `PATHWAY_DATE` values.
- **2025-07-15**: Introduces `IMPORT_PWY_DATE_FLAG` to identify PATHWAY_DATE mismatches arising from flawed import patches.
- **2025-07-15**: Adds `FORM_COUNT` logic to detect duplicate form entries per enrollment-event.
- **2025-07-13**: Refines exception tagging logic to apply ranked prioritization across types ('Import Mislink', 'Missing Referral', 'Legacy Gap', 'Dismissal Exception', etc.).
- **2025-07-12**: Filters input data to active enrollments with `PP_DOCSERNO` and post-2024 start.

</details>
</detials>
