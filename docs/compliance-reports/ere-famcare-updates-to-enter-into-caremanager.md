---
front-matter-title: ere-famcare-updates-to-enter-into-caremanager
category: compliance-reports
category-label: Compliance Reports
source_file: code/compliance-reports/ere-famcare-updates-to-enter-into-caremanager.sql
last_updated: 2025-11-04
author: Bradley
status: active
lifecycle: production
program_scope: single
programs:
  - ere
tags:
  - pathway-event
  - ere-referral
  - ere-ihna
  - ere-3-month
  - ere-6-month
dependencies:
  - name: q-ere-pathclient-enrollments
    type: sql
    repo: famcare-sql-toolkit
  - name: q-client-bhn
    type: sql
    repo: famcare-sql-toolkit
change_control: internal-review-required
reviewed_by:
  - name: Bradley
  - date: 2025-08-21
last_reviewed: 2025-08-21
schema_version: 1.0
---

# ERE FAMCare Updates to Enter Into CareManager

## Purpose

This report identifies ERE clients with completed Pathway Event forms that must be entered into CareManager. It surfaces milestone-based form completions—including Referral, IHNA, 3 Month, and 6 Month events—linked to enrollment periods.

## Compliance Scope

- Supports internal tracking of required CareManager updates for ERE clients.
- Ensures timely documentation of milestone forms tied to enrollment.
- Used to fulfill internal compliance workflows and data integrity checks.

## Usage Notes

- Filters by visit date range using form-level datepickers.
- Aggregates milestone dates using conditional logic and MAX() functions.
- Intended for internal compliance review and CareManager data entry coordination.

## Changelog

- **2025-11-04**: Adds `EENROLL.DISMISSAL_REASON_DESCRIPTION` field and updates the `WHERE` clause to filter out values of 'Reconnect' since they are irrelevant in CareManager Wwhile ensuring that those with `EENROLL.ENROLLMENT_ENDING_DATE` are not `NULL` to retain active clients not reconnected.
- **2025-09-18**: Relocates and reformats tags: field.
- **2025-08-21**: Adds initial Markdown documentation.
- **2025-08-21**: Adds initial SQL query for ERE compliance reporting into CareManager.
