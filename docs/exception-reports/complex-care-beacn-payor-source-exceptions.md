---
front-matter-title: Complex Care BEACN Payor Source Exceptions
category: Exception Reports
source_file: code/exception-reports/complex-care-beacn-payor-source-exceptions.sql
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

# Complex Care BEACN Payor Source Exceptions

## Purpose

This exception report identifies missing, misaligned, or duplicate payor source entries for Complex Care BEACN participants. The business rule requires:

- A baseline payor source recorded on the exact PfP Enrollment Date (`CBENCH.ENROLLMENT_DATE`)
- A monthly follow‑up entry for each subsequent month
- Each follow‑up must use the first day of the month as the `PAYOR_SOURCE_START_DATE`
- Tracking continues until discharge or 20 months, whichever comes first
- The summation allows for more than one payor source to be recorded as active at any one time, which is different from the housing status summation business rule. In practice, PfP has only recorded on payor source, so this may not be an issue, but this is something to watch for

This report surfaces all deviations from those rules so program managers can follow up with partner agencies and correct data entry issues.

---

## Logic Summary

1. Expected Month Generation - For each qualifying enrollment:
   - **Month 0** = exact PfP Enrollment Date
   - **Month 1+** = first day of each subsquent month (must use `MONTH(DATEADD(MONTH, EM.MONTH_INDEX + 1, EM.PFP_ENROLLMENT_DATE))`  in the `WHERE` clause to roll back to the month ceiling date).
   - **Stop** at the earliest of:
     - Program discharge date
     - 20 months after enrollment
     - Current system date (furture months excluded)
2. Actual Entry Matching - For each expected month, the query attempts two matches:
   - **Aligned entry**: `PAYOR_SOURCE_START_DATE = EXPECTED DATE`
   - **Month-level entry**: `PAYOR_SOURCE_START_DATE` within the same calendar month
3. Exception Detection – The following exception flags are computed:

   | Exception Type           | Meaning                                                     |
   |--------------------------|-------------------------------------------------------------|
   | Missing                  | No payor source entry exists for the expected month              |
   | Misaligned               | Entry exists in the month but not on the expected date      |
   | Baseline Misaligned      | Baseline month has an entry, but not on the enrollment date |
   | Baseline Early Entry     | Entry predates the enrollment date                          |
   | Duplicate                | More than one entry exists in the same month                |

4. Exception Category - A `CROSS APPLY` in the underlying view assembles all applicable exception labels into a single delimited list. Only rows with at least one exception are returned.

## Exception Rules (Examples)

### Clean Row

- `ALIGNED_ENTRY_DATE` = '2025‑04‑01'
- `MONTH_MISALIGNED_ENTRY_DATE` = `NULL`
- `MISALIGNED_DATE` = 0
- `MISSING_ENTRY` = 0
- `DUPLICATE_ENTRIES` = 0

### Misaligned Row

- `ALIGNED_ENTRY_DATE` = `NULL`
- `MONTH_MISALIGNED_ENTRY_DATE` = '2025‑04‑21'
- `MISALIGNED_DATE` = 1
- `MISSING_ENTRY` = 0
- `DUPLICATE_ENTRIES` = 0

### Missing Row

- `ALIGNED_ENTRY_DATE` = `NULL`
- `MONTH_MISALIGNED_ENTRY_DATE` = `NULL`
- `MISALIGNED_DATE` = 0
- `MISSING_ENTRY` = 1
- `DUPLICATE_ENTRIES` = 0

### Baseline Misalignment

- `ALIGNED_ENTRY_DATE` = `NULL`
- `MONTH_MISALIGNED_ENTRY_DATE` = '2025‑03‑27'
- `BASELINE_MISALIGNED` = 1
- `MISSING_ENTRY` = 0
- `DUPLICATE_ENTRIES` = 0

### Duplicate: One Aligned, One Misaligned

- `ALIGNED_ENTRY_DATE` = '2025‑04‑01'
- `MONTH_MISALIGNED_ENTRY_DATE` = '2025‑04‑21'
- `MISALIGNED_DATE` = 1
- `MISSING_ENTRY` = 0
- `DUPLICATE_ENTRIES` = 1

### Duplicate: Two Aligned Entries

- `ALIGNED_ENTRY_DATE` = '2025‑04‑01'
- `MONTH_MISALIGNED_ENTRY_DATE` = '2025‑04‑01'
- `MISALIGNED_DATE` = 0
- `MISSING_ENTRY` = 0
- `DUPLICATE_ENTRIES` = 1

### Duplicate: Two Misaligned Entries

- `ALIGNED_ENTRY_DATE` = `NULL`
- `MONTH_MISALIGNED_ENTRY_DATE` = '2025‑04‑15'
- `MISALIGNED_DATE` = 1
- `MISSING_ENTRY` = 0
- `DUPLICATE_ENTRIES` = 1

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
