---
front-matter-title: Q_BCR_PATHCLIENT_ENROLLMENTS
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-bcr-pathclient-enrollments.sql
last_updated: 2025-07-09
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - bcr
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
  - name: q-bcr-referral
    type: sql
    repo: famcare-sql-toolkit
  - name: pwbcrreferral
    type: html
    repo: famcare-html-form-code
  - name: pwbcrreferral
    type: table
    repo: none
  - name: q-bcr-ic
    type: sql
    repo: famcare-sql-toolkit
  - name: pwbcrinitialcontact
    type: html
    repo: famcare-html-form-code
  - name: pwbcrinitialcontact
    type: table
    repo: none
  - name: q-bcr-ref-placed
    type: sql
    repo: famcare-sql-toolkit
  - name: pwbcrreferralsplaced
    type: html
    repo: famcare-html-form-code
  - name: pwbcrreferralsplaced
    type: table
    repo: none
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

# Q_BCR_PATHCLIENT_ENROLLMENTS

## Purpose

Joins client enrollment, Pathway core forms, and the Pathway Event data collection forms to enable program management and to allow for reporting on program outcomes.

## Description

- Consolidates client enrollment and event-level form data for the BCR Pathway.
- Anchored in `PROVIDERPLACEMENT` (PP) as the enrollment source.
- Resolves attribution to `PATHWAYCLIENT` (PC) using dual logic:
  - **DOCSERNO Join**: Preferred linkage when enrollment DOCSERNO matches pathway DOCSERNO.
  - **Enrollment/Start Date Join**: Fallback logic for mismatches (e.g., imports).
- Joins to `PATHWAYEVENTCLIENT` (PEC) and `PATHWAYEVENT` (PE) for event-level metadata.
- Left joins to filtered views of BCR-specific forms to avoid row inflation.
- Includes form-level metadata:
  - `PATHWAY_DATE`, `PE_DATE_ACCOMPLISHED`, `DAYS_UNTIL_FORM_DUE`
  - `PROGRAM_PARTICIPATION`
- Filters to `DOCREVNO = ' 0 '` across all relevant tables to suppress legacy versions.
- Filters to Pathway ID `55320240917145557321` (BCR).

### Logic Summary

- **Source Tables:**
  - `PROVIDERPLACEMENT`, `PATHWAYCLIENT`, `PATHWAYEVENTCLIENT`, `PATHWAYEVENT`, `PATHWAY`
  - BCR form views: `Q_BCR_REFERRAL`, `Q_BCR_IC`, `Q_BCR_REF_PLACED`

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client validation and test client exclusion
  - `INNER JOIN PATHWAYCLIENT` using dual logic (DOCSERNO or start date alignment)
  - `INNER JOIN PATHWAYEVENTCLIENT`, `PATHWAYEVENT`, `PATHWAY`
  - `LEFT JOIN Q_PROVIDER`, `Q_HRFORM`, `CLOSINGREASONS`
  - `LEFT JOIN` to BCR form views using `CLIENT_NUMBER`, `PATHWAY_DATE`, and `EVENT_NAME`

- **Output Fields:**
  - Client identifiers and names
  - Enrollment and pathway dates
  - Event metadata and form DOCSERNOs
  - Program participation descriptions
  - Program worker and agency details

## Maintenance Notes

- If new BCR event types or forms are introduced, extend the CASE logic and join structure accordingly.
- Ensure form views remain filtered to `DOCREVNO = ' 0 '` and include `EVENT_NAME` for alignment.
- Monitor for changes in event naming conventions that could affect CASE logic or join keys.
- Consider indexing `PATHWAYEVENTCLIENT` and form views on `CLIENT_NUMBER`, `PATHWAY_DATE`, and `EVENT_NAME` for performance.

## Changelog

- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation.
- **2025-07-13**: Replaces direct `INNER JOIN` to `PATHWAYCLIENT` with dual `JOIN` strategy using DOCSERNO and enrollment/start date alignment.
- **2025-07-13**: Adds logic to trace enrollment-to-pathway attribution, consistent with bcr and EPICC view architecture.
- **2025-07-09**: Adds initial view definition.
