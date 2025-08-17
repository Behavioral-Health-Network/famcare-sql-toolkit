# Client Dismissed But Client Status Still Active

**Category:** Exception Reports  
**Source File:** `code/exception-reports/client-dismissed-but-client-status-still-active.sql`  
**Last Updated:** 2025-07-21
**Author:** Bradley Wing  
**Lifecycle:** `Production`

---

## Purpose

Identify clients who have a recorded enrollment dismissal but whose client status remains marked as "Active," and who do not have any open enrollments. This report helps Data Team staff ensure that client statuses are updated appropriately following dismissal, supporting accurate case management and reporting.

## Logic Summary

- Filters for clients whose `CLIENTSTATUS = 'Active'`.
- Uses `NOT EXISTS` to verify that no open enrollments remain (`ENDINGDATE IS NULL`).
- Confirms dismissal activity via `ENDINGDATE IS NOT NULL` in a joined provider placement.
- Joins `Q_CLIENT_BHN` to `Q_PROVIDERPLACEMENT` on `CLIENT_NUMBER`.

## Usage Notes

- Intended for internal review by Data Team staff.
- Supports status auditing and helps close workflow gaps between enrollment updates.
- Should be reviewed periodically alongside other enrollment exception reports.

## Changelog

- **2025-07-21**: Initial Markdown documentation authored.
- **2025-05-02**: Initial SQL query authored.  

## Related Assets

- Views: `Q_CLIENT_BHN`, `Q_PROVIDERPLACEMENT`  
- Security Groups: GVT, System Administrator  
- Exception Conditions:
  - `CLIENT_STATUS = 'Active'`
  - No open enrollments exist
  - At least one dismissed enrollment present
