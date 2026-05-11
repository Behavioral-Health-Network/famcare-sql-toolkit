---
front-matter-title: EPICC Case Notes View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-epicc-case-notes.sql
last_updated: 2026-05-11
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - epicc
tags:
  - view-layer
  - case-note-data
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# EPICC Case Notes View Definition

## Purpose

Returns case note encounter records for EPICC clients, enriched with program enrollment context, provider metadata, and contact‑type classifications. Supports operational reporting, encounter auditing, and program‑specific analytics.

## Description

- Built on `CASENOTEDETAIL` and joined with `[Q_CLIENT_BHN]` to obtain client identifiers.
- Enriches case notes with program worker information from `[Q_HRFORM]`.
- Resolves contact type descriptions using `[CONTACTTYPE]`.
- Adds agency and location metadata via `[Q_PROVIDER_BHN]` and `[SERVICESITE]`.
- Aligns each case note with the correct EPICC program enrollment using `[Q_PROVIDERPLACEMENT_BHN]`, filtered to active enrollment windows.

### Logic Summary

- **Client Join**
  - Links `CASENOTEDETAIL.CLIENTNUMBER` to `Q_CLIENT_BHN.CLIENT_NUMBER` to ensure consistent client identity resolution.

- **Program Worker Resolution**
  - Joins `CN.[SERVER]` to `Q_HRFORM.EMPLOYEENUMBER` to retrieve worker first/last names.

- **Contact Type Classification**
  - Maps `CONTACTTYPE` codes to human‑readable descriptions via `CONTACTTYPE.DESCRIPTION`.

- **Agency & Location Metadata**
  - Resolves `PROVIDERSERVICE` to provider name.
  - Resolves `SERVICESITE` to location description.

- **Program Enrollment Alignment**
  - Filters to EPICC program code `100006`.
  - Ensures the case note’s `CONTACTDATE` falls within the provider placement’s enrollment window.
  - Excludes zero‑length enrollments unless explicitly valid.

- **Record Filtering**
  - Includes only records where `DOCREVNO = ' 0 '` (current revision).

## Output Fields

| Field Name | Description |
|------------|-------------|
| `ID` | Case note record identifier |
| `DOCSERNO` | Document serial number for the case note |
| `VISITDT`, `VISITTM` | Visit date and time metadata |
| `USERID` | User who entered the case note |
| `CLIENT_NUMBER` | EPICC client identifier |
| `CONTACT_DATE` | Date of the client contact |
| `APPT_MISSED`, `APPT_MISSED_REASON`, `APPT_MISSED_DETAILS` | Missed appointment indicators and details |
| `PROGRAM_WORKER_NUMBER`, `PROGRAM_WORKER_FIRST_NAME`, `PROGRAM_WORKER_LAST_NAME` | Assigned worker metadata |
| `CONTACT_TYPE_CODE`, `CONTACT_TYPE_DESCRIPTION` | Classification of the contact event |
| `CONTACT_WITH`, `CONTACT_INITIATED_BY` | Encounter context fields |
| `PROGRAM_CODE`, `PROGRAM_DESCRIPTION` | EPICC program enrollment metadata |
| `AGENCY_CODE`, `AGENCY_NAME` | Provider agency metadata |
| `LOCATION_CODE`, `LOCATION_DESCRIPTION` | Service location metadata |
| `OTHER_LOCATION`, `OTHER_ORGANIZATION` | Free‑text supplemental encounter details |

## Maintenance Notes

- **Enrollment Alignment**: Ensure `Q_PROVIDERPLACEMENT_BHN` continues to reflect accurate enrollment windows for EPICC program code `100006`.
- **Worker Metadata**: `Q_HRFORM` must maintain consistent employee number mappings for accurate worker attribution.
- **Contact Type Table**: Validate that `CONTACTTYPE` remains synchronized with operational definitions used by EPICC staff.
- **Provider & Location Tables**: Confirm that `Q_PROVIDER_BHN` and `SERVICESITE` remain authoritative sources for agency and site metadata.
- **Revision Filtering**: The view assumes `DOCREVNO = ' 0 '` indicates the current version; update if revision semantics change.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

- **2026-05-11**: Adds initial Markdown documentation.

</details>

</details>
<!---CHANGELOG-END--->
