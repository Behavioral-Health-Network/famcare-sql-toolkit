---
front-matter-title: Q_BCR_CLIENT_ACTIVE_30_DAYS_OR_LONGER
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q_bcr_client_active_30_days_or_longer.sql
last_updated: 2025-12-11
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - bcr
tags:
  - tag1
  - tag2
dependencies:
  - name: q-providerplacement-bhn
    type: sql
    repo: famcare-sql-toolkit
  - name: providerplacement
    type: html
    repo: famcare-html-form-code
  - name: providerplacement
    type: table
    repo: none
  - name: pathwayclient
    type: html
    repo: famcare-html-form-code
  - name: pathwayclient
    type: table
    repo: none
  - name: q-client_bhn
    type: sql
    repo: famcare-sql-toolkit
  - name: q-bcr-ic
    type: sql
    repo: famcare-sql-toolkit
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# Q_BCR_CLIENT_ACTIVE_30_DAYS_OR_LONGER

## Purpose

Encapsulate reusable logic to identify BCR clients who have been actively enrolled for 30 days or longer. Supports program leadership in reviewing clients for timely dismissal and ensuring outreach efforts are appropriately tracked.

## Description

- Filters to open enrollments (`ENROLLMENT_ENDING_DATE IS NULL`) using `Q_PROVIDERPLACEMENT_BHN`.
- Calculates 30-day threshold using `DATEADD(DAY, 30, ENROLLMENT_STARTING_DATE)`.
- Joins to `PATHWAYCLIENT` to confirm enrollment alignment and restrict to BCR Pathway (`PARENTDOCSERNO = '55320240917145557321'`).
- Joins to `Q_BCR_IC` to add `BCR_PROGRAM_PARTICIPATION` so that the Program Manager may verify if an Initial Contact form has been entered prior to dismissal.
- Excludes test clients via `Q_CLIENT_BHN`.
- Returns distinct client records with enrollment and review dates.

## Maintenance Notes

- Confirm that `PATHWAYCLIENT.STARTDATE` matches `Q_PROVIDERPLACEMENT_BHN.ENROLLMENT_STARTING_DATE`.
- Ensure `PARENTDOCSERNO` remains valid for BCR Pathway filtering.
- Validate that upstream filters in `Q_CLIENT_BHN` continue to exclude test clients.
- Review logic periodically to confirm alignment with program workflows and dismissal policies.

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

- **2025-12-11**: Copies `q-bcr-client-active-90-days-or-longer` view and modifies to change the `WHERE` to filter to enrollments that have not been dismissed and that have been active for longer than 30 days. Adds `LEFT JOIN` to `Q_BCR_IC` and adds `BCR_PROGRAM_PARTICIPATION_DESC` to the `SELECT`. Carries original changelog over from the 90-day version and continues it here.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-13**: Converts the exception report query as a view to get around the limitations of the vendor's quick reports that did not run the report with the filter applied due to binding issues.
- **2025-08-13**: Adds `PC.PARENTDOCSERNO = '55320240917145557321'` to restrict to BCR Pathway; switches from base `PROVIDERPLACEMENT` to `Q_PROVIDERPLACEMENT_BHN`.
- **2025-07-31**: Adds original Markdown documentation; adds logic summary and output field descriptions.
- **2025-04-29**: Adds original SQL query.

</details>
</details>
