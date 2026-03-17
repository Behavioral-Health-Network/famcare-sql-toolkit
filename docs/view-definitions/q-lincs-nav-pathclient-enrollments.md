---
front-matter-title: LINCS NAV Pathclient Enrollments View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-lincs-nav-pathclient-enrollments.sql
last_updated: 2026-01-26
status: active
lifecycle: production
program_scope: single
programs:
  - lincs-nav
tags:
  - view-layer
  - pathway-join-view
  - multi-join
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# LINCS NAV Pathclient Enrollments View Definition

## Purpose

Unifies LINCS Navigator referral and behavioral health service forms with Pathways Module enrollment and event metadata. Supports program management, workflow validation, and reporting on LINCS NAV activity within the Pathways framework.

## Description

- Consolidates **PROVIDERPLACEMENT** (PP) enrollment data with **PATHWAYCLIENT** (PC) attribution and **PATHWAYEVENTCLIENT** (PEC) event metadata.
- Uses the **canonical Pathways dual‑join logic** (DOCSERNO join + Start‑Date join) because **LINCS NAV forms do not yet implement `TIEDENROLLMENT`**.
- Joins LINCS NAV Referral and Behavioral Health Service forms using:
  - `CLIENT_NUMBER`
  - `PATHWAY_DATE = PEC.DATEACCOMPLISHED`
  - `EVENT_NAME = PE.SHORTDESCRIPTION`
- Includes program worker, agency, and event‑window metadata to support operational reporting.
- Filters to Pathway ID `55320240905123251861` (LINCS NAV).
- Filters all Pathways tables to `DOCREVNO = ' 0 '` to suppress legacy versions.
- Returns one row per Pathway Event per client.

### Why the Canonical Pathways Join Is Required

LINCS NAV forms **do not populate `TIEDENROLLMENT`**, so the standard ERE/YERE attribution logic cannot be used.  
This view therefore relies on the **canonical Pathways Module join pattern**:

1. **DOCSERNO Join**  
   - Preferred when `PROVIDERPLACEMENT.DOCSERNO = PATHWAYCLIENT.DOCSERNO`.

2. **Enrollment/Start Date Join**  
   - Fallback when DOCSERNO does not match (e.g., imported enrollments).

`COALESCE(PC_DOCSERNO.DOCSERNO, PC_START.DOCSERNO)` provides the authoritative enrollment‑to‑PathwayClient linkage.

### Logic Summary

- **Source Tables**
  - `PROVIDERPLACEMENT`, `PATHWAYCLIENT`, `PATHWAYEVENTCLIENT`, `PATHWAYEVENT`, `PATHWAY`
  - LINCS NAV form views: `Q_LINCS_NAV_REFERRAL`, `Q_LINCS_NAV_BHS`
  - Supporting tables: `Q_LINCS_NAV_CLIENT`, `Q_PROVIDER`, `Q_HRFORM`, `CLOSINGREASONS`

- **Joins**
  - `INNER JOIN Q_LINCS_NAV_CLIENT` for client identity and test‑client exclusion.
  - `LEFT JOIN PATHWAYCLIENT` twice (DOCSERNO and Start‑Date logic).
  - `LEFT JOIN PATHWAYEVENTCLIENT` using coalesced PC DOCSERNO.
  - `INNER JOIN PATHWAYEVENT` and `PATHWAY` for event metadata.
  - `LEFT JOIN` LINCS NAV forms using:
    - `CLIENT_NUMBER`
    - `PATHWAY_DATE = PEC.DATEACCOMPLISHED`
    - `EVENT_NAME = PE.SHORTDESCRIPTION`
  - `LEFT JOIN` HR and provider tables for worker and agency attribution.

- **Event‑Level Form Attribution**
  - `PWY_FORMS_DOCSERNO`, `PWY_FORMS_VISIT_DATE`, `PWY_FORMS_VISIT_TIME`, and `PATHWAY_DATE`
    are selected conditionally based on `PE.SHORTDESCRIPTION`:
    - `'LINCS NAV Referral'` → values from `NAVREF`
    - `'LINCS NAV Behavioral Health Service'` → values from `NAVBHS`

- **Event Window Metadata**
  - `EARLIEST_START_DATE`, `EVENT_START_DATE`, `EVENT_END_DATE`, `LATEST_END_DATE`
  - `PE_DATE_ACCOMPLISHED`, `DAYS_UNTIL_FORM_DUE`

## Output Fields

Returns one row per Pathway Event with LINCS NAV form enrichment. Key fields include:

| Field Name | Description |
|------------|-------------|
| `CLIENT_NUMBER`, `CLIENT_LAST`, `CLIENT_FIRST` | Client identity |
| `ENROLLMENT_STARTING_DATE`, `ENROLLMENT_ENDING_DATE` | Enrollment window |
| `PP_DOCSERNO`, `PC_DOCSERNO`, `PEC_PATHCLIENT_DOCSERNO` | Enrollment and Pathway attribution |
| `ENROLL_PATH_JOIN_SOURCE` | Indicates DOCSERNO vs Start‑Date join |
| `PWY_EVENT` | Pathway Event type |
| `PWY_FORMS_DOCSERNO` | DOCSERNO of the linked LINCS NAV form |
| `PWY_FORMS_VISIT_DATE`, `PWY_FORMS_VISIT_TIME` | Visit metadata from the form |
| `PATHWAY_DATE` | Pathway date from the form |
| `EARLIEST_START_DATE`, `EVENT_START_DATE`, `EVENT_END_DATE`, `LATEST_END_DATE` | Event window boundaries |
| `PE_DATE_ACCOMPLISHED` | Date the event was completed |
| `DAYS_UNTIL_FORM_DUE` | Days remaining until form deadline |
| `AGENCY_DESCRIPTION` | Provider agency |
| `PROGRAM_WORKER_EMPLOYEE_NUMBER`, `PROGRAM_WORKER_LAST`, `PROGRAM_WORKER_FIRST` | Worker attribution |

## Usage Notes

- **TIEDENROLLMENT is not used** because LINCS NAV forms do not populate it.  
  Analysts should rely on `PC_DOCSERNO` and `ENROLL_PATH_JOIN_SOURCE` for attribution.
- **Form‑to‑event alignment** depends on `PATHWAY_DATE = PEC.DATEACCOMPLISHED`.  
  If NAV forms begin using TIEDENROLLMENT in the future, this join should be updated.
- **Event filtering** is driven by Pathway ID `55320240905123251861`; ensure this remains the correct LINCS NAV Pathway.
- **Date casting** ensures consistent reporting across Power BI and Excel.

## Maintenance Notes

- If LINCS NAV forms begin populating `TIEDENROLLMENT`, update:
  - Form joins  
  - Attribution logic  
  - Consider adding `TIEDENROLLMENT_MATCH` similar to ERE/YERE.
- Monitor for changes in `PE.SHORTDESCRIPTION` values; these drive conditional form selection.
- Ensure all Pathways tables remain filtered to `DOCREVNO = ' 0 '`.
- Review form views (`Q_LINCS_NAV_REFERRAL`, `Q_LINCS_NAV_BHS`) after NAV form updates.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

- **2026‑01‑26**: Adds initial view definition. Adds initial Markdown documentation file for the view definition.

</details>
</details>
<!---CHANGELOG-END--->
