---
front-matter-title: ERE BHS Date Validation Exceptions View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-ere-bhs-date-validation-exceptions.sql
last_updated: 2026-01-26
status: active
lifecycle: production
program_scope: single
programs:
  - ere
tags:
  - view-layer
  - exception-logic
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# ERE BHS Date Validation Exceptions Exceptions View Definition

## Purpose

Identifies **enrollment-to-admission date inconsistencies** within the ERE referral and Behavioral Health Service (BHS) workflows. Supports exception reporting, data quality remediation, and pathway validation for analysts and program staff.

## Description

- Pulls **referral enrollment records** from `Q_ERE_PATHCLIENT_ENROLLMENTS` where `PWY_EVENT = 'ERE Referral'`.
- Pulls **BHS admission records** from the same source where `PWY_EVENT = 'ERE Behavioral Health Service'` and the client was admitted to services.
- Joins referral and BHS records using `TIEDENROLLMENT` to align events within the same enrollment episode.
- Flags rows where:
  - The **referral pathway date** occurs *before* the enrollment starting date.
  - Either **BH_ADMISSION_DATE** or **SU_ADMISSION_DATE** falls *outside* the enrollment date range.
- Returns only rows with at least one exception condition.

### Logic Summary

- **Referral Extraction**
  - Selects referral events (`PWY_EVENT = 'ERE Referral'`) with a valid `PWY_FORMS_DOCSERNO`.
  - Captures enrollment start/end dates and referral pathway date.

- **BHS Extraction**
  - Selects BHS events (`PWY_EVENT = 'ERE Behavioral Health Service'`) where:
    - `ADMITTED_TO_SERVICES = 'Yes'`
    - At least one admission date (BH or SU) is present.
  - Captures BH/SU admission dates and BHS pathway date.

- **Episode Alignment**
  - Joins referral and BHS records on `TIEDENROLLMENT` to ensure both events belong to the same enrollment episode.

- **Exception Logic**
  - **Referral Date Issue**: `REF.PATHWAY_DATE < REF.ENROLLMENT_STARTING_DATE`
  - **BH Admission Issue**: BH date exists and is outside the enrollment window.
  - **SU Admission Issue**: SU date exists and is outside the enrollment window.
  - **HAS_ISSUE** flag consolidates all three checks.

- **Final Filter**
  - Only rows where `HAS_ISSUE = 1` are returned.

## Output Fields

Returns one row per enrollment episode with at least one date exception. Key fields include:

| Field Name | Description |
|------------|-------------|
| `CLIENT_NUMBER` | Unique client identifier |
| `ENROLLMENT_STARTING_DATE`, `ENROLLMENT_ENDING_DATE` | Enrollment window |
| `REF_PATHWAY_DATE` | Referral pathway date |
| `BHS_PATHWAY_DATE` | BHS pathway date |
| `BH_ADMISSION_DATE`, `SU_ADMISSION_DATE` | Admission dates used for validation |
| `REF_DATE_ISSUE` | 1 if referral date is before enrollment start |
| `BH_ADMISSION_ISSUE` | 1 if BH admission is outside enrollment window |
| `SU_ADMISSION_ISSUE` | 1 if SU admission is outside enrollment window |

## Usage Notes

- **Exception-Only Output**: This view is designed for analysts who need to focus exclusively on problematic records; non-issue rows are excluded.
- **Open Enrollment Handling**: If `ENROLLMENT_ENDING_DATE` is NULL, only the lower bound is enforced.
- **Admission Date Presence**: BHS rows are included only when at least one admission date exists.
- **Pathway Alignment**: `TIEDENROLLMENT` ensures referral and BHS events belong to the same episode; mismatches indicate upstream data issues.

## Maintenance Notes

- **Event Type Dependency**: Logic depends on `PWY_EVENT` values `'ERE Referral'` and `'ERE Behavioral Health Service'`; confirm these remain stable.
- **Admission Logic**: If future workflows introduce additional admission types, update the exception logic accordingly.
- **Date Validity**: Consider adding checks for obviously invalid dates (e.g., future dates) if needed for QA.
- **Performance**: CTE structure is efficient for this dataset; no scalar functions are applied to indexed columns.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

- **2026-01-26**: Adds initial view definition of exception logic for referral and BHS admission date validation. Adds initial Markdown documentation of view definition.

</details>
</details>
<!---CHANGELOG-END--->
