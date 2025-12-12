---
front-matter-title: Q_EPICC_EVENTS
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-epicc-events.sql
last_updated: 2025-12-12
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - epicc
tags:
  - sql-view
  - non-client-form
dependencies:
  - name: pwepiccevents
    type: html
    repo: famcare-html-form-code
  - name: pwepiccevents
    type: table
    repo: none
  - name: program-referral-sources
    type: table
    repo: none
  - name: epicc-ems-fire-district
    type: table
    repo: none
  - name: hrform
    type: table
    repo: none
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-12-12
last_reviewed: 2025-12-12
schema_version: 1.0
---

# Q_EPICC_EVENTS

## Purpose

Extracts and consolidates the non-client EPICC Events form data for reporting and program evaluation.

## Description

- The view `Q_EPICC_EVENTS` standardizes and exposes data from the `PWEPICCEVENTS` form, focusing on non-client EPICC event records used for outreach, inservice, and program evaluation.
- The view adds staff identifiers and names (via `Q_HRFORM`) and contextual location descriptions (via `PROGRAM_REFERRAL_SOURCES` and `EPICC_EMS_FIRE_DISTRICT`).
- The output consolidates event metadata, outreach/inservice types, materials distributed, and contact information, enabling downstream reporting on program reach, staff activity, and community engagement.

### Logic Summary

- **Source Table:**
  - `PWEPICCEVENTS` (aliased as `EEVENTS`)

- **Joins:**
  - `LEFT JOIN PROGRAM_REFERRAL_SOURCES` (aliased twice) for inservice and outreach hospital locations
    - `INSERVICE_HOSP_LOCATION_DESCRIPTION`
    - `OUTREACH_HOSP_LOCATION_DESCRIPTION`
  - `LEFT JOIN HRFORM` for staff name
  - `LEFT JOIN EPICC_EMS_FIRE_DISTRICT` (aliased twice) for inservice and outreach EMS/Fire District locations
    - `INSERVICE_EMS_FIRE_LOCATION_DESCRIPTION`
    - `OUTREACH_EMS_FIRE_LOCATION_DESCRIPTION`

- **Key Filters:**
  - `DOCREVNO = ' 0 '` to isolate current records

- **Output Fields:**
  - Event metadata: `VISITDT`, `USERID`, `PATHWAY_DATE`, `PARENT_DOCSERNO`

## Maintenance Notes

- If new referral sources and EMS/Fire District locations are introduced, ensure lookup tables are updated and joins remain valid.
- Monitor for changes in form structure, especially around `EPICC_EVENTS_MATERIALS_DISTRIBUTED`, since this is pivoted using `updateReportFields()`.

## Changelog

- **2025-12-12**: Adds initial view definition and Markdown documentation.
- **2025-10-14**: Adds initial HTML form.
