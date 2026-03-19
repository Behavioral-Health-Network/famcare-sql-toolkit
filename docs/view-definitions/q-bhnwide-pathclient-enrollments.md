---
front-matter-title: BHN-Wide Pathclient Enrollments View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-bhnwide-pathclient-enrollments.sql
last_updated: 2026-03-17
author: Bradley Wing
status: active
lifecycle: production
program_scope: all
programs: []
tags:
  - pathway-join-view
  - multi-join
  - agency-wide
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# BHN-Wide Pathclient Enrollments View Definition

## Purpose

Provides an agency-wide, episode of care-level join between client enrollments, Pathway core forms, and Pathway Event metadata to support cross-program reporting, operational monitoring, and downstream program-specific assets.

## Description

- Consolidates client enrollment and event-level metadata **across all programs** that use `PROVIDERPLACEMENT` and Pathway.
- Anchored in `Q_PROVIDERPLACEMENT_BHN` (PP) as the canonical enrollment source for the entire agency.
- Resolves attribution to `PATHWAYCLIENT` (PC) using dual logic:
  - **DOCSERNO Join**: Preferred linkage when `PP.DOCSERNO = PC.DOCSERNO` (front-end enrollments).
  - **Enrollment/Start Date Join**: Fallback logic for imported or legacy enrollments where DOCSERNO does not align.
- Joins to `PATHWAYEVENTCLIENT` (PEC), `PATHWAYEVENT` (PE), and `PATHWAY` (PWY) for event-level and Pathway-level metadata.
- Includes provider and program worker context via `Q_PROVIDER` and `Q_HRFORM`.
- Filters to `DOCREVNO = ' 0 '` across Pathway tables to suppress legacy revisions.
- **Does not filter to a specific Pathway ID**—unlike program-specific views (e.g., `Q_ERE_PATHCLIENT_ENROLLMENTS`), this view is intentionally **program-agnostic** and can be reused by multiple downstream assets.

### How this differs from program-specific Pathway views

- **Scope:**
  - `Q_BHNWIDE_PATHCLIENT_ENROLLMENTS` is **agency-wide** and includes all Pathways and programs represented in `Q_PROVIDERPLACEMENT_BHN`.
  - Program-specific views (e.g., `Q_ERE_PATHCLIENT_ENROLLMENTS`, `Q_LINCS_NAV_PATHCLIENT_ENROLLMENTS`) filter to a single Pathway ID and often join to program-specific form views.
- **Structure:**
  - BHNWIDE exposes a **generic, reusable spine**: enrollment episode, Pathway client linkage, Pathway event metadata, provider, and worker context.
  - Program-specific views extend this spine with additional joins to program forms, diagnostic flags, and program-specific CASE logic.
- **Intended use:**
  - BHNWIDE is designed as a **shared infrastructure asset** for cross-program reporting, re-referral logic, and future program-specific derivatives.
  - Program-specific views are designed for **direct reporting and analytics** for a single program.

### Logic Summary

- **Source Tables / Views:**
  - `Q_PROVIDERPLACEMENT_BHN` (enrollment episodes)
  - `Q_CLIENT_BHN` (client identity and validation)
  - `PATHWAYCLIENT` (Pathway episode metadata)
  - `PATHWAYEVENTCLIENT` (event instances)
  - `PATHWAYEVENT` (event definitions)
  - `PATHWAY` (Pathway definitions)
  - `CLOSINGREASONS` (dismissal reason descriptions)
  - `Q_PROVIDER` (agency/provider metadata)
  - `Q_HRFORM` (program worker metadata)

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` on `CLIENT_NUMBER` to anchor to valid clients.
  - `LEFT JOIN PATHWAYCLIENT` twice:
    - DOCSERNO-based join for front-end enrollments.
    - STARTDATE/PATHWAY-based join for imported enrollments.
  - `LEFT JOIN PATHWAYEVENTCLIENT` on `CLIENT_NUMBER` and coalesced `PC_DOCSERNO` to attach event instances.
  - `LEFT JOIN PATHWAYEVENT` and `PATHWAY` for event and Pathway definitions.
  - `LEFT JOIN Q_PROVIDER` and `Q_HRFORM` for agency and worker context.
  - `LEFT JOIN CLOSINGREASONS` for dismissal reason descriptions.

- **Output Fields (high-level):**
  - Client identifiers and names.
  - Enrollment episode dates and dismissal reason.
  - Enrollment-to-Pathway linkage (`PC_DOCSERNO`, `ENROLL_PATH_JOIN_SOURCE`).
  - Pathway event client metadata (`PEC_PATHCLIENT_DOCSERNO`, `PEC_USERID`, `CURRENT_MESSAGE`).
  - Pathway and event metadata (`PATHWAY_ID`, `PWY_EVENT`, `EVENT_DOCSERNO`).
  - Episode timing (`PWY_START_DATE`, `PWY_END_DATE`).
  - Event timing and windows (`EARLIEST_START_DATE`, `EVENT_START_DATE`, `EVENT_END_DATE`, `LATEST_END_DATE`, `PE_DATE_ACCOMPLISHED`).
  - Due-date helper (`DAYS_UNTIL_FORM_DUE`).
  - Provider and program worker identifiers and names.

## Maintenance Notes

- When new Pathways or programs are added to `Q_PROVIDERPLACEMENT_BHN`, they will automatically surface in this view without structural changes.
- If additional agency-wide metadata is needed (e.g., funding source), consider extending this view rather than duplicating join logic in program-specific assets.
- Any changes to the dual join logic between `PROVIDERPLACEMENT` and `PATHWAYCLIENT` should be carefully validated, as they will affect all downstream program-specific views that rely on this spine.
- If performance becomes a concern for cross-program reporting, consider indexing `PATHWAYCLIENT` and `PATHWAYEVENTCLIENT` on `CLIENTNUMBER`, `DOCSERNO`, and `PATHCLIENTDOCSERNO`.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

- **2026-03-09**: Adds initial Markdown documentation.
- **2026-03-06**: Adds initial view definition.

</details>
</details>
<!---CHANGELOG-END--->
