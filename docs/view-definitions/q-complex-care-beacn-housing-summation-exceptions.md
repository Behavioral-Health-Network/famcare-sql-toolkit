---
front-matter-title: Complex Care Housing Summation Exceptions View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-complex-care-beacn-housing-summation-exceptions.sql
last_updated: 2026-03-17
status: active
lifecycle: production
program_scope: single
programs:
  - complex-care
tags:
  - sql-view
  - exception-report
  - summation-view
dependencies:
  - name: q-complex-care-pathclient-enrollments
    type: sql
    repo: famcare-sql-toolkit
  - name: q-complex-care-mercy-beacn-benchmarks
    type: sql
    repo: famcare-sql-toolkit
  - name: q-complex-care-all-housing-status
    type: sql
    repo: famcare-sql-toolkit
  - name: q-client-bhn
    type: sql
    repo: famcare-sql-toolkit
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# Complex Care Housing Summation Exceptions View Definition

## Purpose

This view produces an **exception report** for Complex Care BEACN participants whose housing status entries do not follow required business rules. The program requires:

- A **baseline housing status** recorded on the exact PfP Enrollment Date  
- A **monthly follow‑up entry** for each subsequent month  
- Each follow‑up must use the **first day of the month** as the `HOUSING_START_DATE`  
- Tracking continues until the earliest of:
  - Program discharge  
  - **20 months** after enrollment  
  - Current system date  

The view identifies missing, misaligned, early, or duplicate entries so program managers can follow up with partner agencies and correct data entry issues.

---

## Description

The logic is built on four primary sources:

- `Q_COMPLEX_CARE_PATHCLIENT_ENROLLMENTS` – enrollment episodes and discharge dates  
- `Q_COMPLEX_CARE_MERCY_BEACN_BENCHMARKS` – PfP enrollment date and benchmark metadata  
- `Q_COMPLEX_CARE_ALL_HOUSING_STATUS` – actual housing status entries  
- `Q_CLIENT_BHN` – client demographics  

The view:

1. Identifies qualifying enrollment episodes with a valid PfP Enrollment Date.  
2. Computes a **STOP_DATE** = min(discharge, enrollment + 20 months, today).  
3. Generates expected months:
   - Month 0 = exact PfP Enrollment Date  
   - Month 1+ = first day of each subsequent month  
   - Stops at STOP_DATE  
4. Matches expected months to actual entries:
   - Exact‑date match  
   - Month‑level match (same year + same month)  
5. Computes exception flags:
   - Missing  
   - Misaligned  
   - Baseline Misaligned  
   - Baseline Early Entry  
   - Duplicate  
6. Uses `CROSS APPLY` to assemble exception labels.  
7. Returns only rows with at least one exception, aggregated via `STRING_AGG`.

---

## Logic Summary

### 1. Enrollment and Boundaries

- Selects Complex Care BEACN enrollments with a valid PfP Enrollment Date.  
- Computes:
  - `MAX_20_MONTH_DATE` = enrollment + 20 months  
  - `STOP_DATE` = earliest of discharge, 20‑month limit, or today  

### 2. Expected Month Generation

- Month 0 uses the exact PfP Enrollment Date.  
- Subsequent months use:

```sql
DATEFROMPARTS(YEAR(DATEADD(MONTH, n, enrollment)),
MONTH(DATEADD(MONTH, n, enrollment)),
1)
```

- Recursion stops when the next expected month exceeds STOP_DATE or today.

### 3. Actual Entry Matching

- **Aligned Entry**: `HOUSING_START_DATE = EXPECTED_DATE`  
- **Month‑Level Entry**: any entry in the same calendar month  

### 4. Exception Detection

| Exception Type | Meaning |
|----------------|---------|
| **Missing** | No housing entry exists for the expected month |
| **Misaligned** | Entry exists in the month but not on the expected date |
| **Baseline Misaligned** | Baseline month has an entry, but not on the enrollment date |
| **Baseline Early Entry** | Entry predates the PfP Enrollment Date |
| **Duplicate** | More than one entry exists in the same month |

### 5. Exception Category Assembly

A `CROSS APPLY` collects all applicable exception labels into a semicolon‑delimited list.  
Only rows with at least one exception are returned.

---

## Exception Rules (Examples)

### Clean Row

- `ALIGNED_ENTRY_DATE` = '2025‑04‑01'  
- `MONTH_MISALIGNED_ENTRY_DATE` = `NULL`  
- No exceptions  

### Misaligned Row

- Entry exists in month but not on expected date  
- `MISALIGNED_DATE = 1`  

### Missing Row

- No entry in the entire month  
- `MISSING_ENTRY = 1`  

### Baseline Misalignment

- Baseline month has an entry but not on enrollment date  
- `BASELINE_MISALIGNED = 1`  

### Baseline Early Entry

- Entry predates PfP Enrollment Date  
- `BASELINE_EARLY_ENTRY = 1`  

### Duplicate Entries

- More than one entry in the same month  
- `DUPLICATE = 1`  

---

## Output Fields

| Field Name | Description |
|------------|-------------|
| `CLIENT_NUMBER` | Unique client identifier |
| `CLIENT_LAST`, `CLIENT_FIRST` | Client name |
| `TIEDENROLLMENT` | Episode identifier |
| `BENCHMARK_DOCSERNO` | Benchmark document identifier |
| `EXPECTED_DATE` | Expected housing entry date |
| `MONTH_INDEX` | 0 = baseline, 1–20 = follow‑ups |
| `ALIGNED_ENTRY_DATE` | Exact‑date match |
| `CLIENT_HOUSING_STATUS` | Housing status used for comparison |
| `MONTH_MISALIGNED_ENTRY_DATE` | Month‑level match |
| `MISSING_ENTRY` | 1 if no entry exists for the month |
| `MISALIGNED_DATE` | 1 if entry exists but not on expected date |
| `BASELINE_MISALIGNED` | 1 if baseline entry exists but wrong date |
| `BASELINE_EARLY_ENTRY` | 1 if entry predates enrollment |
| `EXCEPTION_CATEGORY` | Semicolon‑delimited list of exception labels |

---

## Maintenance Notes

- **Business Rules:** Confirm that BEACN housing status requirements remain aligned with PfP Enrollment Date logic.  
- **Discharge Handling:** STOP_DATE logic must continue to use the earliest of discharge, 20‑month limit, or today.  
- **Form Updates:** If new housing status fields are added, update the `ACTUAL` CTE accordingly.  
- **Duplicate Logic:** Duplicate detection relies on month‑level grouping; ensure no schema changes break this.  
- **Episode Integrity:** Always join on `BENCHMARK_DOCSERNO` and `TIEDENROLLMENT` to avoid cross‑episode contamination.

---

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
<summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
<summary><strong>2026</strong></summary>

### 2026‑03‑17

- Updates documentation to reflect 20‑month window and CROSS APPLY exception assembly.
- Aligns documentation with updated SQL logic for month‑ceiling generation and baseline early‑entry detection.

</details>

<details markdown="1">
<summary><strong>2025</strong></summary>

### 2025

- **2025-12‑12**: Adds CTEs `MONTHLYCOUNTS` and `MULTIPLEENTRIES` to count instances where a client has more than one `HOUSING_START_DATE` in the same month and then flags as the exception `HAS_MULTIPLE_ENTRIES`.
- **2025‑12‑09**: Adds initial view definition to support exception reporting on housing status entry for Complex Care clients. Adds initial Markdown documentation.

</details>
</details>
<!---CHANGELOG-END--->
