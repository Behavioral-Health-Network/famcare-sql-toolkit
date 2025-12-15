---
front-matter-title: Q_BCR_EVENTS
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-bcr-events.sql
last_updated: 2025-08-09
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - bcr
tags:
  - tag1
  - tag2
dependencies:
  - value1
  - value2
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# Q_BCR_EVENTS

## Purpose

Tracks and consolidates data on events conducted under the Bridges to Care & Recovery (BCR) Program. Supports reporting on event types, attendance, grant funding, and outreach impact.

## Description

- Built on `PWBCREVENT`, filtered to exclude client-linked records (`CLIENTNUMBER IS NULL or blank`).
- Joins with `BCR_GRANT` to enrich event records with grant descriptions.
- Includes attendance breakdowns, event metadata, and qualitative notes.
- Designed for use in dashboards, grant reporting, and program evaluation.

### Logic Summary

- **Client Exclusion**
  - Filters out any records with a populated `CLIENTNUMBER` to isolate non-client events.

- **Grant Enrichment**
  - Joins with `BCR_GRANT` to retrieve human-readable descriptions for `EVENT_GRANT` codes.

- **Form Metadata**
  - Includes `DOCSERNO`, `VISITDT`, `VISITTM`, `USERID`, and `PARENTDOCSERNO` for traceability.

## Output Fields

| Field Name                     | Description |
|--------------------------------|-------------|
| `EVENT_TYPE`, `EVENT_NAME`, `EVENT_TOPIC`, `IF_OTHER_EXPLAIN` | Event classification and topic |
| `EVENT_FORMAT`, `EVENT_LOCATION` | Delivery method and venue |
| `TOTAL_NUM_ATTENDEES`, `NUM_ADULTS`, `NUM_YOUTH`, `NUM_PASTORS` | Attendance breakdown |
| `NUM_REQUESTED_FU`, `NUM_COMPLETED_SCREENS`, `NUM_INC_KNOWLEDGE` | Engagement and impact metrics |
| `EVENT_GRANT_CODE`, `EVENT_GRANT_DESCRIPTION` | Grant funding source |
| `ADDTL_NOTES_EVENT` | Free-text notes for context or follow-up |
| `VISITDT`, `VISITTM`, `USERID`, `PARENT_DOCSERNO` | Metadata for audit and reporting alignment |

## Maintenance Notes

- **Grant Table Alignment**: Ensure `BCR_GRANT` remains current and aligned with form codes.
- **Client Filtering**: Logic assumes blank or null `CLIENTNUMBER` indicates non-client event; validate against form changes.
- **Field Expansion**: If new attendance categories or engagement metrics are added, update SELECT and documentation accordingly.
- **Qualitative Fields**: Consider standardizing `ADDTL_NOTES_EVENT` entries for easier analysis.

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

- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation.  
- **2025-06-27**: Adds initial view definition to support BCR event tracking and grant reporting.

</details>
</details>
