---
front-matter-title: Complex Care BEACN Has PfP Discharge But No Benchmark Enrollment View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-complex-care-beacn-has-pfp-discharge-but-no-benchmark-enrollment.sql
last_updated: 2026-01-20
status: active
lifecycle: production
program_scope: single
programs:
  - complex-care
tags:
  - view-layer
  - exception-logic
dependencies:
  - name: 
    type: 
    repo: 
  - name: 
    type: 
    repo: 
  - name: 
    type: 
    repo: 
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# Complex Care BEACN Has PfP Discharge But No Benchmark Enrollment View Definition

## Purpose

Identifies Complex Care enrollments where a PfP Discharge form exists **without** a corresponding Benchmark Enrollment record.  
This condition represents a data‑integrity exception: a participant should not receive a PfP Discharge unless they were fully enrolled (i.e., had a Benchmark Enrollment date).

This view supports exception monitoring, workflow cleanup, and governance validation for the Mercy Beacon Complex Care program.

## Description

This view performs the following steps:

- Extracts all Complex Care Roster enrollments from `Q_COMPLEX_CARE_PATHCLIENT_ENROLLMENTS`.
- Joins to `Q_COMPLEX_CARE_ROSTER` to retrieve cohort‑addition metadata.
- Left‑joins Benchmark Enrollment records from `Q_COMPLEX_CARE_MERCY_BEACN_BENCHMARKS`.
- Left‑joins PfP Discharge records from `Q_COMPLEX_CARE_PFP_DISCHARGE`.
- Flags cases where:
  - A PfP Discharge exists (`PFP_DISCHARGE_DATE` is not NULL), **and**
  - No Benchmark Enrollment exists (`ENROLLMENT_DATE` is NULL).

The result is one row per enrollment that violates the expected workflow sequence.

## SQL Definition

```sql
WITH CENROLL AS (
    SELECT
        CENROLL.CLIENT_NUMBER,
        CENROLL.ENROLLMENT_STARTING_DATE,
        CENROLL.ENROLLMENT_ENDING_DATE,
        CENROLL.DISMISSAL_REASON_DESCRIPTION,
        ROSTER.ADDED_COHORT_DATE,
        CENROLL.TIEDENROLLMENT AS CENROLL_TIEDENROLLMENT
    FROM Q_COMPLEX_CARE_PATHCLIENT_ENROLLMENTS AS CENROLL
    LEFT JOIN Q_COMPLEX_CARE_ROSTER AS ROSTER
        ON ROSTER.DOCSERNO = CENROLL.PWY_FORMS_DOCSERNO
    WHERE CENROLL.PWY_EVENT = 'Complex Care Roster'
),
BENCH AS (
    SELECT
        CBENCH.CLIENT_NUMBER,
        CBENCH.ENROLLMENT_DATE,
        CBENCH.TIEDENROLLMENT AS BENCH_TIEDENROLLMENT
    FROM Q_COMPLEX_CARE_MERCY_BEACN_BENCHMARKS AS CBENCH
),
DISCHARGE AS (
    SELECT
        PFPDISCHARGE.CLIENT_NUMBER,
        PFPDISCHARGE.PATHWAY_DATE,
        PFPDISCHARGE.PFP_DISCHARGE_DATE,
        PFPDISCHARGE.TIEDENROLLMENT AS PFPDISCHARGE_TIEDENROLLMENT
    FROM Q_COMPLEX_CARE_PFP_DISCHARGE AS PFPDISCHARGE
)
SELECT
    CENROLL.CLIENT_NUMBER,
    CENROLL.ENROLLMENT_STARTING_DATE,
    CENROLL.ENROLLMENT_ENDING_DATE,
    CENROLL.DISMISSAL_REASON_DESCRIPTION,
    CENROLL.ADDED_COHORT_DATE,
    CENROLL.CENROLL_TIEDENROLLMENT,
    BENCH.BENCH_TIEDENROLLMENT,
    DISCHARGE.PFPDISCHARGE_TIEDENROLLMENT,
    BENCH.ENROLLMENT_DATE,
    DISCHARGE.PFP_DISCHARGE_DATE
FROM CENROLL
LEFT JOIN BENCH
    ON BENCH.BENCH_TIEDENROLLMENT = CENROLL.CENROLL_TIEDENROLLMENT
LEFT JOIN DISCHARGE
    ON DISCHARGE.PFPDISCHARGE_TIEDENROLLMENT = CENROLL.CENROLL_TIEDENROLLMENT
WHERE CENROLL.CENROLL_TIEDENROLLMENT IS NOT NULL
    AND DISCHARGE.PFP_DISCHARGE_DATE IS NOT NULL
    AND BENCH.ENROLLMENT_DATE IS NULL;
```

## Output Fields

| Field | Description |
|-------|-------------|
| `CLIENT_NUMBER` | Client identifier |
| `ENROLLMENT_STARTING_DATE`, `ENROLLMENT_ENDING_DATE` | Episode window |
| `DISMISSAL_REASON_DESCRIPTION` | Reason for cohort exit |
| `ADDED_COHORT_DATE` | Date the client was added to the cohort |
| `CENROLL_TIEDENROLLMENT` | Enrollment episode key |
| `BENCH_TIEDENROLLMENT` | Benchmark episode key (NULL when missing) |
| `DISCHARGE_TIEDENROLLMENT` | PfP Discharge episode key |
| `ENROLLMENT_DATE` | Benchmark Enrollment date (NULL when missing) |
| `PFP_DISCHARGE_DATE` | PfP Discharge date |

## Usage Notes

- This view identifies **invalid workflow sequences** and should be monitored regularly.
- A missing Benchmark Enrollment typically indicates:
  - Staff skipped the Benchmark form, or
  - The Benchmark form was saved under the wrong enrollment.
- Records returned by this view should be reviewed and corrected in collaboration with program staff.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

- **2026-01-20**: Adds initial SQL view definition. Adds initial Markdown documentation file.

</details>
</details>
<!---CHANGELOG-END--->
