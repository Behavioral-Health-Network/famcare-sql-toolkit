---
front-matter-title: Complex Care PFP Discharge Form View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-complex-care-pfp-discharge.sql
last_updated: 2025-12-22
status: active
lifecycle: production
program_scope: single
programs:
  - complex-care
tags:
  - view-layer
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# Complex Care PFP Discharge Form View Definition

## Purpose

Provide a clean, reporting‑ready representation of **PFP Discharge** form submissions for clients enrolled in the Complex Care program.  
This view standardizes date fields, exposes key discharge metadata, and ensures only the current revision of each form is included. It supports reporting on discharge activity, program exits, and downstream analytics related to PFP participation.

## Description

This view selects all current‑revision (`DOCREVNO = ' 0 '`) PFP Discharge forms from `PWPFPDISCHARGE` and exposes:

- client identifiers  
- discharge date and notes  
- pathway date  
- enrollment identifier (`TIEDENROLLMENT`)  
- metadata about the form submission (visit date/time, user, `DOCSERNO`, `PARENTDOCSERNO`)

Key logic elements:

- Normalizes `VISITDT` and `PFP_DISCHARGE_DATE` to `DATE` for consistency across reporting assets.  
- Retains `PARENTDOCSERNO` to support episode‑aware joins with other Complex Care forms.  
- Includes `TIEDENROLLMENT` to align discharges with enrollment episodes.  
- Returns one row per discharge form submission.

This view is used for program monitoring, discharge tracking, and validation of PFP workflow completion.

## Output Fields

| Field Name            | Description |
|-----------------------|-------------|
| `ID`                    | Unique identifier for the PFP discharge form submission. |
| `DOCSERNO`              | Document serial number for the form instance. |
| `VISIT_DATE`            | Date the form was recorded in FAMCare (normalized to DATE). |
| `VISITTM`               | Time the form was recorded in FAMCare. |
| `USERID`                | Staff user ID of the person who submitted or last updated the form. |
| `PARENTDOCSERNO`        | Serial number linking the discharge form to its parent Pathway Event. |
| `CLIENT_NUMBER`         | Unique BHN client identifier. |
| `PATHWAY_DATE`          | Pathway date associated with the discharge event. |
| `PFP_DISCHARGE_DATE`    | Date the client was discharged from PFP. |
| `PFP_DISCHARGE_NOTES`   | Free‑text notes entered by staff regarding the discharge. |
| `TIEDENROLLMENT`        | Unique identifier for the enrollment episode associated with the discharge. |

## Maintenance Notes

- This view depends on the structure of `PWPFPDISCHARGE`. Any changes to field names, discharge workflow, or form logic may require updates.
- `TIEDENROLLMENT` is critical for aligning discharges with enrollment episodes; if Complex Care modifies enrollment logic, this field should be reviewed.
- Only the current revision (`DOCREVNO = ' 0 '`) is included to avoid duplicate or outdated records.
- If new discharge reasons or fields are added to the form, the view should be updated to maintain alignment with reporting needs.

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
- **2025-11-12**: Adds initial view definition.

</details>
</details>
<!---CHANGELOG-END--->
