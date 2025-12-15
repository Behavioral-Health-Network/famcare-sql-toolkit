---
front-matter-title: Q_ERE_THREE_MONTH
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-ere-three-month.sql
last_updated: 2025-09-30
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
  - name: pwerethreemonthfollowup
    type: html
    repo: famcare-html-form-code
  - name: pwerethreemonthfollowup
    type: table
    repo: none
  - name: q-client-bhn
    type: view
    repo: famcare-sql-toolkit
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# Q_ERE_THREE_MONTH

## Purpose

Supports ERE 3-month follow-up reporting by extracting client engagement, contact outcomes, and recent service utilization. Includes employment status metadata and filters out test clients and non-current records.

## Description

- Pulls structured data from the `PWERETHREEMONTHFOLLOWUP` form.
- Joins with `Q_CLIENT_BHN` for client metadata and test client exclusion.
- Enriches employment status codes with descriptions via `EMPLOYMENTSTATUS`.

### Logic Summary

- **Source Table:**
  - `PWERETHREEMONTHFOLLOWUP` (aliased as `ERETHREEM`)

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client metadata and test client exclusion
  - `LEFT JOIN EMPLOYMENTSTATUS` for employment code descriptions

- **Key Filters:**
  - `DOCREVNO = ' 0 '` to isolate current records

- **Output Fields:**
  - Follow-up metadata: `VISITDT`, `USERID`, `PATHWAY_DATE`, `PARENTDOCSERNO`
  - Engagement: ERE service status, ineligibility reason, PPC contact result
  - Employment: status code and description
  - Service utilization: ER visits, hospitalizations, law enforcement contacts

## Maintenance Notes

- Ensure field naming remains aligned with six-month view for audit and contributor clarity.
- Consider surfacing diagnostic flags for missing engagement status or ambiguous PPC contact results.
- Monitor for changes in employment status codes and update descriptions accordingly.

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

- **2025-09-30**: Adds `TIEDENROLLMENT` field to provide a DOCSERNO that may be used for joining to the PATHWAYCLIENT DOCSERNO directly.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation to support standardized view tracking.  
- **2025-07-22**: Adds initial view definition to support ERE 3-month follow-up reporting.

</details>
</details>
