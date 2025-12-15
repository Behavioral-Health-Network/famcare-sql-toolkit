---
front-matter-title: Q_ERE_CLIENT_NEEDS
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-ere-client-needs.sql
last_updated: 2025-08-09
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - ere
tags:
  - tag1
  - tag2
dependencies:
  - value1
  - value2
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# Q_ERE_CLIENT_NEEDS

## Purpose

View on summation form for client needs accessed from ERE milestone forms. The summation form supports real-time display of client needs history in embedded tables on each form, enabling longitudinal tracking and service engagement monitoring.

## Description

- Built on `PWERECLIENTNEEDS`, joined with `Q_CLIENT_BHN` for client metadata and test client exclusion.
- Each row represents a single client need record tied to a specific form (`DOCSERNO`) and reporting interval (`PARENTDOCSERNO`).
- Includes engagement and status tracking at three- and six-month intervals for each need type.
- Designed for reuse across multiple ERE forms, with consistent structure and naming.

### Logic Summary

- **Client Join**
  - Ensures valid client linkage via `Q_CLIENT_BHN`.
  - Excludes test clients based on naming conventions.

- **Need Categories**
  - Each need type includes:
    - Binary flag for need presence (e.g., `NEED_HOUSING`)
    - Referral/engagement status (e.g., `HOUSING_REFERRED_ENGAGED`)
    - Status at three and six months (e.g., `HOUSING_STATUS_THREE_MONTH`, `HOUSING_STATUS_SIX_MONTH`)

- **Form Metadata**
  - Includes `DOCSERNO`, `VISITDT`, `VISITTM`, `USERID`, and `PARENTDOCSERNO` for traceability.

## Output Fields

| Field Group        | Description |
|--------------------|-------------|
| `CLIENT_NUMBER`, `PATHWAY_DATE`, `DOCSERNO`, `PARENTDOCSERNO` | Form and reporting interval linkage |
| `CLIENT_NEEDS`, `NEED_*` fields | Binary indicators for each need type |
| `*_REFERRED_ENGAGED` | Referral or engagement status |
| `*_STATUS_THREE_MONTH`, `*_STATUS_SIX_MONTH` | Follow-up status tracking |
| `NEED_NONE` | Indicates no needs reported |

## Maintenance Notes

- **Need Expansion**: If new need types are introduced, add corresponding fields for referral and status tracking.
- **Field Naming Consistency**: Maintain consistent suffixes (`REFERRED_ENGAGED`, `STATUS_THREE_MONTH`, `STATUS_SIX_MONTH`) for auditability.
- **Test Client Filtering**: Ensure `Q_CLIENT_BHN` continues to exclude test clients based on last name variants.
- **Form Reusability**: Confirm that embedded tables on milestone forms correctly reference this view without duplication or logic bleed.

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

- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation.  
- **2025-08-04**: Adds initial view definition to support embedded client needs summary across ERE milestone forms.

</details>
</detials>
