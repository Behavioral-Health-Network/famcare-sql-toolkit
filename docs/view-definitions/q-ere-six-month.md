---
front-matter-title: ERE Six Month View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-ere-six-month.sql
last_updated: 2025-12-17
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

# ERE Six Month View Definition

## Purpose

Supports ERE 6-month follow-up reporting by extracting client engagement, contact outcomes, and recent service utilization. Includes employment status metadata and filters out test clients and non-current records.

## Description

- Pulls structured data from the `PWERESIXMONTHFOLLOWUP` form.
- Joins with `Q_CLIENT_BHN` for client metadata and test client exclusion.
- Enriches employment status codes with descriptions via `EMPLOYMENTSTATUS`.

### Logic Summary

- **Source Table:**
  - `PWERESIXMONTHFOLLOWUP` (aliased as `ERESIXM`)

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client metadata and test client exclusion
  - `LEFT JOIN ERE_EMPLOY_STATUS` for employment code descriptions

- **Key Filters:**
  - `DOCREVNO = ' 0 '` to isolate current records

- **Output Fields:**
  - Follow-up metadata: `VISITDT`, `USERID`, `PATHWAY_DATE`
  - Engagement: ERE service status, ineligibility reason, PPC contact result
  - Employment: status code and description
  - Service utilization: ER visits, hospitalizations, law enforcement contacts

## Maintenance Notes

- Monitor for changes in employment status codes and ensure descriptions remain aligned.
- Consider surfacing diagnostic flags for ambiguous PPC contact results or missing engagement status.
- Align naming conventions with other ERE follow-up views for consistency.

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

- **2025-12-17**: Fixes `LEFT JOIN BEHAVHEALT_LIVE.DBO.ERE_EMPLOY_STATUS AS [EMPSTATUS]`. Previously, the GVT default master table `EMPLOYMENTSTATUS` had been joined by mistake.
- **2025-09-30**: Adds `TIEDENROLLMENT` field to provide a `DOCSERNO` that may be used for joining to the `PATHWAYCLIENT.DOCSERNO` directly.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation to support standardized view tracking.  
- **2025-07-22**: Adds initial view definition to support ERE 6-month follow-up reporting.

</details>
</details>
<!---CHANGELOG-END--->
