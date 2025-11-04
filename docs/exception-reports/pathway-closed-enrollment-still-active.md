---
front-matter-title: pathway-closed-enrollment-still-active
category: exception-reports
category-label: Exception Reports
source_file: code/exception-reports/pathway-closed-enrollment-still-active.sql
last_updated: 2025-10-02
author: Bradley Wing
status: active
lifecycle: production
tags:
  - audit-trail
  - data-integrity
  - dismissal
  - documentation
  - exception-report
  - pathways-dismissal
  - pathways-module
program-scope: multi
programs:
  - BCR
  - Complex Care
  - EPICC
  - ERE
  - YERE
dependencies:
  - name: Q_CLIENT_BHN
    type: sql
    repo: FAMCare-SQL-Toolkit
  - name: PROVIDERPLACEMENT
    type: table
    repo: FAMCare-SQL-Toolkit
  - name: PATHWAYCLIENT
    type: table
    repo: FAMCare-SQL-Toolkit
  - name: PATHWAYEVENTCLIENT
    type: table
    repo: FAMCare-SQL-Toolkit
change_control:
  - internal-review-required
  - requires-rollback-plan
reviewed_by:
  - name: Bradley Wing
  - date: 2025-10-02
last_reviewed: 2025-10-02
schema_version: 1.0
---

# Pathway Closed Enrollment Still Active

## Purpose

Identifies clients whose program enrollment remains active even though their assigned Pathway has been closed. This exception report helps Data Team staff ensure that enrollments are properly dismissed when a Pathway is closed, supporting accurate case management and reporting.

## Logic Summary

- Flags cases where a Pathway is closed (`PATHWAYCLIENT.ENDDATE IS NOT NULL`) but the related enrollment (`PROVIDERPLACEMENT.ENDINGDATE`) is still active (`NULL`).
- Joins across Pathway metadata tables (`PATHWAY`, `PATHWAYCLIENT`, `PATHWAYEVENT`, and `PATHWAYEVENTCLIENT`) and `PROVIDERPLACEMENT` tables to validate closure logic.
- Includes program, client, worker, and supervisor details for review.
- Excludes test clients.
- Supports dynamic filtering by program.

## Usage Notes

- Used by Data Team for exception remediation and enrollment cleanup.
- May inform stakeholder review or internal audit processes.
- Should be tested after schema or logic changes to Pathway metadata or `PROVIDERPLACEMENT` tables.

## Changelog

- **2025-10-02**: Adds initial Markdown documentation file. Converts report to use `Q_CLIENT_BHN` instead of `Q_CLIENT`.
- **2025-05-01**: Adds initial SQL query.
