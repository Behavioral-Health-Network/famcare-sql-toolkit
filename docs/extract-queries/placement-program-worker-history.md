---
front-matter-title: Placement Program Worker History Extract Query
category: extract-queries
category-label: Extract Queries
source_file: code/extract-queries/placement-program-worker-history.sql
last_updated: '2025-01-21'
status: active
lifecycle: production
tags:
  - asset-function
program-scope: all
programs:
change_control: cross-repo-coordination
schema_version: 1.0
---

# Placement Program Worker History Extract Query

## Purpose

Provide a historical extract of program worker assignments for clients with placement records.  
This extract supports cross‑program analytics, audit review, and longitudinal workforce analysis by exposing every recorded change to a client’s assigned program worker, including start/end dates and change reasons.

The extract is designed for downstream use in dashboards, external analysis, and data integration workflows.

## Output Description

This query returns one row per **program worker assignment record** from the Placement Program Worker History table.  
Each row includes:

- client identifiers and demographics  
- program worker identifiers and names  
- the parent placement record (if available)  
- start and end dates of the assignment  
- coded and descriptive change reasons  
- metadata about the form submission (visit date/time, user, docserno)

All date fields are normalized to `DATE` for consistency across reporting assets.

## Output Fields

| Field Name                       | Description |
|----------------------------------|-------------|
| `ID`                             | Unique identifier for the worker history record. |
| `DOCSERNO`                       | Document serial number for the worker history form instance. |
| `VISITDT`                        | Date the form was recorded in FAMCare (normalized to DATE). |
| `VISITTM`                        | Time the form was recorded in FAMCare. |
| `USERID`                         | Staff user ID of the person who submitted or last updated the record. |
| `PP_DOCSERNO`                    | Document serial number of the associated provider placement record, if available. |
| `PARENT_DOCSERNO`                | Serial number linking the worker history record to its parent placement form. |
| `ENROLLMENT_STARTING_DATE`       | Date of program enrollment start. |
| `ENROLLMENT_ENDING_DATE`         | Date of program enrollment dismissal. |
| `CLIENT_NUMBER`                  | Unique BHN client identifier. |
| `CLIENT_LAST`                    | Client last name from Q_CLIENT_BHN. |
| `CLIENT_FIRST`                   | Client first name from Q_CLIENT_BHN. |
| `PROGRAM_WORKER_CODE`            | Employee number of the assigned program worker. |
| `PROGRAM_WORKER_LAST`            | Last name of the assigned program worker (from HRFORM). |
| `PROGRAM_WORKER_FIRST`           | First name of the assigned program worker (from HRFORM). |
| `BEGIN_DATE`                     | Start date of the program worker assignment. |
| `END_DATE`                       | End date of the program worker assignment, if applicable. |
| `CHANGE_REASON_CODE`             | Code representing the reason for the worker assignment change. |
| `CHANGE_REASON_DESCRIPTION`      | Human‑readable description of the change reason. |

## Maintenance Notes

- This extract depends on the stability of `PLACEMENTPROGRAMWORKERHISTORY`, `Q_PROVIDERPLACEMENT_BHN`, `Q_CLIENT_BHN`, `CHANGEREASON_BASE`, and `Q_HRFORM`. Any structural changes to these objects may require updates.
- Worker assignment history may include overlapping or adjacent date ranges depending on staff workflows; downstream consumers should apply business rules as needed.
- `PP_DOCSERNO` may be null when a worker history record exists without a corresponding placement record; this is expected for some legacy data.
- The extract filters to `DOCREVNO = ' 0 '` to ensure only the current revision of each form is included.
- If new change reason codes or worker assignment workflows are introduced, the extract should be reviewed for alignment.

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

- **2025-05-23**: Adds initial query.

</details>
</details>
<!---CHANGELOG-END--->
