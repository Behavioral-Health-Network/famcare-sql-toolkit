---
front-matter-title: Complex Care BEACN Benchmarks Date Validation View Definition
category: View Definitions
source_file: code/view-definitions/complex-care-beacn-benchmark-date-validation.sql
last_updated: 2026-03-11
status: active
lifecycle: production
program-scope: single
programs:
  - complex-care
tags:
  - view-layer
  - exception-logic
dependencies:
change_control: value
schema_version: 1.0
---

# Complex Care BEACN Benchmarks Date Validation View Definition

## Purpose

This view definition identifies records in the Complex Care Mercy BEACN Benchmarks table where benchmark dates do not follow required sequencing or where required dates are missing. It ensures that referral, cohort, enrollment, and post‑enrollment milestones are recorded in a logical and operationally valid order. Records appear only when a date is missing, occurs earlier than allowed, or when post‑enrollment activity is documented without a valid enrollment date.

---

## Logic Summary

- **Required Dates:**
  - `ADDED_COHORT_DATE` and `FIRST_POST_REFERRAL_CONTACT_DATE` must always be present.
  - `ENROLLMENT_DATE` is required *only if* any post‑enrollment date is entered.

- **Sequencing Rules:**
  - `FIRST_POST_REFERRAL_CONTACT_DATE` ≥ `ADDED_COHORT_DATE`
  - If present, `ENROLLMENT_DATE` ≥ `ADDED_COHORT_DATE`
  - Each post‑enrollment date (if present) must be ≥ `ENROLLMENT_DATE`

- **Post‑Enrollment Fields:**
  - `NULL` values are allowed.
  - If a post‑enrollment field has a value, it must validate against `ENROLLMENT_DATE`.

- **Pathway Date:**
  - Required by the module but not validated for sequencing.

- **Exception Summary:**
  - Each exception is listed explicitly in a concatenated summary field.
  
---

## Usage Notes

- Use this report to review and correct date inconsistencies in BEACN Benchmark forms.
- A record appearing on the report indicates a required date is missing, a date is out of order, or post‑enrollment activity was entered without enrollment.
- Records with no post‑enrollment activity and no enrollment date are valid and will not appear.
- Corrections should be made directly in the client’s BEACN Benchmark form.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

- **2026-03-11**: Adds `CLIENT_LAST` and `CLIENT_FIRST` to enhance the usability of the report.
- **2026-01-28**: Changes exception report query to a view definition because the FAMCare Quick Reports editor will not respect the alias `B.FIRST_POST_REFERRAL_CONTACT_DATE AS [FIRST_POST_SELECTION_CONTACT_DATE]` in the output of the Quick Report. It rewrites the `CASE` statement such that the original column name is inserted into the exception message in the `EX_REFERRAL_CONTACT` and `EXCEPTION_SUMMARY` columns. SQL Server does not do this, so a view definition is the workaround.
- **2026-01-22**: Adds initial SQL query. Adds initial Markdown documentation file for the exception report.

</details>
</details>
<!---CHANGELOG-END--->
