---
front-matter-title: Clients With Multiple Active Pathways
category: Exception Reports
source_file: code/exception-reports/clients-with-multiple-active-pathways.sql
last_updated: 2025-07-21
author: Bradley Wing
status: active
lifecycle: production
program_scope: multi
programs:
  - bcr
  - complex-care
  - epicc
  - ere
  - yere
tags:
  - exception-logic
  - tag2
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

# Clients With Multiple Active Pathways

## Purpose

Identify clients who are assigned to more than one active Pathway at the same time. Supports Data Team staff in monitoring concurrent Pathway assignments that may require review or follow-up.

## Logic Summary

- Queries the view `Q_CLIENTS_WITH_MULTIPLE_ACTIVE_PATHWAYS`, which encapsulates necessary logic via a CTE.  
- Returns one row per active Pathway per client, (`PC.ENDDATE IS NULL`).  
- Only includes clients with more than one concurrent Pathway assignment (`COUNT_PATHWAY > 1`).  
- Excludes test clients.  
- Includes program and agency details per Pathway instance.

## Usage Notes

- The `[COUNT_PATHWAY]` column represents the number of active Pathways per client—always > 1 in this report.  
- Designed for Quick Reports compatibility, as CTEs are disallowed directly in Quick Reports.  
- Review and maintain exclusion logic for test clients.

## Changelog

- **2025-09-18**: Adds exception-logic tag and front-matter-title.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-08**: Adds initial Markdown documentation.  
- **2025-06-24**: Adds initial SQL query.

## Related Assets

- View: `Q_CLIENTS_WITH_MULTIPLE_ACTIVE_PATHWAYS`  
- Security Groups: GVT, System Administrator  
