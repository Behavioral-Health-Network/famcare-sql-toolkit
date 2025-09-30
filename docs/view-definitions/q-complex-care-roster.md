---
front-matter-title: Q_COMPLEX_CARE_ROSTER
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-complex-care-roster.sql
last_updated: 2025-08-09
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - complex-care
tags:
  - tag1
  - tag2
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

# Q_COMPLEX_CARE_ROSTER

## Purpose

Tracks participants in the **Clinical BEACN** program, known as the **Complex Care** program in FAMCare. Supports program enrollment tracking, agency assignment validation, and CIMOR status reporting.

## Description

- Built on `PWCOMPLEXCAREROSTER`, joined with `Q_CLIENT_BHN` for client identifiers.
- Enriches roster data with CIMOR status and agency descriptions via lookup tables.
- Filters to current records using `DOCREVNO = ' 0 '`.

### Logic Summary

- **Client Join**
  - Uses `CLIENT_NUMBER` to join `PWCOMPLEXCAREROSTER` and `Q_CLIENT_BHN`.

- **Status and Agency Lookups**
  - Joins to `CIMOR_STATUS`, `CMHC_AGENCY`, and `ADA_SU_AGENCY` for descriptive fields.

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
| `PROGRAM_ASSIGNED`                 | Assigned program name |
| `CIMOR_STATUS_CODE`, `CMHC_CIMOR_STATUS.DESCRIPTION` | CMHC status and description |
| `CMHC_AGENCY_CODE`, `CMHC_AGENCY_DESCRIPTION`        | CMHC agency code and name |
| `OTHER_CMHC_AGENCY`                | Free-text alternate CMHC agency |
| `ADA_CIMOR_STATUS_CODE`, `ADA_CIMOR_STATUS_DESCRIPTION` | ADA/SU status and description |
| `ADA_SU_AGENCY_CODE`, `ADA_SU_AGENCY_DESCRIPTION`     | ADA/SU agency code and name |
| `OTHER_ADA_SU_AGENCY`             | Free-text alternate ADA/SU agency |

## Usage Notes

- **Program Naming**: Clinical BEACN in roster; Complex Care in FAMCare. Ensure naming consistency in downstream reports.
- **Agency Fields**: Includes both coded and free-text agency fields; consider flagging mismatches or missing codes.
- **Status Lookups**: Descriptions pulled from `CIMOR_STATUS` and agency tables; ensure lookup tables are maintained.

## Maintenance Notes

- **DOCREVNO Filter**: Hardcoded to `' 0 '`; confirm this remains valid for identifying current records.
- **Join Integrity**: Ensure lookup tables (`CIMOR_STATUS`, `CMHC_AGENCY`, `ADA_SU_AGENCY`) remain aligned with roster codes.
- **Client Join**: Relies on `CLIENT_NUMBER`; confirm stability across systems.

## Changelog

- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation.  
- **2025-07-09**: Adds initial view definition to support Clinical BEACN / Complex Care roster tracking.
