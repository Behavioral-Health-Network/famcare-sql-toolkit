---
front-matter-title: Q_ERE_HOSPITAL_VISIT_NOTE
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-ere-hospital-visit-note.sql
last_updated: 2025-09-30
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - yere
tags:
  - tag1
  - tag2
dependencies:
  - name: pwerehospitalvisitnote
    type: html
    repo: famcare-html-form-code
  - name: pwerehospitalvisitnote
    type: table
    repo: none
  - name: q-client-bhn
    type: sql
    repo: famcare-sql-toolkit
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-09-16
last_reviewed: 2025-09-16
schema_version: 1.0
---

# Q_ERE_HOSPITAL_VISIT_NOTE

## Purpose

Captures initial hospital-based contact notes for clients referred to the ERE program. Supports program oversight by documenting whether outreach workers are conducting first visits in the hospital, as requested by the program manager.

## Description

- Built on `PWEREHOSPITALVISITNOTE`, joined with `Q_CLIENT_BHN` for client metadata.
- Filters to current records using `DOCREVNO = ' 0 '`.
- Designed to track face-to-face (FTF) contact types and reasons for non-hospital visits.
- Used to validate outreach worker compliance with hospital-first contact expectations.

### Logic Summary

- **Client Join**
  - Uses `CLIENT_NUMBER` to join `PWEREHOSPITALVISITNOTE` and `Q_CLIENT_BHN`.

- **Date Casting**
  - `VISITDT` and `PATHWAY_DATE` cast to `DATE` for consistency.

- **Filter**
  - Restricts to current records via `DOCREVNO = ' 0 '`.

## Output Fields

| Field Name                         | Description |
|------------------------------------|-------------|
| `CLIENT_NUMBER`, `PATHWAY_DATE`    | Client identifiers and pathway linkage |
| `VISITDT`, `VISITTM`, `USERID`     | Metadata for audit and traceability |
| `ERE_VISIT_HOSP`                   | Indicates whether the visit occurred in the hospital |
| `VISIT_HOSP_OUTCOME`               | Outcome of the hospital visit - seems to indicate client status |
| `VISIT_HOSP_OUTCOME_OTHER`         | Free-text description of other hospital visit outcome |
| `VISIT_HOSP_NO_OUTCOME`            | Reason why hospital visit did not occur |
| `OTHER_REASON_NOT_FTF`             | Free-text explanation for lack of hospital visit |
| `ERE_NOTES_HVN`                        | Qualitative notes from the visit |

## Usage Notes

- **Program Intent**: This form was created to ensure outreach workers prioritize hospital-based initial contacts; use this view to monitor compliance.
- **Hospital Visit Outcomes**: Fields capture structured and free-text explanations of the outcome of visits, which appear to be documentation of client status with the program.
- **Non-Visit Reasons**: Fields capture structured and free-text reasons for missed hospital visits; useful for exception tracking.

## Maintenance Notes

- **DOCREVNO Filter**: Hardcoded to `' 0 '`; confirm this remains valid for identifying current records.
- **Client Join Integrity**: Ensure `CLIENT_NUMBER` remains stable across systems.

## Changelog

- **2025-09-30**: Adds `TIEDENROLLMENT` field to provide a DOCSERNO that may be used for joining to the PATHWAYCLIENT DOCSERNO directly.
- **2025-09-16**: Adds initial Markdown documentation.  
- **2025-09-12**: Adds initial view definition to support hospital-based contact tracking for ERE referrals.
