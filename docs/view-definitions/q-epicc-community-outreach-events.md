---
front-matter-title: EPICC Community Outreach Events View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-epicc-community-outreach-events.sql
last_updated: 2025-08-10
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

# EPICC Community Outreach Events View Definition

## Purpose

Provide a clean, reporting‑ready view of all **EPICC Community Outreach Events** recorded in FAMCare.  
This view standardizes date fields, exposes key event metadata, and joins to reference tables to support downstream reporting on outreach activities, materials distributed, and geographic coverage.

The view is used for program monitoring, grant reporting, and analysis of outreach engagement patterns.

## Description

This view selects all current‑revision (`DOCREVNO = ' 0 '`) Community Outreach Event forms from `PWEPICCCOMMUNITYOUTREACHEVENT` and enriches them with:

- client demographic information from `Q_CLIENT_BHN`  
- materials‑distributed descriptions from `EPICC_MATERIALS_DISTRIBUTED`  
- county descriptions from the `COUNTY` reference table  

Key logic elements:

- Normalizes `VISITDT` and `PATHWAY_DATE` to `DATE` for consistency across reporting assets.  
- Exposes all outreach event metadata, including event type, materials distributed, location details, and notes.  
- Includes latitude/longitude fields for geospatial analysis.  
- Retains both coded and “other” free‑text fields for event type and materials distributed.  

The view returns one row per outreach event form submission.

## Output Fields

| Field Name                                       | Description |
|--------------------------------------------------|-------------|
| `ID`                                             | Unique identifier for the outreach event form submission. |
| `DOCSERNO`                                       | Document serial number for the form instance. |
| `DOCREVNO`                                       | Document revision number; only revision `' 0 '` is included. |
| `VISIT_DATE`                                     | Date the form was recorded in FAMCare (normalized to `DATE`). |
| `VISITTM`                                        | Time the form was recorded in FAMCare. |
| `USERID`                                         | Staff `USERID` of the person who submitted or last updated the form. |
| `CLIENT_NUMBER`                                  | Unique BHN client identifier, if the event is associated with a client. |
| `COMMUNITY_OUTREACH_EVENT_TYPE`                  | Selected outreach event type code. |
| `COMMUNITY_OUTREACH_EVENT_TYPE_OTHER`            | Free‑text description when 'Other' is selected for event type. |
| `COMMUNITY_OUTREACH_MATERIALS_DISTRIBUTED`       | Code representing materials distributed during the event. |
| `COE_ED_MATERIALS`                               | Flag indicating whether educational materials were distributed. |
| `COE_FOOD_WATER`                                 | Flag indicating whether food or water was distributed. |
| `COE_HYGEINE_PRODUCTS`                           | Flag indicating whether hygiene products were distributed. |
| `COE_NALOXONE`                                   | Flag indicating whether naloxone was distributed. |
| `COE_TOILETRIES`                                 | Flag indicating whether toiletries were distributed. |
| `COE_OTHER`                                      | Flag indicating whether other materials were distributed. |
| `COMMUNITY_OUTREACH_MATERIALS_DISTRIBUTED_OTHER` | Free‑text description when “Other” materials were distributed. |
| `COMMUNITY_OUTREACH_LOCATION`                    | General location description for the outreach event. |
| `STREET`                                         | Street address of the outreach event, if recorded. |
| `CITY`                                           | City where the outreach event occurred. |
| `ZIP`                                            | ZIP Code where the outreach event occurred. |
| `LATITUDE`                                       | Latitude coordinate for geospatial mapping. |
| `LONGITUDE`                                      | Longitude coordinate for geospatial mapping. |
| `STATE`                                          | State where the outreach event occurred. |
| `COUNTY`                                         | County code for the outreach event location. |
| `PATHWAY_DATE`                                   | Pathway date associated with the outreach event. |
| `NOTES_COE`                                      | Free‑text notes entered by staff regarding the outreach event. |

## Maintenance Notes

- This view depends on the structure of `PWEPICCCOMMUNITYOUTREACHEVENT`, `Q_CLIENT_BHN`, `EPICC_MATERIALS_DISTRIBUTED`, and `COUNTY`. Any changes to these objects may require updates.
- Outreach events may or may not be associated with a client; `CLIENT_NUMBER` may be null for community‑wide events.
- If EPICC updates outreach event types, materials distributed codes, or location fields, the view should be reviewed for alignment.
- Latitude/longitude fields are passed through as‑is; downstream consumers should apply validation or geocoding rules as needed.
- Only the current revision (`DOCREVNO = ' 0 '`) is included to avoid duplicate or outdated records.

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

- **2025-12-12**: Adds initial Markdown documentation.
- **2025-10-14**: Adds initial view definition.

</details>
</details>
<!---CHANGELOG-END--->
