---
front-matter-title: ERE Hospital Visit Note Report Program Management Report
category: program-management-reports
category-label: Program Management Reports
source_file: code/program-management-reports/ere-hospital-visit-report.sql
last_updated: 2026-03-25
author: Bradley
status: active
lifecycle: production
tags:
  - 
  - 
  - 
program-scope: single
programs:
  - yere
change_control: internal-review-required
schema_version: 1.0
---

# ERE Hospital Visit Report Program Management Report

## Purpose

This report supports program management on documentation of hospital visit notes by ERE program staff by linking client enrollments to data on referring agency and location of person making the referral and initial hospital visit notes.

## Key Metrics

- Client enrollment start and end dates.
- Referral event date and referring hospital details.
- Initial hospital visit date and time.
- Program worker (last/first name and employee number).
- Reasons for no hospital visit or non–face-to-face contact.

## Filters

- **Hospital Visit Date Range:** Optional start and end date parameters.  
  - Start date only → returns records from that date forward.  
  - End date only → returns records up to that date.  
  - Both dates → returns records within the range.  
  - Blank → returns all records.
- **Program Worker:** Optional parameter to filter by employee number (dropdown displays names).  
- **Referral Event:** Restricted to enrollments with `PWY_EVENT = 'ERE Referral'`.

## Usage Notes

- Parameters are optional; leaving all blank returns all rows.  
- The hospital visit join is left outer, so enrollments without a hospital note are still included.  
- Designed for program staff to monitor referral-to-hospital transitions and worker assignments.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

- **2026-03-25**: Fixes `EREENROLL.PROGRAM_WORKER_EMPLOYEE_NUMBER` parameter by replacing the YERE `PP.PATHWAY` ID with the ERE `PP.PATHWAY` ID.
- **2025-12-16**: Adds initial query linking enrollments, referrals, and hospital visits. Adds Markdown documentation file.
<!---CHANGELOG-END--->
