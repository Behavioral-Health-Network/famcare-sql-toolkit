# Client With Missing Demographics

**Category:** Exception Reports  
**File:** `code/exception/Client-With-Missing-Demographics.sql`  
**Last Updated:** 2025-07-21

---

## Purpose

Identify clients with missing demographic information.  
When a demographic field is NULL, the query returns '??????' to  
highlight exceptions for users.

---

## Logic Summary

- Flags missing demographics by checking for NULL codes in:  
    RACE_CODE, GENDER_CODE, ETHNICITY_CODE, BIRTH_DATE, and ZIP_CODE.  
- Uses CASE statements to return '??????' when an exception exists, otherwise NULL.  
- Selects client identifiers, demographic exception columns, and entry timestamp.

---

## Usage Notes

- Intended for Data Team review and follow-up to ensure complete client records.  
- Run periodically as part of data quality checks.

---

## Changelog

- **2025-07-21**: Initial documentation authored.

---

## Related Assets

- View: `Q_CLIENT_BHN`  
- Exception marker: '??????'
