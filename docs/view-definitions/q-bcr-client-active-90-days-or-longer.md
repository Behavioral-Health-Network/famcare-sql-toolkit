---
front-matter-title: Q_BCR_CLIENT_ACTIVE_90_DAYS_OR_LONGER
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q_bcr_client_active_90_days_or_longer.sql
last_updated: 2025-12-11
author: Bradley Wing
status: active
lifecycle: deprecated
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
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# Q_BCR_CLIENT_ACTIVE_90_DAYS_OR_LONGER

## Purpose

Encapsulate reusable logic to identify BCR clients who have been actively enrolled for 90 days or longer. Supports program leadership in reviewing clients for timely dismissal and ensuring outreach efforts are appropriately tracked.

## Description

- Filters to open enrollments (`ENROLLMENT_ENDING_DATE IS NULL`) using `Q_PROVIDERPLACEMENT_BHN`.
- Calculates 90-day threshold using `DATEADD(DAY, 90, ENROLLMENT_STARTING_DATE)`.
- Joins to `PATHWAYCLIENT` to confirm enrollment alignment and restrict to BCR Pathway (`PARENTDOCSERNO = '55320240917145557321'`).
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

- **2025-12-11**: Deprecates the report since the Program Manager has decided to dismiss clients enrolled more than 30 days. Removes visibility for the 'BCR Managers' security group but retains visibility for 'GVT' and 'System Administrator' security groups.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-13**: Converts the exception report query as a view to get around the limitations of the vendor's quick reports that did not run the report with the filter applied due to binding issues.
- **2025-08-13**: Adds `PC.PARENTDOCSERNO = '55320240917145557321'` to restrict to BCR Pathway; switches from base `PROVIDERPLACEMENT` to `Q_PROVIDERPLACEMENT_BHN`.
- **2025-07-31**: Adds initial Markdown documentation; adds logic summary and output field descriptions.
- **2025-04-29**: Adds initial SQL query.

</details>
</details>
