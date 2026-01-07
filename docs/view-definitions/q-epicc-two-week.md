---
front-matter-title: Q_EPICC_TWO_WEEK
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-epicc-two-week.sql
last_updated: 2025-12-16
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - epicc
tags:
  - tag1
  - tag2
dependencies:
  - name: pwepicc2weekfollowup
    type: html
    repo: famcare-html-form-code
  - name: pwepicc2weekfollowup
    type: table
    repo: none
  - name: q_client_bhn
    type: view
    repo: famcare-sql-toolkit
  - name: epicc-types-mat
    type: table
    repo: none
  - name: epicc-program-participation
    type: table
    repo: none
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# Q_EPICC_TWO_WEEK

## Purpose

Extracts and consolidates EPICC 2-week follow-up data for reporting, program tracking, and MAT engagement analysis. Includes client metadata, treatment path, program participation, and physician-prescribed MAT details.

## Description

- Pulls structured data from the `PWEPICC2WEEKFOLLOWUP` form.
- Enriches coded fields with descriptive metadata from lookup tables.
- Filters out test clients via `Q_CLIENT_BHN` and excludes non-current records.
- Supports analysis of client engagement, MAT prescribing, and regional transfers.

### Logic Summary

- **Source Table:**
  - `PWEPICC2WEEKFOLLOWUP` (aliased as `ETWOW`)

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client metadata and test client exclusion
  - `LEFT JOIN EPICC_PROGRAM_PARTICIPATION` for program participation descriptions
  - `LEFT JOIN EPICC_TYPES_MAT` (aliased twice) for MAT type descriptions:
    - `WHAT_MAT_PHYSICIAN_APPT_THIRTY_DAY`
    - `WHAT_MAT_PHYSICIAN_APPT_THIRTY_DAY_UNABLE_TO_CONTACT`

- **Key Filters:**
  - `DOCREVNO = ' 0 '` to isolate current records

- **Output Fields:**
  - Follow-up metadata: `VISITDT`, `USERID`, `PATHWAY_DATE`, `PARENT_DOCSERNO`
  - Engagement: appointment attendance, communication dates, intake status
  - MAT prescribing: physician appointment, MAT type and description
  - Program participation: code and description
  - Transfer and region: transfer flags, contact success, reengagement specialist date
  - Client status and pregnancy flags

## Maintenance Notes

- If new MAT types or program codes are introduced, ensure lookup tables are updated and joins remain valid.
- Monitor for changes in form structure, especially around transfer logic and appointment tracking.
- Consider surfacing diagnostic flags for missing MAT descriptions or ambiguous program participation codes.

## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

</details>

<details markdown="1">
  <summary><strong>2025</strong></summary>

### 2025

- **2025-12-30**: Updates field `VISITDT` to `VISIT_DATE` and field `VISITTM` to `VISIT_TIME`.
- **2025-12-16**: Adds field `WHY_NOT_MEET_PROG_ELIGIBILITY_TWO_WEEK`.
- **2025-11-18**: Adds fields `TREATMENT_PATH_TWO_WEEK_UNABLE_TO_CONTACT`, `MAT_PRESCRIBED_PHYSICIAN_TWO_WEEK_UNABLE_TO_CONTACT`, `WHAT_MAT_PHYSICIAN_APPT_TWO_WEEK_UNABLE_TO_CONTACT` aliased as `WHAT_MAT_PHYSICIAN_APPT_TWOW_UTC _CODE`, `REASON_NOT_PARTICIPATING_TWO_WEEK`, `REASON_NOT_ATTENDING_SUD_TX_TWO_WEEK`, `OTHER_REASON_NOT_ATTENDING_SUD_TX_TWO_WEEK`, `ATTENDING_SUD_TX_VERIFY_TWO_WEEK`, and `TRANSFER_TYPE_TWO_WEEK`. Adds left join to master table `EPICC_TYPES_MAT` to get descriptions for `WHAT_MAT_PHYSICIAN_APPT_TWO_WEEK`. Updates the list of dependencies in the frontmatter YAML to include joined tables.
- **2025-10-02**: Adds `TIEDENROLLMENT` field to provide a DOCSERNO that may be used for joining to the PATHWAYCLIENT DOCSERNO directly.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation.
- **2025-07-07**: Updates to use `Q_CLIENT_BHN` instead of `Q_CLIENT` for test client exclusion and standardized field naming.  
- **2025-05-05**: Adds initial SQL view definition to support EPICC 2-week follow-up reporting and MAT engagement tracking.

</details>
</details>
