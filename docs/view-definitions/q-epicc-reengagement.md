---
front-matter-title: EPICC Reengagement Form View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-epicc-reengagement.sql
last_updated: 2025-11-19
status: active
lifecycle: production
program_scope: single
programs:
  - epicc
tags:
  - view-layer
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# EPICC Reengagement Form View Definition

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

- **Staff Join**: Joins on `HR.EMPLOYEENUMBER`. `FACM` was originally used, but this proves to be inaccurate. Imported records will lack an employee number to provide the Reengagement Specialist name.
- **Engagement Flags**: Multiple binary fields track outreach methods; consider summarizing for reporting.
- **Outcome Tracking**: `DID_CLIENT_REENGAGE` and `STATUS_REENGAGEMENT` are key indicators for program effectiveness.

## Maintenance Notes

- **DOCREVNO Filter**: Hardcoded to `' 0 '`; confirm this remains valid for identifying current records.
- **Field Expansion**: If additional outreach methods are added, update view and documentation accordingly.

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

- **2025-11-19**: Updates the left join to `Q_HRFORM` to use `HR.EMPLOYEENUMBER = REENGAGE.REENGAGEMENT_SPECIALIST`. Renames `REENGAGE.REENGAGEMENT_SPECIALIST` in the `SELECT` to `REENGAGE.REENGAGEMENT_SPECIALIST_EMPLOYEE_NUMBER`.
- **2025-10-02**: Adds `TIEDENROLLMENT` field to provide a `DOCSERNO` that may be used for joining to the `PATHWAYCLIENT.DOCSERNO` directly.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation.  
- **2025-07-07**: Adds initial view definition to support EPICC Re-Engagement tracking.

</details>
</details>
<!---CHANGELOG-END--->
