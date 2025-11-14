---
front-matter-title: BCR Events
category: Program Management Reports
source_file: code/program-management-reports/bcr-events.sql
last_updated: 2025-11-05
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - bcr
tags: [value1, value2]
dependencies:
  - value1
  - value2
change_control: value
reviewed_by:
  - name: Bradley Wing
    date: 2025-11-05
last_reviewed: 2025-11-05
schema_version: 1.0
---

# BCR Events

## Purpose

Summarizes BCR event activity by user, topic, grant, and format. Includes both row-level detail and aggregate totals for attendance and engagement metrics.

## Key Metrics

- Total attendees, adults, youth, pastors
- Follow-up requests and completed screens
- Knowledge increase counts
- Event metadata: type, topic, format, grant code/description

## Filters

- `PATHWAY_DATE` range (start and end)
- `EVENT_TOPIC`, `EVENT_TYPE`, `EVENT_GRANT_DESCRIPTION` — all optional dropdown filters

## Logic Summary

- Pulls from `Q_BCR_EVENTS` view
- Filters applied via parameterized dropdowns and datepickers
- `UNION ALL` used to append a summary row with aggregate totals
- All numeric fields cast with `TRY_CAST` to ensure safe aggregation

## Usage Notes

- Used by program managers to track outreach and engagement
- Supports grant reporting and internal review
- Summary row labeled as `USERID = 'TOTAL'` for easy identification

## Changelog

- **2025-11-05**: Adds initial Markdown documentation. Adds new parameter for `EVENT_TYPE`.
- **2025-07-23**: Adds initial SQL query.
