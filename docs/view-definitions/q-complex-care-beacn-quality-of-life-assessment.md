---
front-matter-title: Q_COMPLEX_CARE_BEACN_QUALITY_OF_LIFE_ASSESSMENT
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-complex-care-beacn-quality-of-life-assessment.sql
last_updated: 2025-12-11
author: Bradley Wing
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
dependencies:
  - name: pwbeacnqolsum
    type: html
    repo: famcare-html-form-code
  - name: pwbeacnqolsum
    type: table
    repo: none
  - name: q-client-bhn
    type: sql
    repo: famcare-sql-toolkit
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-11-24
last_reviewed: 2025-11-24
schema_version: 1.0
---

# Q_COMPLEX_CARE_BEACN_QUALITY_OF_LIFE_ASSESSMENT

## Purpose

## Description

### Logic Summary

- **Source Table:**
- **Client Join:**
- **Program Scope:**
- **Filters:**
- **Output:**

## Output Fields

| Field Name                          | Description |
|-------------------------------------|-------------|
| `ID`                                | Internal record identifier |
| `DOCSERNO`,                         | Document identifiers |
| `VISIT_DATE`, `VISITTM`, `USERID`   | Metadata for audit and traceability |
| `PARENT_DOCSERNO`                   | Parent form reference |
| `CLIENT_NUMBER`, `CLIENT_FIRST`, `CLIENT_LAST` | Client identifiers and names |
| `PATHWAY_DATE`                      | Date of pathway form |
| `GENERAL_HEALTH_QOL`                | Assessment of general health   |
| `PHYSICAL_HEALTH_QOL`               | Assessment of physical health   |
| `MENTAL_HEALTH_QOL`                 | Assessment of mental health   |
| `POOR_HEALTH_INTERFERE_QOL`         | Assessment of how frequently poor physical/mental health interfered with activities  |
| `NOTES`                             | Free text field for additional notes   |

## Maintenance Notes

- **Historical Scope:**
- **New Payor Types:**
- **Provider Tables:**
- **Program Scope:**

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
</detials>
