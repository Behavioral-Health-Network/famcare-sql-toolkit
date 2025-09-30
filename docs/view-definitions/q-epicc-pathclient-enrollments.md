---
front-matter-title: Q_EPICC_PATHCLIENT_ENROLLMENTS
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-epicc-pathclient-enrollments.sql
last_updated: 2025-05-07
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - epicc
tags:
  - pathway-join-view
  - multi-join
dependencies:
  - name: providerplacement
    type: html
    repo: famcare-html-form-code
  - name: providerplacement
    type: table
    repo: none
  - name: pathway
    type: table
    repo: none
  - name: pathwayevent
    type: table
    repo: none
  - name: pathwayclient
    type: table
    repo: none
  - name: pathwayeventclient
    type: table
    repo: none
  - name: closingreasons
    type: table
    repo: none
  - name: q-provider
    type: sql
    repo: famcare-sql-toolkit
  - name: q-hrform
    type: sql
    repo: famcare-sql-toolkit
  - name: q-epicc-referral
    type: sql
    repo: famcare-sql-toolkit
  - name: q-epicc-ic
    type: sql
    repo: famcare-sql-toolkit
  - name: q-epicc-two-week
    type: sql
    repo: famcare-sql-toolkit
  - name: q-epicc-thirty-day
    type: sql
    repo: famcare-sql-toolkit
  - name: q-epicc-three-month
    type: sql
    repo: famcare-sql-toolkit
  - name: q-epicc-six-month
    type: sql
    repo: famcare-sql-toolkit
  - name: q-client-bhn
    type: sql
    repo: famcare-sql-toolkit
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# Q_EPICC_PATHCLIENT_ENROLLMENTS

## Purpose

Joins client enrollment, Pathway core forms, and the Pathway Event data collection forms to enable program management and to allow for reporting on program outcomes.

## Description

- Consolidates client enrollment and event-level form data for the EPICC Pathway.
- Anchored in `PROVIDERPLACEMENT` (PP) as the enrollment source.
- Resolves attribution to `PATHWAYCLIENT` (PC) using dual logic:
  - **DOCSERNO Join**: Preferred linkage when enrollment DOCSERNO matches pathway DOCSERNO.
  - **Enrollment/Start Date Join**: Fallback logic for mismatches (e.g., imports).
- Joins to `PATHWAYEVENTCLIENT` (PEC) and `PATHWAYEVENT` (PE) for event-level metadata.
- Left joins to filtered views of EPICC-specific forms to avoid row inflation.
- Uses `COALESCE` and `ENROLL_PATH_JOIN_SOURCE` to trace attribution logic.
- Includes form-level metadata:
  - `PATHWAY_DATE`, `PE_DATE_ACCOMPLISHED`, `DAYS_UNTIL_FORM_DUE`
  - `TREATMENT_PATH`, `PROGRAM_PARTICIPATION`, `PRO_OR_CORE`
- Filters to `DOCREVNO = ' 0 '` across all relevant tables to suppress legacy record versions.
- Filters to Pathway ID `55320240807113504583` (EPICC).

### Logic Summary

- **Source Tables:**
  - `PROVIDERPLACEMENT`, `PATHWAYCLIENT`, `PATHWAYEVENTCLIENT`, `PATHWAYEVENT`, `PATHWAY`
  - EPICC form views: `Q_EPICC_REFERRAL`, `Q_EPICC_IC`, `Q_EPICC_TWO_WEEK`, `Q_EPICC_THIRTY_DAY`, `Q_EPICC_THREE_MONTH`, `Q_EPICC_SIX_MONTH`

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client validation and test client exclusion
  - `LEFT JOIN PATHWAYCLIENT` (dual logic)
  - `INNER JOIN PATHWAYEVENT`, `PATHWAY`
  - `LEFT JOIN Q_PROVIDER`, `Q_HRFORM`, `CLOSINGREASONS`
  - `LEFT JOIN` to EPICC form views using `CLIENT_NUMBER`, `PATHWAY_DATE`, and `EVENT_NAME`

- **Output Fields:**
  - Client identifiers and names
  - Enrollment and pathway dates
  - Attribution source (`ENROLL_PATH_JOIN_SOURCE`)
  - Event metadata and form DOCSERNOs
  - Treatment path and program participation descriptions
  - Program worker and agency details

## Maintenance Notes

- If new EPICC event types or forms are introduced, extend the CASE logic and join structure accordingly.
- Ensure form views remain filtered to `DOCREVNO = ' 0 '` and include `EVENT_NAME` for alignment.
- Monitor for changes in event naming conventions that could affect CASE logic or join keys.
- Consider indexing `PATHWAYEVENTCLIENT` and form views on `CLIENT_NUMBER`, `PATHWAY_DATE`, and `EVENT_NAME` for performance.

## Changelog

- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-10**: Adds initial Markdown documentation.  
- **2025-07-13**: Replaces direct `INNER JOIN` to `PATHWAYCLIENT` with dual `LEFT JOIN` strategy using DOCSERNO and enrollment/start date alignment.
- **2025-07-13**: Adds column `[ENROLL_PATH_JOIN_SOURCE]` to trace how each enrollment was linked to a pathway.
- **2025-05-07**: Adds initial view definition.
