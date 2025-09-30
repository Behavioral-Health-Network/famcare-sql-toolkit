---
front-matter-title: Q_EPICC_REENGAGEMENT
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-epicc-reengagement.sql
last_updated: 2025-08-09
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - epicc
tags:
  - tag1
  - tag2
dependencies:
  - name: pwepiccreengagementform
    type: html
    repo: famcare-html-form-code
  - name: pwepiccreengagementform
    type: table
    repo: none
  - name: q-hrform
    type: sql
    repo: famcare-sql-toolkit
  - name: hrform
    type: html
    repo: famcare-html-form-code
  - name: q_client_bhn
    type: view
    repo: famcare-sql-toolkit
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# Q_EPICC_REENGAGEMENT

## Purpose

Tracks client-level data for individuals transferred to a **Re-Engagement Specialist** after failing to engage with their Recovery Coach. Supports program oversight and exception reporting by documenting efforts to re-engage clients prior to dismissal.

## Description

- Built on `PWEPICCREENGAGEMENTFORM`, joined with `Q_CLIENT_BHN` for client metadata.
- Enriches with staff details via `Q_HRFORM` using `FACM` as the linkage key.
- Filters to current records using `DOCREVNO = ' 0 '`.

### Logic Summary

- **Client Join**
  - Uses `CLIENT_NUMBER` to join `PWEPICCREENGAGEMENTFORM` and `Q_CLIENT_BHN`.

- **Staff Join**
  - Uses `FACM` to join with `Q_HRFORM` for Re-Engagement Specialist name.

- **Date Casting**
  - `VISITDT` and `PATHWAY_DATE` cast to `DATE` for consistency.

- **Filter**
  - Restricts to current records via `DOCREVNO = ' 0 '`.

## Output Fields

| Field Name                         | Description |
|------------------------------------|-------------|
| `CLIENT_NUMBER`, `CLIENT_FIRST`, `CLIENT_LAST` | Client identifiers |
| `VISITDT`, `VISITTM`               | Date and time of re-engagement form entry |
| `PATHWAY_DATE`                     | Date of pathway assignment |
| `REENGAGEMENT_SPECIALIST`         | Staff ID assigned to re-engagement |
| `REENGAGEMENT_SPECIALIST_DESCRIPTION` | Staff name (concatenated from HR form) |
| `FOLLOW_UP_FORM_REENGAGEMENT`     | Indicates if follow-up form was completed |
| `DID_CLIENT_REENGAGE`             | Outcome of re-engagement attempt |
| `EFFORTS_TO_ENGAGE_*`             | Flags for various outreach methods (agency visit, phone, letter, etc.) |
| `NOTES_REENGAGEMENT`              | Free-text notes on engagement attempts |
| `STATUS_REENGAGEMENT`             | Status of re-engagement effort |

## Usage Notes

- **Staff Join**: Uses `FACM` from client record to link to `Q_HRFORM`; confirm this reflects the Re-Engagement Specialist.
- **Engagement Flags**: Multiple binary fields track outreach methods; consider summarizing for reporting.
- **Outcome Tracking**: `DID_CLIENT_REENGAGE` and `STATUS_REENGAGEMENT` are key indicators for program effectiveness.

## Maintenance Notes

- **DOCREVNO Filter**: Hardcoded to `' 0 '`; confirm this remains valid for identifying current records.
- **Staff Join Logic**: If `FACM` does not reliably reflect the Re-Engagement Specialist, consider alternative linkage.
- **Field Expansion**: If additional outreach methods are added, update view and documentation accordingly.

## Changelog

- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation.  
- **2025-07-07**: Adds initial view definition to support EPICC Re-Engagement tracking.
