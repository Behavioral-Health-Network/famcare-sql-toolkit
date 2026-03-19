---
front-matter-title: Backup and Delete Quick Reports in SAVEDQUERIES_BASE Table Maintenance Script
category: maintenance-scripts
category-label: Maintenance Scripts
source_file: code/maintenance-scripts/savedqueries-backup-delete.sql
last_updated: 2026-03-11
status: active
lifecycle: production
tags:
  - data-correction
  - archival
  - maintenance
program-scope: none
programs:
  - none
change_control:
  - requires-rollback-plan
  - internal-review-required
schema_version: 1.0
---

# Backup and Delete Quick Reports in SAVEDQUERIES_BASE Table Maintenance Script

Backup and Delete Quick Reports From `SAVEDQUERIES_BASE` Table Maintenance Script

## Purpose

This script safely backs up selected rows from `SAVEDQUERIES_BASE` into `SAVEDQUERIES_BACKUP` and then deletes those same rows from the base table. It is intended for cleanup of duplicate, obsolete, or user‑specific saved queries  
while preserving a full archival copy.

## Reasoning

- Certain saved queries may need to be removed due to duplication, corruption, or user‑requested cleanup.
- A backup is required before deletion to ensure reversibility.
- The script uses a transaction with `TRY/CATCH` to prevent half‑committed states.
- `IDENTITY_INSERT` is used to preserve original `ID` values in the backup table.

## Affected Rows

Rows matching:

- `ID IN (365, 309)`
- `USERID = 'bradley-wing'`

These filters should be updated as needed for future maintenance operations.

## Execution Notes

- Ensure no open transactions exist before execution (`SELECT @@TRANCOUNT`).
- Confirm that `SAVEDQUERIES_BACKUP` does not already contain the same IDs  
  before enabling `IDENTITY_INSERT`.
- The script will automatically roll back if any error occurs.
- Review the `OUTPUT DELETED.*` results before committing.

## Changelog

<!-- CHANGELOG:START -->
<!-- CHANGELOG:END -->
