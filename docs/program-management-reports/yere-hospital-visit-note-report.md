---
front-matter-title: yere-referral-hospital-visit-report
category: program-management-reports
category-label: Program Management Reports
source_file: code/program-management-reports/yere-referral-hospital-visit-report.sql
last_updated: 2026-07-07
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
dependencies:
  - name: q-yere-pathclient-enrollments
    type: view
    repo: FAMCare-SQL-Toolkit
  - name: pwyerereferral
    type: html
    repo: famcare-html-form-code
  - name: pwyerereferral
    type: table
    repo: none 
  - name: q-yere-referral
    type: view
    repo: FAMCare-SQL-Toolkit
  - name: pwyerehospitalvisitnote
    type: html
    repo: famcare-html-form-code
  - name: pwyerehospitalvisitnote
    type: table
    repo: none
  - name: q-yere-hospital-visit-note
    type: view
    repo: FAMCare-SQL-Toolkit
  - name: q-client-bhn
    type: sql
    repo: famcare-sql-toolkit
change_control: internal-review-required
reviewed_by:
  - name: Data Governance Committee
  - date: 2025-11-25
last_reviewed: 2025-11-25
schema_version: 1.0
---

# YERE Referral and Hospital Visit Report

## Purpose

This report supports program management on documentation of hospital visit notes by YERE program staff by linking client enrollments to data on referring agency and location of person making the referral and initial hospital visit notes.

## Key Metrics

- Client enrollment start and end dates.
- Referral event date and referring hospital details.
- Initial hospital visit date, time, and client status.
- Program worker (last/first name and employee number).
- Reasons for no hospital visit or non–face-to-face contact.

## Filters

- **Hospital Visit Date Range:** Optional start and end date parameters.  
  - Start date only → returns records from that date forward.  
  - End date only → returns records up to that date.  
  - Both dates → returns records within the range.  
  - Blank → returns all records.
- **Program Worker:** Optional parameter to filter by employee number (dropdown displays names).  
- **Referral Event:** Restricted to enrollments with `PWY_EVENT = 'YERE Referral'`.

## Usage Notes

- Parameters are optional; leaving all blank returns all rows.  
- The hospital visit join is left outer, so enrollments without a hospital note are still included.  
- Designed for program staff to monitor referral-to-hospital transitions and worker assignments.

## Changelog

- **2025-11-25**: Implements optional date range parameters for hospital visit notes. Adds program worker parameter using employee number for stable filtering.
- **2025-11-24**: Adds initial query linking enrollments, referrals, and hospital visits.
- **2026-07-07**: Removes the HVN Status column from the query output. This question has been removed from this form.
