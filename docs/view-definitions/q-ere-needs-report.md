---
front-matter-title: ERE Needs Report View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-ere-needs-report.sql
last_updated: 2026-03-17
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - ere
tags:
  - view-layer
  - client-needs
  - mental-health-history
  - substance-use-history
  - physical-health-history
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# ERE Needs Report View Definition

## Purpose

Summarizes mental health, substance use, physical health history, and client needs for the ERE program at the **episode-of-care** level. Supports program management reporting by providing counts of conditions and needs identified and connected.

## Description

- Produces **one row per enrollment** by joining aggregated history and needs data to `Q_ERE_PATHCLIENT_ENROLLMENTS`.
- Uses **CLIENT_NUMBER + TIEDENROLLMENT** as the episode key because ERE forms may attach child needs forms to multiple possible parent forms.
- Aggregates:
  - **IHNA history** (MH, SU, Physical) using detailed `*_HX_*` fields.
  - **Client needs** using `NEED_*` and `*_REFERRED_ENGAGED` fields.
- Counts:
  - History counts = number of selected conditions (sum of detailed flags).
  - Needs identified = number of NEED_* fields marked `'1'`.
  - Needs connected = number of `_REFERRED_ENGAGED` fields equal to `'ON'`.
- Filters to the IHNA event (`PWY_EVENT = 'ERE IHNA'`).
- Filters to enrollment start dates on or after July 1, 2024.

### Logic Summary

- **Source Tables**
  - `Q_ERE_PATHCLIENT_ENROLLMENTS`
  - `Q_ERE_IHNA`
  - `Q_ERE_CLIENT_NEEDS`

- **Joins**
  - `LEFT JOIN` IHNA and needs aggregates on `CLIENT_NUMBER` and `TIEDENROLLMENT`.

- **Aggregation**
  - IHNA history grouped by `CLIENT_NUMBER, TIEDENROLLMENT`.
  - Needs grouped by `CLIENT_NUMBER, TIEDENROLLMENT`.
  - Detailed history fields are varchar and normalized using `CASE WHEN col = '1' THEN 1 ELSE 0 END`.
  - `_REFERRED_ENGAGED` fields use `'ON'` to indicate connection.

## Output Fields

| Field | Description |
|-------|-------------|
| `CLIENT_NUMBER`, `CLIENT_LAST`, `CLIENT_FIRST` | Client identity |
| `ENROLLMENT_STARTING_DATE`, `ENROLLMENT_ENDING_DATE` | Episode window |
| `PROGRAM_WORKER_*` | Worker attribution |
| `MH_HISTORY_COUNT`, `SU_HISTORY_COUNT`, `PHYSICAL_HISTORY_COUNT` | IHNA history counts |
| `NEEDS_IDENTIFIED`, `NEEDS_CONNECTED` | Client needs summary |

## Usage Notes

- Staff are instructed to maintain **one child needs form per enrollment**, editing it across intervals.
- `TIEDENROLLMENT` is the authoritative episode key for ERE.
- `_REFERRED_ENGAGED` fields use `'ON'` rather than numeric flags; this view normalizes them.

## Maintenance Notes

- Update the list of IHNA history fields if the IHNA form changes.
- Update the list of need fields if ERE modifies the client needs form.
- Ensure all ERE form views remain filtered to `DOCREVNO = ' 0 '`.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

- **2026-03-17**: Refactors `N.PARENTDOCSERNO` as `N.PARENT_DOCSERNO` to reflect the renaming of `PARENTDOCSERNO` in `Q_ERE_CLIENT_NEEDS`.
- **2026-03-03**: Adds initial Markdown documentation.
- **2026-03-02**: Adds initial SQL query.

</details>
</details>
<!---CHANGELOG-END--->
