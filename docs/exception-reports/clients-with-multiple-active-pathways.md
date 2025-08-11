# Clients With Multiple Active Pathways

**Category:** Exception Reports  
**File:** `code/exception-reports/clients-with-multiple-active-pathways.sql`  
**Last Updated:** 2025-07-21

---

## Purpose

Identify clients who are assigned to more than one active Pathway at the same time.  
Supports Data Team staff in monitoring concurrent Pathway assignments that may require review or follow-up.

---

## Logic Summary

- Queries the view `Q_CLIENTS_WITH_MULTIPLE_ACTIVE_PATHWAYS`, which encapsulates necessary logic via a CTE.  
- Returns one row per active Pathway per client, (`PC.ENDDATE IS NULL`).  
- Only includes clients with more than one concurrent Pathway assignment (`COUNT_PATHWAY > 1`).  
- Excludes test clients.  
- Includes program and agency details per Pathway instance.

---

## Usage Notes

- The `[COUNT_PATHWAY]` column represents the number of active Pathways per client—always > 1 in this report.  
- Designed for Quick Reports compatibility, as CTEs are disallowed directly in Quick Reports.  
- Review and maintain exclusion logic for test clients.

---

## Changelog

- **2025-06-24**: View created.

---

## Related Assets

- View: `Q_CLIENTS_WITH_MULTIPLE_ACTIVE_PATHWAYS`  
- Security Groups: GVT, System Administrator  
