---
front-matter-title: Q_EPICC_REFERRAL
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-epicc-referral.sql
last_updated: 2025-12-12
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
  - name: pwepiccreferral
    type: html
    repo: famcare-html-form-code
  - name: pwepiccreferral
    type: table
    repo: none
  - name: q_client_bhn
    type: view
    repo: famcare-sql-toolkit
  - name: program-referral-sources
    type: table
    repo: none
  - name: community-referral-source
    type: table
    repo: none
  - name: epicc-ems-fire-district
    type: table
    repo: none
  - name: epicc-program-participation
    type: table
    repo: none
  - name: program-referral-sources
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

# Q_EPICC_REFERRAL

## Purpose

Extracts and consolidates EPICC referral data for reporting, eligibility tracking, and program evaluation. Includes client metadata, referral sources, EMS involvement, and program participation flags.

## Description

- Pulls structured data from the `PWEPICCREFERRAL` form.
- Enriches coded fields with descriptive metadata from multiple lookup tables.
- Filters out test clients via `Q_CLIENT_BHN` and excludes non-current records.
- Supports analysis of referral pathways, EMS transport, and client eligibility.

### Logic Summary

- **Source Table:**
  - `PWEPICCREFERRAL` (aliased as `EREF`)

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client metadata and test client exclusion
  - `LEFT JOIN PROGRAM_REFERRAL_SOURCES` for referring agency and EMS transport descriptions
  - `LEFT JOIN COMMUNITY_REFERRAL_SOURCE` for community referral descriptions
  - `LEFT JOIN EPICC_EMS_FIRE_DISTRICT` for EMS/fire district descriptions
  - `LEFT JOIN EPICC_PROGRAM_PARTICIPATION` for program participation descriptions

- **Key Filters:**
  - `DOCREVNO = ' 0 '` to isolate current records

- **Output Fields:**
  - Referral metadata: `VISITDT`, `USERID`, `PATHWAY_DATE`, `REFERRER_NAME`, `REFERRER_PHONE`
  - Referral sources: agency codes and descriptions, community source, EMS/fire district
  - EMS involvement: suboxone administration, transport, emergency response
  - Law enforcement: police custody, LEO involvement
  - Program participation: EPICC flags, ineligibility reasons
  - Notes and context: `PRESENTING_NOTES`, ADA list, DM3700 status

## Maintenance Notes

- If new referral codes or EMS transport types are introduced, ensure lookup tables are updated and joins remain valid.
- Monitor for changes in form structure, especially around EMS flags and program eligibility logic.
- Consider surfacing diagnostic flags for missing referral descriptions or ambiguous EMS transport codes.

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
- **2025-12-12**: Adds field `OTHER_EMS_FIRE_DISTRICT`. Adds collapsible `<details>` elements.
- **2025-11-18**: Adds field `INELIGIBLE_REFERRAL`. Updates the list of dependencies in the frontmatter YAML to include joined tables.
- **2025-10-02**: Adds `TIEDENROLLMENT` field to provide a DOCSERNO that may be used for joining to the PATHWAYCLIENT DOCSERNO directly.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation.  
- **2025-07-21**: Updates to use `Q_CLIENT_BHN` instead of `Q_CLIENT` for test client exclusion and standardized field naming  
- **2025-05-01**: Adds initial view definition to support EPICC referral reporting and EMS involvement tracking

</details>
</details>
