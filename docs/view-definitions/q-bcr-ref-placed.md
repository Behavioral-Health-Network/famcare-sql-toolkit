# Q_BCR_REF_PLACED

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-bcr-ref-placed.sql`  
**Last Updated:** **2025-08-09**  
**Author:** BHN Data Team  

## Purpose

Encapsulate reusable logic for reporting or downstream joins.

## Description

- Extracts and consolidates BCR referral placement data from multiple sources.
- Built on top of `PWBCRREFERRALSPLACED`, filtered to include only active records (`DOCREVNO = ' 0 '`).
- Joins to `Q_CLIENT_BHN` for client names, excluding test clients.
- Joins to `BCR_REF_PLACED_AGENCIES` multiple times to retrieve descriptive labels for referral subtypes across domains:
  - Behavioral Health
  - Housing
  - Maternal Health
  - Physical Health
  - Social Services
  - Spiritual Care
- Returns a comprehensive dataset for reporting and analysis, including:
  - Referral types and subtypes
  - Agency involvement
  - Placement dates
  - Client demographics and pathway metadata

### Logic Summary

- **Primary Source:** `PWBCRREFERRALSPLACED`
  - Filters to active records.
  - Includes referral metadata and client linkage.

- **Joins:**
  - `Q_CLIENT_BHN` for client names.
  - `BCR_REF_PLACED_AGENCIES` for descriptive labels across all referral domains.

- **Output Fields:**
  - Referral placement types and subtypes.
  - Agency codes and descriptions.
  - Placement dates per subtype.
  - Client pathway and event metadata.

## Maintenance Notes

- If new referral subtypes or agency codes are introduced, update the join logic and field mappings accordingly.
- Ensure that `Q_CLIENT_BHN` continues to exclude test clients to maintain data integrity.
- Monitor for changes in `PWBCRREFERRALSPLACED` structure that could affect field availability or naming.

## Changelog

- **2025-08-09**: Initial Markdown documentation authored.  
- **2025-05-16**: Initial view definition authored.
