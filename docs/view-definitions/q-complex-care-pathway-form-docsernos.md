---
front-matter-title: Complex Care Pathway Form DOCSERNOS View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-complex-care-pathway-form-docsernos.sql
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

# Complex Care Pathway Form DOCSERNOS View Definition

## Purpose

Unions all Pathway form `DOCSERNO` values to allow for joining to summations to identify intervals at which records have been added based on the Pathway Event of the parent forms.

## Description

- Consolidates DOCSERNO values from all Complex Care Pathway forms into a unified dataset.
- Uses `UNION ALL` to aggregate records from:
  - `Q_COMPLEX_CARE_ROSTER` (Complex Care Roster)
  - `Q_COMPLEX_CARE_MERCY_BEACN_BENCHMARKS` (Clinical BEACN Metrics)
  - `Q_COMPLEX_CARE_PFP_DISCHARGE` (PfP Discharge)
- Joins to `Q_CLIENT_BHN` to validate client existence and exclude test clients.
- Standardizes output fields:
  - `CLIENT_NUMBER`
  - `PATHWAY_DATE`
  - `DOCSERNO`
  - `TIEDENROLLMENT`
  - `FORM_TYPE`

### Logic Summary

- **Source Tables:**
  - All Complex Care form tables listed above

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client validation and test client exclusion

- **Output Fields:**
  - `CLIENT_NUMBER`, `PATHWAY_DATE`, `DOCSERNO`, `TIEDENROLLMENT`, `FORM_TYPE`

## Maintenance Notes

- If new Complex Care form types are introduced, extend the `UNION ALL` logic to include them.
- Ensure `Q_CLIENT_BHN` continues to exclude test clients to maintain data integrity.
- Consider indexing or materializing if used in high-volume reporting.

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

- **2025-12-22**: Adds field `TIEDENROLLMENT`.
- **2025-11-12**: Updates to include `DOCSERNO` values from `Q_COMPLEX_CARE_MERCY_BEACN_BENCHMARKS` and `Q_COMPLEX_CARE_PFP_DISCHARGE`
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-11**: Adds initial view definition. Adds initial Markdown documentation.

</details>
</details>
<!---CHANGELOG-END--->
