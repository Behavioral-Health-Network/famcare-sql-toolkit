# YERE Duplicate Pathway Forms Per Enrollment

**Category:** Exception Reports  
**Source File:** `code/exception-reports/duplicate-pathway-forms-per-enrollment.sql`  
**Last Updated:** 2025-07-28  
**Author:** BHN Data Team  

---

## Purpose

Identify duplicate Pathway forms (Referral, Initial Assessment, Follow-Up, etc.) submitted for the same enrollment.  
This query flags potential duplicates requiring manual review to determine which version should be retained. Non-authoritative versions should be deleted with caution.

## Logic Summary

- Select completed enrollments (`PE_DATE_ACCOMPLISHED IS NOT NULL`) from `Q_YERE_PATHCLIENT_ENROLLMENTS`.
- Group by core enrollment fields and form document serial number.
- Count distinct `PWY_FORMS_DOCSERNO` values within each group.
- Return only groups with count greater than 1, indicating duplicate form submissions.

## Usage Notes

- Intended for internal review by program or Data Team staff.
- Confirm authoritative version for each duplicated entry before cleanup.
- Optionally reference audit log or historical submission timestamps to guide decision-making.

## Changelog

- **2025-07-13**: Initial SQL query authored.
