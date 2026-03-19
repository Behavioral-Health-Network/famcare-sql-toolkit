---
front-matter-title: Complex Care BEACN Quality of Life Assessment Form View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-complex-care-beacn-quality-of-life-assessment.sql
last_updated: 2025-12-11
status: active
lifecycle: production
program_scope: single
programs:
  - complex-care
tags:
  - view-layer
  - summation-view
  - slowly-changing-dimension
  - historical-record-view
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# Complex Care BEACN Quality of Life Assessment Form View Definition

## Purpose

Provide a clean, reporting‑ready representation of BEACN Quality of Life (QOL) Assessment form submissions for clients enrolled in the Complex Care program. This view standardizes date fields, exposes key QOL assessment metrics, and ensures only the current revision of each form is included. It supports longitudinal analysis of client well‑being, outcome tracking, and program evaluation.

## Description

This view selects all current‑revision (`DOCREVNO = ' 0 '`) BEACN QOL Assessment forms from `PWBEACNQOLSUM` and exposes:

- client identifiers  
- Pathway date  
- QOL assessment responses across general, physical, and mental health domains  
- frequency of health‑related interference with daily activities  
- free‑text notes  
- metadata about the form submission (visit date/time, user, `DOCSERNO`, `PARENTDOCSERNO`)

The view returns one row per QOL assessment form submission and is used for outcome monitoring, case review, and trend analysis across BEACN participants.

## Logic Summary

- **Source Table:**  
  `PWBEACNQOLSUM` (BEACN Quality of Life Assessment form)

- **Client Join:**  
  `INNER JOIN` to `Q_CLIENT_BHN` to remove test clients.

- **Filters:**  
  - `DOCREVNO = ' 0 '` to include only the current revision  
  - `VISITDT` and `PATHWAY_DATE` cast to `DATE` for consistency

- **Output:**  
  One row per QOL assessment form, including QOL metrics, Pathway date, client number, and metadata.

## Output Fields

| Field Name                  | Description |
|-----------------------------|-------------|
| `ID`                        | Internal record identifier for the QOL form submission. |
| `DOCSERNO`                  | Document serial number for the form instance. |
| `VISITDT`                   | Date the form was recorded in FAMCare (normalized to DATE). |
| `VISITTM`                   | Time the form was recorded in FAMCare. |
| `USERID`                    | Staff user ID of the person who submitted or last updated the form. |
| `PARENTDOCSERNO`            | Serial number linking the QOL form to its parent Pathway Event. |
| `CLIENT_NUMBER`             | Unique BHN client identifier. |
| `PATHWAY_DATE`              | Pathway date associated with the QOL assessment. |
| `GENERAL_HEALTH_QOL`        | Client’s self‑reported general health rating. |
| `PHYSICAL_HEALTH_QOL`       | Client’s self‑reported physical health rating. |
| `MENTAL_HEALTH_QOL`         | Client’s self‑reported mental health rating. |
| `POOR_HEALTH_INTERFERE_QOL` | Frequency with which poor physical or mental health interfered with daily activities. |
| `NOTES`                     | Free‑text notes entered by staff regarding the QOL assessment. |

## Maintenance Notes

- **Historical Scope:**  
  This view reflects point‑in‑time QOL assessments; it does not attempt to reconstruct historical values beyond what is stored in the form.

- **Slowly Changing Dimension Considerations:**  
  QOL assessments are inherently time‑stamped and should be treated as historical records. Downstream consumers should not assume a single “current” QOL value.

- **Program Scope:**  
  This form is specific to BEACN within Complex Care; if BEACN workflows expand or merge with other programs, the view may require updates.

- **Form Changes:**  
  If new QOL domains or response options are added to the form, the view should be updated to maintain alignment with reporting needs.

- **Data Quality:**  
  Missing or `NULL` QOL fields may indicate incomplete assessments; downstream logic should account for partial submissions.

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

- **2025-12-11**: Adds initial Markdown documentation.
- **2025-11-24**: Adds initial view definition to support BEACN quality of life reporting for Complex Care clients.

</details>
</details>
<!---CHANGELOG-END--->
