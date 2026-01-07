---
front-matter-title: Q_ALL_PATHWAY_FORM_DOCSERNOS
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-all-pathway-form-docsernos.sql
last_updated: 2025-12-22
author: Bradley Wing
status: active
lifecycle: production
program_scope: multi
programs:
  - bcr
  - complex-care
  - epicc
  - ere
  - yere
tags:
  - sql-view
  - tag2
dependencies:
  - name: q-bcr-pathway-form-docsernos
    type: sql
    repo: famcare-sql-toolkit
  - name: q-epicc-pathway-form-docsernos
    type: sql
    repo: famcare-sql-toolkit
  - name: q-complex-care-pathway-form-docsernos
    type: sql
    repo: famcare-sql-toolkit
  - name: q-ere-pathway-form-docsernos
    type: sql
    repo: famcare-sql-toolkit
  - name: q-yere-pathway-form-docsernos
    type: sql
    repo: famcare-sql-toolkit
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-12-22
last_reviewed: 2025-12-22
schema_version: 1.0
---

# Q_ALL_PATHWAY_FORM_DOCSERNOS

## Purpose

Unions all `Q_FOO_PATHWAY_FORM_DOCSERNOS` views to allow for exception reporting that requires access to all Pathway Event Form `DOCSERNO` values and all `TIEDENROLLMENT` values.

## Description

- Consolidates `CLIENT_NUMBER`, `PATHWAY_DATE`, `DOCSERNO`, `TIEDENROLLMENT`, and `FORM_TYPE` values from Pathway Event Forms into a unified dataset.
- Uses `UNION ALL` to aggregate records from:
  - `Q_BCR_PATHWAY_FORM_DOCSERNOS`
  - `Q_COMPLEX_CARE_PATHWAY_FORM_DOCSERNOS`
  - `Q_EPICC_PATHWAY_FORM_DOCSERNOS`
  - `Q_ERE_PATHWAY_FORM_DOCSERNOS`
  - `Q_YERE_PATHWAY_FORM_DOCSERNOS`

### Logic Summary

- **Source Views:**
  - All Pathway Event form views listed above

- **Output Fields:**
  - `CLIENT_NUMBER`, `PATHWAY_DATE`, `DOCSERNO`, `TIEDENROLLMENT`, and `FORM_TYPE`

## Maintenance Notes

- If new program form types are introduced, extend the `UNION ALL` logic to include them.
- Ensure each source view definitions remain aligned.
- Consider indexing or materializing if used in high-volume reporting.

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

- **2025-12-22**: Adds initial view definition. Adds initial Markdown documentation.

</details>
</details>
