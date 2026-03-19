---
front-matter-title: ERE Behavioral Health Services Form View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-ere-bhs.sql
last_updated: 2025-09-30
status: active
lifecycle: production
program_scope: single
programs:
  - ere
tags:
  - view-layer
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# ERE Behavioral Health Services Form View Definition

## Purpose

Extracts and consolidates ERE behavioral health service data to enagble reporting on intake and admission status for clients on given enrollments.

## Description

- Extracts Behavioral Health Service form data used to track admission to behavioral health agencies for ERE clients.
- Focuses on documenting whether clients were admitted to services and which agencies facilitated those admissions.
- Includes metadata for:
  - Mental health and substance use admission flags
  - Agency codes and descriptions
  - Admission dates for both domains
- Joins to:
  - `Q_CLIENT_BHN` for client validation and test client exclusion
  - `CMHC_AGENCY` and `ADA_SU_AGENCY` for agency descriptions

### Logic Summary

- **Source Table:**
  - `PWEREBEHAVIORALHEALTHSERVICE`

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client metadata
  - `LEFT JOIN CMHC_AGENCY` for mental health agency descriptions
  - `LEFT JOIN ADA_SU_AGENCY` for substance use agency descriptions

- **Output Fields:**
  - `CLIENT_NUMBER`, `PATHWAY_DATE`, `DOCSERNO`, `EVENT_NAME`
  - Admission flags and agency codes/descriptions
  - Admission dates for mental health and substance use services

## Maintenance Notes

- If new agency codes are introduced, ensure lookup tables (`CMHC_AGENCY`, `ADA_SU_AGENCY`) are updated and joined appropriately.
- Monitor for changes in field naming or form structure that could affect output consistency.
- Confirm that `DOCREVNO = ' 0 '` remains the correct filter for current records.

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

- **2025-09-30**: Adds `TIEDENROLLMENT` field to provide a `DOCSERNO` that may be used for joining to the `PATHWAYCLIENT.DOCSERNO` directly.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-10**: Adds initial Markdown documentation.  
- **2025-07-22**: Adds initial view definition to support admission tracking for ERE behavioral health services.

</details>
</details>
<!---CHANGELOG-END--->
