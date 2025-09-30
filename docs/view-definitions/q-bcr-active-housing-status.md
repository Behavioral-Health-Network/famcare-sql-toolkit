---
front-matter-title: Q_BCR_ACTIVE_HOUSING_STATUS
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-bcr-active-housing-status.sql
last_updated: 2025-08-09
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - bcr
tags:
  - view-layer
  - summation-view
  - slowly-changing-dimension
  - active-record-view
  - housing-status-data
dependencies:
  - name: q-bcr-all-housing-status
    type: sql
    repo: famcare-sql-toolkit
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

# Q_BCR_ACTIVE_HOUSING_STATUS

## Purpose

Consolidates active housing status data into a single row per client, providing a snapshot of the most recent and relevant housing status for each CLIENT_NUMBER. Supports accurate reporting and case management by excluding historical and test data.

## Description

- Built on top of `Q_BCR_ALL_HOUSING_STATUS`, which contains full housing status history including resolved parent form linkage.
- Includes only active housing statuses by filtering for the most recent `HOUSING_START_DATE` and valid `PARENT_DOCSERNO` values.
- Excludes test clients based on last name variants (`GVTTest`, `GVTest`, `GVTTEST`) from `Q_CLIENT_BHN`.
- Outputs pivoted housing status columns for easier reporting:
  - `HOUSING_STATUS_STABLY_HOUSED`
  - `HOUSING_STATUS_UNHOUSED`
  - `HOUSING_STATUS_PRECARIOUSLY_HOUSED`
  - `HOUSING_STATUS_INSTITUTIONALLY_HOUSED`
  - `HOUSING_STATUS_UNKNOWN`
- Includes additional fields relevant to FY25 reporting: visit date/time, user ID, and housing insecurity indicators.

### Logic Summary

- **[LATESTHOUSINGSTART]**  
  - Identifies the most recent `HOUSING_START_DATE` per client (`DOCREVNO = ' 0 '`).
- **[LATESTHOUSINGSTATUS]**  
  - Filters to records matching the latest start date and valid `PARENT_DOCSERNO` from `Q_BCR_PATHWAY_FORM_DOCSERNOS`.
- **[FINALSELECTION]**  
  - Selects the latest `PARENT_DOCSERNO` and `DOCSERNO` per client, resolving ties via `HOUSING_END_DATE` and `DOCSERNO`.
- **Final SELECT**  
  - Joins `LATESTHOUSINGSTATUS` with `FINALSELECTION` and `Q_CLIENT_BHN` to exclude test clients and output final fields.

## Maintenance Notes

- Changes to `Q_BCR_ALL_HOUSING_STATUS`, `Q_BCR_PATHWAY_FORM_DOCSERNOS`, or `Q_CLIENT_BHN` will affect this view.
- If new housing status types are introduced, update the `CASE` statements in the final `SELECT`.
- Test client exclusions rely on name variants—update filter logic if naming conventions change.

## Changelog

- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation.
- **2025-08-09**: Adds initial view definition.
