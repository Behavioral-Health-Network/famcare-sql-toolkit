---
front-matter-title: LINCS NAV Behavioral Health Service Form View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-lincs-nav-bhs.sql
last_updated: 2026-01-26
status: active
lifecycle: production
program_scope: single
programs:
  - lincs-nav
tags:
  - view-layer
  - exception-logic
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# LINCS NAV Behavioral Health Service Form View Definition

## Purpose

Provides a unified, analyst‑ready extract of **LINCS Navigator Behavioral Health Service** intakes and admissions. Supports program monitoring, care‑coordination workflows, and downstream reporting on intake, admission, reconnect, and transfer activity.

## Description

- Pulls raw behavioral health service events from `PWLINCSNAVBEHAVIORALHEALTHSERVICE`.
- Joins to `Q_CLIENT_BHN` to obtain the canonical `CLIENT_NUMBER`.
- Enriches agency‑coded fields (CMHC and ADA) with human‑readable descriptions.
- Normalizes all date fields using `CAST(... AS DATE)` for consistency across reporting tools.
- Restricts to the current revision of the form (`DOCREVNO = ' 0 '`).

### Logic Summary

- **Client Join**
  - Uses `CLIENTNUMBER` from the NAV table to join to `Q_CLIENT_BHN.CLIENT_NUMBER`.

- **Agency Lookups**
  - CMHC agencies (Reconnect, Intake, Admission) resolved via `BEHAVHEALT_LIVE.DBO.CMHC_AGENCY`.
  - ADA substance‑use agencies (Intake, Admission) resolved via `BEHAVHEALT_LIVE.DBO.ADA_SU_AGENCY`.
  - DM transfer agency resolved via `CMHC_AGENCY`.

- **Date Normalization**
  - Converts all NAV date fields to `DATE` to remove time components and ensure consistent reporting.

- **Event Labeling**
  - Hard‑codes `EVENT_NAME = 'LINCS NAV Behavioral Health Service'` for downstream grouping.

- **Revision Filter**
  - Includes only records where `DOCREVNO = ' 0 '`, ensuring analysts work with the active version of the form.

## Output Fields

Returns one row per behavioral health service encounter. Key fields include:

| Field Name | Description |
|------------|-------------|
| `ID`, `DOCSERNO` | Unique identifiers for the NAV record |
| `VISIT_DATE`, `VISIT_TIME` | Encounter date and time |
| `USERID` | Staff member who entered the record |
| `EVENT_NAME` | Constant label for event classification |
| `CLIENT_NUMBER` | Canonical client identifier from `Q_CLIENT_BHN` |
| `PATHWAY_DATE` | Date the pathway event occurred |
| `DATE_HOSPITAL_DISCHARGE` | Hospital discharge date, if applicable |
| `BEHAVIORAL_HEALTH_SERVICE_PATH` | Selected service pathway |
| `RECONNECT_TO_CMHC`, `MH_RECONNECT_AGENCY_CODE`, `MH_RECONNECT_AGENCY_DESCRIPTION` | Reconnect activity and agency details |
| `RECONNECTED_TO_DM3700`, `DM_TRANSFER_CODE`, `DM_TRANSFER_DESCRIPTION` | DM3700 transfer indicators and agency |
| `ATTEND_BH_INTAKE`, `MH_INTAKE`, `MH_INTAKE_AGENCY_CODE`, `MH_INTAKE_AGENCY_DESCRIPTION` | Mental health intake details |
| `MH_INTAKE_OTHER_AGENCY`, `MH_INTAKE_DATE` | Additional intake metadata |
| `SU_INTAKE`, `SU_INTAKE_AGENCY_CODE`, `SU_INTAKE_AGENCY_DESCRIPTION` | Substance‑use intake details |
| `SU_INTAKE_OTHER_AGENCY`, `SU_INTAKE_DATE` | Additional SU intake metadata |
| `ADMITTED_TO_SERVICES` | Indicates whether the client was admitted |
| `MH_ADMISSION`, `MH_ADMISSION_AGENCY_CODE`, `MH_ADMISSION_AGENCY_DESCRIPTION` | Mental health admission details |
| `MH_ADMISSION_OTHER_AGENCY`, `MH_ADMISSION_DATE` | Additional MH admission metadata |
| `SU_ADMISSION`, `SU_ADMISSION_AGENCY_CODE`, `SU_ADMISSION_AGENCY_DESCRIPTION` | Substance‑use admission details |
| `SU_ADMISSION_OTHER_AGENCY`, `SU_ADMISSION_DATE` | Additional SU admission metadata |
| `REASON_NOT_ADMITTED`, `NOT_ADMITTED_CAPACITY_LIM`, `NOT_ADMITTED_INELIGIBLE`, `NOT_ADMITTED_OTHER_REASON` | Non‑admission reasons and flags |

## Usage Notes

- **Agency Descriptions**: All agency codes are enriched with descriptions; downstream tools should use the description fields for reporting.
- **Date Consistency**: All dates are cast to `DATE` to avoid time‑based mismatches in Power BI or Excel.
- **Revision Filtering**: Only revision `' 0 '` is included; if additional revisions are introduced, update the filter accordingly.
- **Client Identity**: `CLIENT_NUMBER` is authoritative; NAV’s `CLIENTNUMBER` should not be used downstream.

## Maintenance Notes

- **Agency Tables**: CMHC and ADA agency tables must remain synchronized with NAV code sets; update joins if new agency tables are introduced.
- **Form Revisions**: Monitor `DOCREVNO` usage; if new revisions are deployed, consider versioning logic or including a `LATEST` filter.
- **Field Expansion**: NAV forms evolve frequently; review this view after form updates to ensure new fields are captured.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

- **2026‑01‑26**: Adds initial view definition for LINCS NAV Behavioral Health Service records. Adds initial Markdown documentation file for view definition.

</details>
</details>
<!-- CHANGELOG:END -->
