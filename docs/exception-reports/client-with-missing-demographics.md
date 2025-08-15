# Client With Missing Demographics

**Category:** Exception Reports  
**Source File:** `code/exception-reports/client-with-missing-demographics.sql`  
**Last Updated:** 2025-07-21
**Author:** Bradley Wing  
**Lifecycle:** `Production`

---

## Purpose

Identify clients with missing demographic information. When a demographic field is NULL, the query returns '??????' to highlight exceptions for users.

## Logic Summary

- Flags missing demographics by checking for NULL codes in:  
  - RACE_CODE
  - GENDER_CODE
  - ETHNICITY_CODE
  - BIRTH_DATE
  - ZIP_CODE

- Uses CASE statements to return '??????' when an exception exists, otherwise NULL.  
- Selects client identifiers, demographic exception columns, and entry timestamp.

## Usage Notes

- Intended for Data Team review and follow-up to ensure complete client records.  
- Run periodically as part of data quality checks.

## Changelog

- **2025-07-21**: Initial Markdown documentation authored.
- **2025-04-03**: Initial SQL query authored.

## Related Assets

- View: `Q_CLIENT_BHN`  
