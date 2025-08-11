# Q_BCR_EVENTS

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-bcr-events.sql`  
**Last Updated:** **2025-08-09**  
**Author:** BHN Data Team  

## Purpose

Tracks and consolidates data on events conducted under the Bridges to Care & Recovery (BCR) Program.  
Supports reporting on event types, attendance, grant funding, and outreach impact.

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

- **2025-08-09**: Initial Markdown documentation authored.  
- **2025-06-27**: View created to support BCR event tracking and grant reporting.
