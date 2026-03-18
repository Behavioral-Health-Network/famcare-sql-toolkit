---
front-matter-title: Complex Care BEACN Shelter Bed Tracking View Definition
category: view-definitions
category-label: View Definitions
source_file: code/view-definitions/q-complex-care-beacn-shelter-bed-tracking.sql
last_updated: 2026-03-18
status: active
lifecycle: production
tags:
  - complex-care
  - shelter-bed-tracking
  - housing-support
program-scope: single
programs:
  - Complex Care
change_control:
  - cross-repo-coordination
  - data-model-impact
schema_version: 1.0
---

# Complex Care BEACN Shelter Bed Tracking View Definition

## Purpose

This view provides a normalized, reporting‑ready representation of BEACN Shelter Bed Tracking form submissions for clients enrolled in the Complex Care program. It consolidates shelter bed offer information, client decisions, and start/end dates of accepted stays, enabling downstream reporting on housing support utilization and service timelines.

## Description

This view:

- Selects form submissions from PWBEACNSHELTERBEDTRACKING.  
- Joins to `Q_COMPLEX_CARE_CLIENT` to ensure all records correspond to valid Complex Care clients.  
- Casts datetime fields to `DATE` for consistency across reporting assets.  
- Filters to `DOCREVNO = ' 0 '` to ensure only the current revision of each form is included.  
- Exposes key fields needed for operational reporting, including:
  - date offered  
  - decision (accepted/declined)  
  - start and end dates of shelter bed stays  
  - staff notes  

The view is used for program management reporting on shelter bed utilization patterns, track service timelines, and support grant reporting related to housing interventions.

## Output Fields

| Field Name                  | Description |
|-----------------------------|-------------|
| `ID`                        | Unique identifier for the shelter bed tracking form submission. |
| `DOCSERNO`                  | Document serial number for the form instance; used to group revisions. |
| `VISITDT`                   | Date the form was recorded in FAMCare (normalized to `DATE`). |
| `VISITTM`                   | Time the form was recorded in FAMCare. |
| `USERID`                    | Staff `USERID` of the person who submitted or last updated the form. |
| `PARENTDOCSERNO`            | Serial number of the parent document, linking this form to its associated Pathway Event. |
| `CLIENT_NUMBER`             | Unique BHN client identifier, joined from `Q_COMPLEX_CARE_CLIENT`. |
| `PATHWAY_DATE`              | Pathway date associated with the shelter bed tracking event. |
| `DATE_OFFERED_SHELTER_BED` | Date the shelter bed was offered to the client (may be `NULL`). |
| `DECISION_SHELTER_BED`      | Client’s decision regarding the shelter bed offer (e.g., accepted, declined). |
| `START_DATE_SHELTER_BED`    | Start date of the shelter bed stay if the offer was accepted. |
| `END_DATE_SHELTER_BED`      | End date of the shelter bed stay if applicable. |
| `NOTES_SHELTER_BED`         | Free‑text notes entered by staff regarding the shelter bed offer or stay. |

## Maintenance Notes

- Changes to `PWBEACNSHELTERBEDTRACKING` or `Q_COMPLEX_CARE_CLIENT` may require updates to this view.  
- `DATE_OFFERED_SHELTER_BED` may be `NULL` even when a stay occurred; `START_DATE_SHELTER_BED` is the authoritative indicator of an accepted bed.  
- `VISITDT` and `PATHWAY_DATE` are cast to `DATE` to avoid time‑based mismatches in downstream joins.  
- If BEACN shelter workflows evolve (e.g., new decision types, additional fields), this view should be updated to maintain alignment.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

- **2026-01-26**: Adds `INNER JOIN` to `Q_CLIENT_BHN`.

</details>

<details markdown="1">
  <summary><strong>2025</strong></summary>

### 2025

- **2025-12-12**: Adds initial Markdown documentation.
- **2025-11-24**: Adds initial view definition.

</details>
</details>
<!---CHANGELOG-END--->
