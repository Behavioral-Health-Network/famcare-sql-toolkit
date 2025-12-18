/*
---
front-matter-title: ere-referral-hospital-visit-report
category: program-management-reports
category-label: Program Management Reports
source_file: code/program-management-reports/ere-referral-hospital-visit-report.sql
last_updated: 2025-12-16
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
  - name: q-ere-pathclient-enrollments
    type: view
    repo: FAMCare-SQL-Toolkit
  - name: pwerereferral
    type: html
    repo: famcare-html-form-code
  - name: pwyerereferral
    type: table
    repo: none 
  - name: q-ere-referral
    type: view
    repo: FAMCare-SQL-Toolkit
  - name: pwerehospitalvisitnote
    type: html
    repo: famcare-html-form-code
  - name: pwerehospitalvisitnote
    type: table
    repo: none
  - name: q-ere-hospital-visit-note
    type: view
    repo: FAMCare-SQL-Toolkit
  - name: q-client-bhn
    type: sql
    repo: famcare-sql-toolkit
change_control: internal-review-required
reviewed_by:
  - name: Data Governance Committee
  - date: 2025-12-16
last_reviewed: 2025-12-16
schema_version: 1.0
---

# ERE Referral and Hospital Visit Report

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

## Changelog

- **2025-12-16**: Adds initial query linking enrollments, referrals, and hospital visits. Adds Markdown documentation file.
*/

USE BEHAVHEALT_LIVE;
GO

SELECT EREENROLL.CLIENT_NUMBER,
	EREENROLL.ENROLLMENT_STARTING_DATE,
	EREENROLL.ENROLLMENT_ENDING_DATE,
	EREENROLL.PROGRAM_WORKER_LAST,
	EREENROLL.PROGRAM_WORKER_FIRST,
	EREREF.PATHWAY_DATE AS [REF_PATHWAY_DATE],
	EREREF.REFERRING_AGENCY_DESCRIPTION,
	EREREF.PATIENT_LOCATION_REFERRAL,
	EREHOSP.PATHWAY_DATE AS [HVN_PATHWAY_DATE],
	EREHOSP.VISITDT AS [HVN_VISITDT],
	EREHOSP.VISITTM AS [HVN_VISITTM],
	EREHOSP.ERE_VISIT_HOSP,
	EREHOSP.VISIT_HOSP_NO_OUTCOME,
	EREHOSP.VISIT_HOSP_NO_OUTCOME_OTHER
FROM Q_ERE_PATHCLIENT_ENROLLMENTS AS [EREENROLL]
INNER JOIN Q_ERE_REFERRAL AS [EREREF]
	ON EREENROLL.TIEDENROLLMENT = EREREF.TIEDENROLLMENT
LEFT JOIN Q_ERE_HOSPITAL_VISIT_NOTE AS [EREHOSP]
	ON EREENROLL.TIEDENROLLMENT = EREHOSP.TIEDENROLLMENT
WHERE EREENROLL.TIEDENROLLMENT IS NOT NULL
	AND EREENROLL.PWY_EVENT = 'ERE Referral'
--AND (
--	(EREHOSP.PATHWAY_DATE >= '^^BEGINNING HOSPITAL VISIT NOTE PATHWAY DATE|DATEPICKER^^'
--	 OR '^^BEGINNING HOSPITAL VISIT NOTE PATHWAY DATE^^' = '')
--)
--AND (
--	(EREHOSP.PATHWAY_DATE <= '^^ENDING HOSPITAL VISIT NOTE PATHWAY DATE|DATEPICKER^^'
--	 OR '^^ENDING HOSPITAL VISIT NOTE PATHWAY DATE^^' = '')
--)
--AND (
--	EREENROLL.PROGRAM_WORKER_EMPLOYEE_NUMBER = '^^PROGRAM WORKER|SELECT DISTINCT HR.EMPLOYEENUMBER, HR.EMPLOYEENAME FROM Q_PROVIDERPLACEMENT_BHN AS PP INNER JOIN Q_HRFORM HR ON PP.PROGRAM_WORKER = HR.EMPLOYEENUMBER WHERE PP.PATHWAY = '55320240807125033701' AND PP.PROGRAM_WORKER IS NOT NULL ORDER BY HR.EMPLOYEENAME^^'
--	OR '^^PROGRAM WORKER^^' = ''
--)