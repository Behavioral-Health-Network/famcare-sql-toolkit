---
front-matter-title: EPICC EMS Report
category: Program Management Reports
source_file: code/program-management-reports/epicc-ems-report.sql
last_updated: 2025-08-06
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - epicc
tags: [value1, value2]
dependencies:
  - value1
  - value2
change_control: value
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# EPICC EMS Report

## Purpose

Returns EPICC referrals for clients referred by EMS/Fire Protection Districts (`EPICC_REFERRING_AGENCY_CODE = '073'`) or those whose referrals included EMS involvement (`EMS_INVOLVED_REF = 'Yes'`). The report supports compliance tracking, audit review, and operational decision-making by surfacing key EMS referral data.

It includes:

- Demographic details  
- Enrollment dates  
- Latest housing status  
- Active payor sources  
- Referral disposition and program participation at the Initial Contact stage

## Logic Summary

- Filters for `PWY_EVENT LIKE 'EPICC%'`  
- Includes referrals with EMS involvement or agency code `'073'`  
- Calculates age at referral using `PATHWAY_DATE` and `BIRTH_DATE`  
- Displays program participation for both referral and initial contact events  
- Integrates latest housing and payor source data via LEFT JOINs  
- Supports optional date filtering via two parameters:  
  - `^^BEGINNING ENROLLMENT START DATE|DATEPICKER^^`  
  - `^^ENDING ENROLLMENT START DATE|DATEPICKER^^`  
- Filtering is applied to `ENROLLMENT_STARTING_DATE` only  
- Uses `HAVING` clause to exclude records with no referral program participation

## Usage Notes

- Uncomment the date filtering block before saving to FAMCare  
- Ensure parameter names match exactly:  
  - `^^BEGINNING ENROLLMENT START DATE|DATEPICKER^^`  
  - `^^ENDING ENROLLMENT START DATE|DATEPICKER^^`  
- Report may return multiple rows per client if multiple events are present  
- Intended for internal program management and EMS referral tracking

## Maintenance Notes

- All logic changes should be documented in the changelog below  
- When updating filters or joins, ensure `GROUP BY` and `HAVING` clauses remain aligned  
- Review EMS-related fields for completeness and consistency across referral sources

## Changelog

- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-08**: Adds initial Markdown documentation.
- **2025-08-06**: Changes FAMCare Quick Report parameters to use `DATEPICKER` for enrollment start dates; removed enrollment end date parameter  
- **2025-07-17**: Updates parameters to allow blank values and renamed START RANGE to START DATE  
- **2025-07-17**: Addes EMS involvement logic for hospital referrals  
- **2025-07-16**: Addes filtering for agency code `'073'` (EMS/Fire District)  
- **2025-07-08**: Adds initial SQL query.  
