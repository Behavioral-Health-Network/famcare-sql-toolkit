---
front-matter-title: Q_ERE_IHNA
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-ere-ihna.sql
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
  - name: pwereihna
    type: html
    repo: famcare-html-form-code
  - name: pwereihna
    type: table
    repo: none
  - name: q-client-bhn
    type: sql
    repo: famcare-sql-toolkit
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# Q_ERE_IHNA

## Purpose

Supports ERE Individual Health Needs Assessment (IHNA) reporting by extracting client engagement, diagnostic history, and recent service utilization. Includes mental health, substance use, and physical health flags for comprehensive intake review and care coordination.

## Description

- Pulls structured data from the `PWEREIHNA` form.
- Joins with `Q_CLIENT_BHN` for client metadata and test client exclusion.
- Enriches employment status codes with descriptions via `EMPLOYMENTSTATUS`.

### Logic Summary

- **Source Table:**
  - `PWEREIHNA` (aliased as `IHNA`)

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client metadata and test client exclusion
  - `LEFT JOIN EMPLOYMENTSTATUS` for employment code descriptions

- **Key Filters:**
  - `DOCREVNO = ' 0 '` to isolate current records

- **Output Fields:**
  - Follow-up metadata: `VISITDT`, `USERID`, `PATHWAY_DATE`
  - Engagement: PPC contact result, ERE service status, ineligibility reason, ineligible status code
  - Employment: status code and description
  - Justice system: probation/parole flag
  - Diagnostic flags:
    - **Mental Health:** 20+ flags including depression, PTSD, schizophrenia, autism, and unknown/refused
    - **Substance Use:** 15+ flags including alcohol, opioids, synthetic drugs, and no use history
    - **Physical Health:** 10+ flags including diabetes, tobacco use, dental care, and no history
  - Service utilization: ER visits, hospitalizations, law enforcement contacts

## Maintenance Notes

- Monitor for changes in diagnostic flag definitions and ensure alignment with intake protocols.
- Consider surfacing diagnostic completeness flags or grouping logic for dashboard use.
- Align naming conventions with ERE 3-month and 6-month views for contributor clarity.

## Changelog

- **2025-09-30**: Adds `TIEDENROLLMENT` field to provide a DOCSERNO that may be used for joining to the PATHWAYCLIENT DOCSERNO directly.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation to support standardized view tracking.  
- **2025-07-22**: Adds initial view definition to support ERE IHNA reporting.
