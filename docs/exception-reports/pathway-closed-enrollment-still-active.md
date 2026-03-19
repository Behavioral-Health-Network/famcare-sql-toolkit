---
front-matter-title: Pathway Closed Enrollment Still Active Exception Report
category: exception-reports
category-label: Exception Reports
source_file: code/exception-reports/pathway-closed-enrollment-still-active.sql
last_updated: 2025-10-02
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
program-scope: all
programs:
change_control:
  - internal-review-required
  - requires-rollback-plan
schema_version: 1.0
---

# Pathway Closed Enrollment Still Active Exception Report

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

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

</details>

<details markdown="1">
  <summary><strong>2025</strong></summary>

### 2025

- **2025-10-02**: Adds initial Markdown documentation file. Converts report to use `Q_CLIENT_BHN` instead of `Q_CLIENT`.
- **2025-05-01**: Adds initial SQL query.

</details>
</details>
<!---CHANGELOG-END--->
