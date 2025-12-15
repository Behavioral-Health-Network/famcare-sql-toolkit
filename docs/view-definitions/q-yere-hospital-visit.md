---
front-matter-title: Q_YERE_HOSPITAL_VISIT
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-yere-hospital-visit.sql
last_updated: 2025-10-02
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - yere
tags: [value1, value2]
dependencies:
  - name: pwyerehospitalvisitnote
    type: html
    repo: famcare-html-form-code
  - name: pwyerehospitalvisitnote
    type: table
    repo: none
  - name: q-client-bhn
    type: sql
    repo: famcare-sql-toolkit
change_control: value
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# Q_YERE_HOSPITAL_VISIT

## Purpose

Captures initial hospital-based contact notes for youth referred to the YERE program. Supports program oversight by documenting whether outreach workers are conducting first visits in the hospital, as requested by the program coordinator.

## Description

- Built on `PWYEREHOSPITALVISITNOTE`, joined with `Q_CLIENT_BHN` for client metadata.
- Filters to current records using `DOCREVNO = ' 0 '`.
- Designed to track face-to-face (FTF) contact types and reasons for non-hospital visits.
- Used to validate outreach worker compliance with hospital-first contact expectations.

### Logic Summary

- **Client Join**
  - Uses `CLIENT_NUMBER` to join `PWYEREHOSPITALVISITNOTE` and `Q_CLIENT_BHN`.

- **Date Casting**
  - `VISITDT` and `PATHWAY_DATE` cast to `DATE` for consistency.

- **Filter**
  - Restricts to current records via `DOCREVNO = ' 0 '`.

## Output Fields

| Field Name                         | Description |
|------------------------------------|-------------|
| `CLIENT_NUMBER`, `PATHWAY_DATE`    | Client identifiers and pathway linkage |
| `VISITDT`, `VISITTM`, `USERID`     | Metadata for audit and traceability |
| `CLIENT_STATUS_HVN`                | Client status at time of hospital visit |
| `YERE_VISIT_HOSP`                  | Indicates whether the visit occurred in the hospital |
| `HOSP_FTF_*`                       | Flags for face-to-face contact types (youth, staff, caregiver, other) |
| `OTHER_FTF`                        | Free-text description of other FTF contact |
| `NO_HOSP_VISIT_REASON`            | Reason why hospital visit did not occur |
| `OTHER_REASON_NOT_FTF`            | Free-text explanation for non-FTF contact |
| `NOTES_HVN`                        | Qualitative notes from the visit |

## Usage Notes

- **Program Intent**: This form was created to ensure outreach workers prioritize hospital-based initial contacts; use this view to monitor compliance.
- **FTF Flags**: Multiple binary fields track who was present during the hospital visit; consider summarizing for reporting.
- **Non-Visit Reasons**: Fields capture structured and free-text reasons for missed hospital visits; useful for exception tracking.

## Maintenance Notes

- **DOCREVNO Filter**: Hardcoded to `' 0 '`; confirm this remains valid for identifying current records.
- **Field Expansion**: If additional FTF types or non-visit reasons are added, update view and documentation accordingly.
- **Client Join Integrity**: Ensure `CLIENT_NUMBER` remains stable across systems.

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

- **2025-12-12**: Adds collapsible `<details>` elements to the Changelog section.
- **2025-10-02**: Adds `TIEDENROLLMENT` field to provide a DOCSERNO that may be used for joining to the PATHWAYCLIENT DOCSERNO directly.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation.  
- **2025-07-15**: Adds initial view definition to support hospital-based contact tracking for YERE referrals.

</details>
</details>
