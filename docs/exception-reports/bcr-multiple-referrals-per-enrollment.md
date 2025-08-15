# BCR Multiple Referrals Per Enrollment

**Category:** Exception Reports  
**Source File:** `code/exception-reports/bcr-multiple-referrals-per-enrollment.sql`  
**Last Updated:** 2025-08-12  
**Author:** Bradley Wing  
**Lifecycle:** `Production`

---

## Purpose

Identifies clients who have more than one BCR referral recorded within a single program enrollment.  
Supports exception reporting by flagging potential duplicate or erroneous referral entries.

## Description

- Built on `PWBCRREFERRAL`, joined to `PROVIDERPLACEMENT` and `Q_CLIENT_BHN`.
- Filters to current records (`DOCREVNO = ' 0 '`).
- Groups by client and enrollment to count referral entries.
- Flags cases where more than one referral is linked to the same enrollment period.
- Excludes test clients via `Q_CLIENT_BHN`.

## Maintenance Notes

- Ensure joins to `PROVIDERPLACEMENT` and `PWBCRREFERRAL` reflect current data structures.
- Confirm that `PATHWAY_DATE` remains the correct linkage key for referral tracking.
- Review logic periodically to align with evolving program workflows and form usage.

## Changelog

- **2025-08-12**: Initial Markdown documentation authored.  
- **2025-04-07**: Initial SQL query authored.
