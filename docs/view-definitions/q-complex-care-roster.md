---
front-matter-title: Complex Care Roster View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-complex-care-roster.sql
last_updated: 2026-03-05
status: active
lifecycle: production
program_scope: single
programs:
  - complex-care
tags:
  - view-layer
dependencies:
  - value1
  - value2
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# Complex Care Roster View Definition

## Purpose

Tracks participants in the **Clinical BEACN** program, known as the **Complex Care** program in FAMCare. Supports program enrollment tracking, agency assignment validation, and CIMOR status reporting.

## Description

- Built on `PWCOMPLEXCAREROSTER`, joined with `Q_CLIENT_BHN` for client identifiers.
- Enriches roster data with CIMOR status, DM3700 status, and agency descriptions via lookup tables.
- Filters to current records using `DOCREVNO = ' 0 '`.

### Logic Summary

- **Client Join**
  - Uses `CLIENT_NUMBER` to join `PWCOMPLEXCAREROSTER` and `Q_CLIENT_BHN`.

- **Status and Agency Lookups**
  - Joins to `CIMOR_STATUS`, `DM3700_STATUS`, `CMHC_AGENCY`, and `ADA_SU_AGENCY` for descriptive fields.

- **Date Casting**
  - `VISITDT` and `PATHWAY_DATE` cast to `DATE` for consistency.

- **Filter**
  - Restricts to current records via `DOCREVNO = ' 0 '`.

## Output Fields

| Field Name                         | Description |
|------------------------------------|-------------|
| `CLIENT_NUMBER`                    | Unique client identifier |
| `VISITDT`, `VISITTM`               | Date and time of roster entry |
| `PATHWAY_DATE`                     | Date of pathway assignment |
| `ADDED_COHORT_DATE`                | Date of cohort selection |
| `COMPLEX_CARE_REFERRAL_SOURCE_CODE`     | Code for Referral Source for cohort referral |
| `COMPLEX_CARE_REFERRAL_SOURCE_DESCRIPTION` | Description for Referral Source for cohort referral |
| `PROGRAM_ASSIGNED`                 | Assigned program name |
| `PAYOR_IS_OPTUM_UHC`                 | Flag for identifying patients with non-commercial payor name starting with "Optum" or "United Healthcare" |
| `CIMOR_STATUS_CODE`, `CMHC_CIMOR_STATUS.DESCRIPTION` | CMHC status code and description |
| `CMHC_AGENCY_CODE`, `CMHC_AGENCY_DESCRIPTION`        | CMHC agency code and name |
| `OTHER_CMHC_AGENCY`                | Free-text alternate CMHC agency |
| `ADA_CIMOR_STATUS_CODE`, `ADA_CIMOR_STATUS_DESCRIPTION` | ADA/SU status code and description |
| `ADA_SU_AGENCY_CODE`, `ADA_SU_AGENCY_DESCRIPTION`     | ADA/SU agency code and name |
| `OTHER_ADA_SU_AGENCY`             | Free-text alternate ADA/SU agency |
| `DM3700_STATUS_CODE`, `DM3700_STATUS_DESCRIPTION`     | DM3700 status code and description |

## Usage Notes

- **Program Naming**: Clinical BEACN in roster; Complex Care in FAMCare. Ensure naming consistency in downstream reports.
- **Agency Fields**: Includes both coded and free-text agency fields; consider flagging mismatches or missing codes.
- **Status Lookups**: Descriptions pulled from `CIMOR_STATUS`, `DM3700_STATUS`, and agency tables; ensure lookup tables are maintained.

## Maintenance Notes

- **DOCREVNO Filter**: Hardcoded to `' 0 '`; confirm this remains valid for identifying current records.
- **Join Integrity**: Ensure lookup tables (`CIMOR_STATUS`, `CMHC_AGENCY`, `ADA_SU_AGENCY`) remain aligned with roster codes.
- **Client Join**: Relies on `CLIENT_NUMBER`; confirm stability across systems.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

- **2026-03-05**: Adds `payor_is_optum_uhc` field to the view definition.
- **2026-01-06**: Adds `LEFT JOIN COMPLEX_CARE_REFERRAL_SOURCE AS [REFSOURCE]`. Renames `COMPLEX_CARE_REFERRAL_SOURCE` with alias `COMPLEX_CARE_REFERRAL_SOURCE_CODE`. Adds description with alias `COMPLEX_CARE_REFERRAL_SOURCE_DESCRIPTION`.

</details>

<details markdown="1">
  <summary><strong>2025</strong></summary>

### 2025

- **2025-11-06**: Adds `dm3700_status` and `complex_care_referral_source` fields.
- **2025-11-05**: Adds `added_cohort_date` field, which is the cohort selection date.
- **2025-10-02**: Adds `TIEDENROLLMENT` field to provide a DOCSERNO that may be used for joining to the PATHWAYCLIENT DOCSERNO directly.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation.  
- **2025-07-09**: Adds initial view definition to support Clinical BEACN / Complex Care roster tracking.

</details>
</details>
<!---CHANGELOG-END--->
