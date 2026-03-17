---
front-matter-title: Complex Care BEACN Benchmarks Date Validation Exception Report
category: Exception Reports
source_file: code/exception-reports/complex-care-beacn-bench-date-validation.sql
last_updated: 2026-01-28
status: active
lifecycle: production
program_scope: single
programs:
  - complex-care
tags:
  - exception-logic
dependencies:
  - value1
  - value2
change_control: value
schema_version: 1.0
---

# Complex Care BEACN Benchmarks Date Validation Exception Report

This exception report identifies records in the Complex Care Mercy BEACN Benchmarks table where benchmark dates do not follow required sequencing or where required dates are missing. It ensures that referral, cohort, enrollment, and post‑enrollment milestones are recorded in a logical and operationally valid order. Records appear only when a date is missing, occurs earlier than allowed, or when post‑enrollment activity is documented without a valid enrollment date.

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

- **2026-01-28**: Adds initial SQL query. Adds initial Markdown documentation for the exception report.
<!---CHANGELOG-END--->
