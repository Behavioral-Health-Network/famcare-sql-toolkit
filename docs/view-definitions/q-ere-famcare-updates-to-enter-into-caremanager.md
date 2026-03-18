---
front-matter-title: ERE FAMCare Updates To Enter Into CareManager View Definition
category: view-definitions
category_label: View Definitions
source_file: code/compliance-reports/ere-famcare-updates-to-enter-into-caremanager.sql
last_updated: 2026-02-17
status: active
lifecycle: production
program_scope: single
programs:
  - ere
tags:
  - view-layer
dependencies:
  - name: 
    type: 
    repo: 
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# ERE FAMCare Updates To Enter Into CareManager View Definition

## Purpose

Provides a single consolidated row per client enrollment for the ERE Pathway, aggregating visit dates from the four core ERE forms (Referral, IHNA, 3‑Month, 6‑Month). This view enables accurate date‑based reporting in Quick Reports by separating aggregation logic from parameter filtering.

## Description

- Produces one row per client enrollment, resolving the row‑inflation inherent in `Q_ERE_PATHCLIENT_ENROLLMENTS` (which contains one row per Pathway Event).
- Aggregates visit dates from the four ERE core forms using `MAX(CASE WHEN …)` logic.
- Designed specifically to support Quick Report date filtering, which must occur after aggregation due to the tool’s evaluation order.
- Retains all enrollment‑level metadata needed for downstream reporting.
- Excludes clients dismissed as “Reconnect” or “Re‑Referred” unless the enrollment has no ending date.
- Does **not** apply date filtering internally; this is intentionally deferred to the consuming query.

- **Source View:**
  - `Q_ERE_PATHCLIENT_ENROLLMENTS` (provides event‑level rows, attribution logic, and form metadata)

- **Joins:**
  - `LEFT JOIN Q_CLIENT_BHN` for demographic enrichment and test‑client suppression

- **Aggregation Logic:**
  - Four visit‑date fields are derived using conditional `MAX()` expressions:
    - `ERE_REF_VISITDT`
    - `ERE_IHNA_VISITDT`
    - `ERE_THREE_MO_VISITDT`
    - `ERE_SIX_MO_VISITDT`
  - Aggregation collapses multiple Pathway Events into a single enrollment‑level record.

- **Output Fields:**
  - Client identifiers and names  
  - Birth date  
  - Enrollment start and end dates  
  - Dismissal reason  
  - Four aggregated visit‑date fields for the ERE core forms  

### Architectural Rationale

Quick Reports evaluate the WHERE clause **before** aggregation.  
Because `Q_ERE_PATHCLIENT_ENROLLMENTS` contains one row per event, date filtering at that level can incorrectly include clients whose *non‑target* events fall within the date range.

This view resolves that issue by:

1. Performing all aggregation upstream.  
2. Exposing clean, enrollment‑level visit‑date fields.  
3. Allowing Quick Reports to filter directly on those aggregated fields using date‑picker parameters.  

This ensures that only clients with in‑range ERE Referral, IHNA, 3‑Month, or 6‑Month forms appear in the final output.

## Maintenance Notes

- If new ERE core forms are introduced, extend the aggregation logic with additional `MAX(CASE WHEN …)` expressions.
- If event naming conventions change, update the CASE conditions to match the new `PWY_EVENT` values.
- Ensure `Q_ERE_PATHCLIENT_ENROLLMENTS` continues to enforce `DOCREVNO = ' 0 '` and correct attribution via `TIEDENROLLMENT`.
- Consider indexing `Q_ERE_PATHCLIENT_ENROLLMENTS` on `CLIENT_NUMBER`, `PWY_EVENT`, and `PWY_FORMS_VISIT_DATE` to support performance for large reporting windows.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

- **2026-02-17**: Offloads the query logic to a view definition so that the `WHERE` clause may filter AFTER aggregation instead of BEFORE aggregation. Adjusts Quick Report date filtering to focus on visit dates for 'ERE Referral', 'ERE IHNA', 'ERE 3 Month', and 'ERE 6 Month' Pathway Events only.

</details>

<details markdown="1">
  <summary><strong>2025</strong></summary>

### 2025

</details>
</details>
<!---CHANGELOG-END--->
