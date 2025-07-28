# Client Status Missing

**Category:** Exception Reports  
**File:** `code/exception/client-status-missing.sql`  
**Last Updated:** 2025-07-21

---

## Purpose

Identify clients who lack a current status in the client status field.  
Supports the Data Team in ensuring all active and enrolled clients have  
up-to-date status values for accurate tracking and reporting.

---

## Logic Summary

- Flags clients with a blank value in `CLIENT_STATUS`.
- Joins to `Q_CLIENT_BHN` to exclude test clients via view logic.
- Filters for records where `CLIENT_STATUS = ''`.

---

## Usage Notes

- Intended for internal review and remediation by GVT and System  
  Administrator groups.
- Regular review recommended to ensure alignment with current business rules.

---

## Changelog

- **2025-07-21**: Initial version aligned to comment style guide.

---

## Related Assets

- View: `Q_CLIENT_BHN`
- Security Groups: GVT, System Administrator
