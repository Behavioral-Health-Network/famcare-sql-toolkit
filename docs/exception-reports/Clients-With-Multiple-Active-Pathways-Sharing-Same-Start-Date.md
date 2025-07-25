# Clients With Multiple Active Pathways Sharing Same Start Date

**Category:** Exception Reports  
**File:** `code/exception/Clients-With-Multiple-Active-Pathways-Sharing-Same-Start-Date.sql`  
**Last Updated:** 2025-07-21

---

## Purpose

Identify clients who have multiple active Pathways that share the same start date.  
This report helps surface potential data entry errors or structural duplication in Pathway assignment workflows.

---

## Logic Summary

- Constructs a CTE (`DuplicateStartDates`) that groups PathwayClient rows by `CLIENTNUMBER` and `STARTDATE`, retaining only cases where the same start date appears more than once for the same client (`COUNT(*) > 1`).  
- Filters for original document revisions (`DOCREVNO = ' 0 '`) in both `PATHWAYCLIENT` and `PATHWAY`.  
- Joins the duplicate start date results to full Pathway, ProviderPlacement, Provider, and Client metadata.  
- Returns one row per Pathway instance matching the duplicated start date for the same client.

---

## Usage Notes

- Used as a source view for Quick Reports to flag possible duplication across Pathway assignments.  
- Review flagged rows for clients with multiple concurrent Pathways sharing identical start dates.  
- Useful for data cleanup, staff follow-up, and resolving overlapping assignment logic.

---

## Changelog

- **2025-07-21**: Initial documentation authored.

---

## Related Assets

- Source Tables: `PATHWAYCLIENT`, `PATHWAY`, `Q_PROVIDERPLACEMENT`, `Q_PROVIDER`, `Q_CLIENT_BHN`  
- CTE: `DuplicateStartDates`  
- View Name: `Q_CLIENTS_WITH_MULTIPLE_PATHWAYS_SHARING_SAME_START_DATE`
