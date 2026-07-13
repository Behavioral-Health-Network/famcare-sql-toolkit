---
front-matter-title: YERE Dismissals Report
category: Program Management Reports
source_file: code/program-management-reports/yere-followup-completion.sql
last_updated: 2026-07-07
status: active
lifecycle: production
program_scope: single
programs:
  - yere
tags:
  - program-management
  - follow-up
  - enrollment-tracking
dependencies:
  - Q_YERE_PATHCLIENT_ENROLLMENTS
  - Q_YERE_THREE_MONTH
  - Q_YERE_SIX_MONTH
change_control: value
schema_version: 1.0
---

# YERE Dismissals Report

## Purpose

Provides program managers with a consolidated view of Youth ERE (YERE) enrollments and their associated follow‑up milestones (Initial Assessment, 3‑Month, and 6‑Month).  
Supports monitoring of follow‑up completion, timeliness, and worker‑level caseload patterns.

## Description

This report:

- Starts from `Q_YERE_PATHCLIENT_ENROLLMENTS` to identify all YERE Initial Assessments with completed enrollments.
- Left‑joins the 3‑Month, and 6‑Month follow‑up forms by `TIEDENROLLMENT`.
- Allows filtering by:
  - Dismissal date range
  - Program worker
  - Enrollment start date (hard‑coded July 2025 forward)
- Returns one row per enrollment with the dates of each follow‑up milestone.

## SQL Definition

```sql
SELECT
    YENROLL.CLIENT_NUMBER,
    YENROLL.CLIENT_LAST,
    YENROLL.CLIENT_FIRST,
    YENROLL.ENROLLMENT_STARTING_DATE,
    YENROLL.ENROLLMENT_ENDING_DATE,
    YENROLL.DISMISSAL_REASON_DESCRIPTION,
    YENROLL.PROGRAM_WORKER_LAST,
    YENROLL.PROGRAM_WORKER_FIRST,
    YENROLL.AGENCY_DESCRIPTION,
    YENROLL.PATHWAY_DATE AS [IA_DATE],
    YTHREEM.PATHWAY_DATE AS [3_MONTH_DATE],
    YSIXM.PATHWAY_DATE AS [6_MONTH_DATE]
FROM BEHAVHEALT_LIVE.DBO.Q_YERE_PATHCLIENT_ENROLLMENTS AS YENROLL
LEFT JOIN BEHAVHEALT_LIVE.DBO.Q_YERE_THREE_MONTH AS YTHREEM
    ON YENROLL.TIEDENROLLMENT = YTHREEM.TIEDENROLLMENT
LEFT JOIN BEHAVHEALT_LIVE.DBO.Q_YERE_SIX_MONTH AS YSIXM
    ON YENROLL.TIEDENROLLMENT = YSIXM.TIEDENROLLMENT
WHERE YENROLL.PWY_EVENT = 'YERE Initial Assessment'
    AND YENROLL.ENROLLMENT_ENDING_DATE IS NOT NULL
    AND YENROLL.ENROLLMENT_STARTING_DATE >= '2025-07-01'
    AND (
        YENROLL.ENROLLMENT_ENDING_DATE >= '^^BEGINNING DISMISSAL DATE|DATEPICKER^^'
        OR '^^BEGINNING DISMISSAL DATE^^' = ''
    )
    AND (
        YENROLL.ENROLLMENT_ENDING_DATE <= '^^ENDING DISMISSAL DATE|DATEPICKER^^'
        OR '^^ENDING DISMISSAL DATE^^' = ''
    )
    AND (
        YENROLL.PROGRAM_WORKER_EMPLOYEE_NUMBER =
            '^^PROGRAM WORKER|SELECT DISTINCT HR.EMPLOYEENUMBER, HR.EMPLOYEENAME FROM Q_PROVIDERPLACEMENT_BHN AS PP INNER JOIN Q_HRFORM HR ON PP.PROGRAM_WORKER = HR.EMPLOYEENUMBER WHERE PP.PATHWAY = ''55320240807125033701'' AND PP.PROGRAM_WORKER IS NOT NULL ORDER BY HR.EMPLOYEENAME^^'
        OR '^^PROGRAM WORKER^^' = ''
    );
```

## Filters

- `BEGINNING DISMISSAL DATE`
- `ENDING DISMISSAL DATE`
- `PROGRAM WORKER`
- Enrollment start date is fixed at July 1, 2025 forward.

## Output Fields

| Field | Description |
|-------|-------------|
| `CLIENT_NUMBER`, `CLIENT_LAST`, `CLIENT_FIRST` | Client identity |
| `ENROLLMENT_STARTING_DATE`, `ENROLLMENT_ENDING_DATE` | Episode window |
| `PROGRAM_WORKER_*` | Worker attribution |
| `IA_DATE` | Initial Assessment date |
| `3_MONTH_DATE` | 3‑Month follow‑up date |
| `6_MONTH_DATE` | 6‑Month follow‑up date |

## Usage Notes

- Designed for program management dashboards and follow‑up compliance monitoring.
- Follow‑up forms are optional; missing dates indicate incomplete milestones.
- The worker filter dynamically populates based on the parent Change Scope form’s program.

<!---DEPENDENCIES-START--->
- `Q_YERE_PATHCLIENT_ENROLLMENTS`
- `Q_YERE_THREE_MONTH`
- `Q_YERE_SIX_MONTH`
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

- **2026-03-17**: Adds initial Markdown documentation file.
- **2026-07-07**: Removes the 30 day form join and the 30 day form column. This coincides with the removal of the 30 day form at the fiscal year date.

</details>

<details markdown="1">
  <summary><strong>2026</strong></summary>
  
### 2025

- **2025‑12‑17**: Initial SQL query.

</details>
</details>
<!---CHANGELOG-END--->
