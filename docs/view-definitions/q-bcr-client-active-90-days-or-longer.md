# Q_BCR_CLIENT_ACTIVE_90_DAYS_OR_LONGER

**Category:** View Definitions  
**Source File:** `code/view-definitions/q_bcr_client_active_90_days_or_longer.sql`  
**Last Updated:** 2025-08-13  
**Author:** BHN Data Team  
**Lifecyle:** `Production`

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

- **2025-08-13**: Converts the exception report query as a view to get around the limitations of the vendor's quick reports that did not run the report with the filter applied due to binding issues.
- **2025-08-13**: Adds `PC.PARENTDOCSERNO = '55320240917145557321'` to restrict to BCR Pathway; switches from base `PROVIDERPLACEMENT` to `Q_PROVIDERPLACEMENT_BHN`.
- **2025-07-31**: Initial Markdown documentation authored; adds logic summary and output field descriptions.
- **2025-04-29**: Initial SQL query authored.
