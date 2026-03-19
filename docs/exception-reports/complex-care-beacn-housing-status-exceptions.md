---
front-matter-title: Complex Care BEACN Housing Status Exceptions
category: Exception Reports
source_file: code/exception-reports/complex-care-beacn-housing-status-exceptions.sql
last_updated: 2025-01-20
status: active
lifecycle: production
program-scope: single
programs:
  - complex-care
tags:
  - exception-logic
  - tag2
change_control: value
schema_version: 1.0
---

# Complex Care BEACN Housing Status Exceptions

## Purpose

This exception report produces an **exception report** for Complex Care BEACN participants whose housing status entries do not follow required business rules. The program requires:

- A **baseline housing status** recorded on the exact PfP Enrollment Date  
- A **monthly follow‑up entry** for each subsequent month  
- Each follow‑up must use the **first day of the month** as the `HOUSING_START_DATE`  
- Tracking continues until the earliest of:
  - Program discharge  
  - **20 months** after enrollment  
  - Current system date  

The exception report identifies missing, misaligned, early, or duplicate entries so program managers can follow up with partner agencies and correct data entry issues.

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

A `CROSS APPLY` in the underlying view collects all applicable exception labels into a semicolon‑delimited list.  
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

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!-- CHANGELOG:START -->
## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

- **2026-01-21**: Adds initial SQL query. Adds initial Markdown documentation file for the exception report.

</details>

<details markdown="1">
  <summary><strong>2025</strong></summary>

### 2025

</details>
</details>
<!-- CHANGELOG:END -->
