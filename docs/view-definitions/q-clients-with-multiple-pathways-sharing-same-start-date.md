# Q_CLIENTS_WITH_MULTIPLE_PATHWAYS_SHARING_SAME_START_DATE

**Category:** View Definitions  
**File:** `code/view-definitions/q-clients-with-multiple-active-pathways-sharing-same-start-date.sql`  
**Last Updated:** 2025-07-21
**Author:** Bradley Wing  
**Lifecycle:** `Production`

---

## Purpose

Identify clients who have multiple active Pathways that share the same start date. This report helps surface potential data entry errors or structural duplication in Pathway assignment workflows.

---

## Description

- Constructs a CTE (`DuplicateStartDates`) that groups PathwayClient rows by `CLIENTNUMBER` and `STARTDATE`, retaining only cases where the same start date appears more than once for the same client (`COUNT(*) > 1`).  
- Filters for original document revisions (`DOCREVNO = ' 0 '`) in both `PATHWAYCLIENT` and `PATHWAY`.  
- Joins the duplicate start date results to full Pathway, ProviderPlacement, Provider, and Client metadata.  
- Returns one row per Pathway instance matching the duplicated start date for the same client.

---

## Maintenance Notes

- Used as a source view for Quick Reports to flag possible duplication across Pathway assignments.  
- Review flagged rows for clients with multiple concurrent Pathways sharing identical start dates.  
- Useful for data cleanup, staff follow-up, and resolving overlapping assignment logic.

---

## Related Assets

- Source Tables: `PATHWAYCLIENT`, `PATHWAY`, `Q_PROVIDERPLACEMENT`, `Q_PROVIDER`, `Q_CLIENT_BHN`  
- CTE: `DuplicateStartDates`  
- View Name: `Q_CLIENTS_WITH_MULTIPLE_PATHWAYS_SHARING_SAME_START_DATE`

---

## Changelog

- **2025-08-07**: Initial Markdown documentation authored.
- **2025-07-08**: Initial view definition authored.
