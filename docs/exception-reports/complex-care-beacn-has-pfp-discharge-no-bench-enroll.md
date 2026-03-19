---
front-matter-title: Complex Care BEACN Has PfP Discharge No Bench Enroll Exception Report
category: Exception Reports
source_file: code/exception-reports/complex-care-beacn-has-pfp-discharge-no-bench-enroll.sql
last_updated: 2025-01-20
status: active
lifecycle: production
program-scope: single
programs:
  - complex-care
tags:
  - exception-logic
  - tag2
dependencies:
  - value1
  - value2
change_control: value
schema_version: 1.0
---

# Complex Care BEACN Has PfP Discharge No Bench Enroll Exception Report

## Purpose

Identifies Complex Care enrollments where a PfP Discharge form exists **without** a corresponding Benchmark Enrollment record.  
This condition represents a data‑integrity exception: a participant should not receive a PfP Discharge unless they were fully enrolled (i.e., had a Benchmark Enrollment date).

## Description

This report performs the following steps:

- Extracts all Complex Care Roster enrollments from `Q_COMPLEX_CARE_PATHCLIENT_ENROLLMENTS`.
- Joins to `Q_COMPLEX_CARE_ROSTER` to retrieve cohort‑addition metadata.
- Left‑joins Benchmark Enrollment records from `Q_COMPLEX_CARE_MERCY_BEACN_BENCHMARKS`.
- Left‑joins PfP Discharge records from `Q_COMPLEX_CARE_PFP_DISCHARGE`.
- Flags cases where:
  - A PfP Discharge exists (`PFP_DISCHARGE_DATE` is not NULL), **and**
  - No Benchmark Enrollment exists (`ENROLLMENT_DATE` is NULL).

The result is one row per enrollment that violates the expected workflow sequence.

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

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

- **2026-01-20**: Adds initial SQL query. Adds initial Markdown documentation file.

</details>

<details markdown="1">
  <summary><strong>2025</strong></summary>

### 2025

</details>
</details>
<!---CHANGELOG-END--->
