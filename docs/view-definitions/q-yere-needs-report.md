---
front-matter-title: YERE Needs Report View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-yere-needs-report.sql
last_updated: 2026-03-03
status: active
lifecycle: production
program_scope: single
programs:
  - yere
tags:
  - view-layer
  - client-needs
  - caregiver-needs
  - pathway-episode
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# YERE Needs Report View Definition

## Purpose

Aggregates caregiver and youth needs for the Youth ERE (YERE) program at the **episode-of-care** level. Supports program management reporting by summarizing the number of needs identified and the number connected to services for each enrollment.

## Description

- Produces **one row per enrollment** by joining aggregated needs data to `Q_YERE_PATHCLIENT_ENROLLMENTS`.
- Uses **PARENTDOCSERNO** as the episode key because YERE forms attach all child needs forms to a single parent form (Initial Assessment).
- Summarizes:
  - **Caregiver needs** from `Q_YERE_CAREGIVER_NEEDS`
  - **Youth needs** from `Q_YERE_CLIENT_NEEDS`
- Counts:
  - Needs identified (sum of NEED_* fields)
  - Needs connected (status = `'Referral/Assistance Provided; Connected'`)
- Filters to the YERE Initial Assessment event (`PWY_EVENT = 'YERE Initial Assessment'`).
- Filters to enrollment start dates on or after July 1, 2024.
- Excludes episodes without a parent form (`PWY_FORMS_DOCSERNO IS NOT NULL`).

### Logic Summary

- **Source Tables**
  - `Q_YERE_PATHCLIENT_ENROLLMENTS`
  - `Q_YERE_CAREGIVER_NEEDS`
  - `Q_YERE_CLIENT_NEEDS`

- **Joins**
  - `LEFT JOIN` caregiver and youth needs aggregates on `PARENTDOCSERNO = PWY_FORMS_DOCSERNO`.

- **Aggregation**
  - Caregiver and youth needs are grouped by `PARENTDOCSERNO`.
  - Each need category contributes 1 to the count when marked as `1`.
  - “Connected” counts are based on status fields equal to `'Referral/Assistance Provided; Connected'`.

## Output Fields

| Field | Description |
|-------|-------------|
| `CLIENT_NUMBER`, `CLIENT_LAST`, `CLIENT_FIRST` | Client identity |
| `ENROLLMENT_STARTING_DATE`, `ENROLLMENT_ENDING_DATE` | Episode window |
| `PROGRAM_WORKER_*` | Worker attribution |
| `CAREGIVER_NEEDS_IDENTIFIED`, `CAREGIVER_NEEDS_CONNECTED` | Aggregated caregiver needs |
| `YOUTH_NEEDS_IDENTIFIED`, `YOUTH_NEEDS_CONNECTED` | Aggregated youth needs |

## Usage Notes

- The view returns **one row per enrollment**, even when multiple needs forms exist, because staff are instructed to edit the original child form.
- `PARENTDOCSERNO` is a stable episode key for YERE due to the single-parent-form model.
- The view is designed for direct use in program management reporting.

## Maintenance Notes

- Update the list of need fields if YERE adds or removes need categories.
- Ensure all YERE form views remain filtered to `DOCREVNO = ' 0 '`.
- Monitor for changes in event naming conventions that may affect the `PWY_EVENT` filter.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog
<!---CHANGELOG-END--->
