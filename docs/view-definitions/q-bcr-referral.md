# Q_BCR_REFERRAL

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-bcr-referral.sql`  
**Last Updated:** **2025-08-09**  
**Author:** BHN Data Team  

## Purpose

Encapsulate reusable logic for reporting or downstream joins.

## Description

- Extracts and consolidates BCR referral data from multiple sources.
- Built on top of `PWBCRREFERRAL`, filtered to include only active records (`DOCREVNO = ' 0 '`).
- Joins to `Q_CLIENT_BHN` to retrieve client names, excluding test clients.
- Joins to `BCR_PROG_PARTICIPATION` to include descriptive labels for program participation codes.
- Returns a comprehensive dataset for reporting and analysis, including:
  - Referral source details
  - Client demographics
  - Program participation
  - Eligibility and housing status

### Logic Summary

- **Primary Source:** `PWBCRREFERRAL`
  - Filters to active records.
  - Includes referral metadata and client linkage.

- **Joins:**
  - `Q_CLIENT_BHN` for client first and last names.
  - `BCR_PROG_PARTICIPATION` for descriptive program participation labels.

- **Output Fields:**
  - Referral method, source type, and event linkage.
  - Client status indicators (e.g., pregnant, marital, housing).
  - Participation and eligibility details.

## Maintenance Notes

- If new referral source types or program codes are added, update the join logic and field mappings accordingly.
- Ensure that `Q_CLIENT_BHN` continues to exclude test clients to maintain data integrity.
- Monitor for changes in `PWBCRREFERRAL` structure that could affect field availability or naming.

## Changelog

- **2025-08-09**: Initial Markdown documentation authored.
- **2025-05-16**: Initial view definition authored.
