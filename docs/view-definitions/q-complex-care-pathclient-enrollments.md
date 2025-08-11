# Q_COMPLEX_CARE_PATHCLIENT_ENROLLMENTS

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-complex-care-pathclient-enrollments.sql`  
**Last Updated:** **2025-08-10**  
**Author:** BHN Data Team  

## Purpose

Extracts and consolidates enrollment and event data for clients participating in the **Complex Care** Pathway.  
Supports reporting on enrollment timelines, dismissal reasons, program worker assignments, and Pathway event completion.

## Description

- Built on `PROVIDERPLACEMENT`, joined with `PATHWAYCLIENT`, `PATHWAYEVENTCLIENT`, and `PATHWAYEVENT` to surface Pathway participation and event tracking.
- Filters to Pathway ID `55320240920114308822` (Complex Care).
- Joins with `Q_CLIENT_BHN` to exclude test clients.
- Enriches dismissal reasons, agency names, and program worker details via lookup tables.
- Includes logic to match Complex Care-specific forms (e.g., Roster) to Pathway events.

### Logic Summary

- **Client Join**
  - Uses `Q_CLIENT_BHN` to exclude test clients based on last name variants.

- **Pathway Matching**
  - Filters to Complex Care Pathway ID.
  - Joins `PATHWAYCLIENT` using both direct and fallback logic to handle imported records.

- **Event Matching**
  - Joins `PATHWAYEVENTCLIENT` and `PATHWAYEVENT` to surface event metadata.
  - Calculates `DAYS_UNTIL_FORM_DUE` if `DATEACCOMPLISHED` is missing.

- **Roster Matching**
  - Joins `Q_COMPLEX_CARE_ROSTER` to match event completion to form submission.

- **Worker Metadata**
  - Joins `Q_HRFORM` for program worker and supervisor details.

## Output Fields

| Field Name                         | Description |
|------------------------------------|-------------|
| `CLIENT_NUMBER`                    | Unique client identifier |
| `ENROLLMENT_STARTING_DATE`, `ENROLLMENT_ENDING_DATE` | Program enrollment dates |
| `DISMISSAL_REASON_DESCRIPTION`     | Reason for program exit |
| `PP_DOCSERNO`, `PC_DOCSERNO`, `PEC_PATHCLIENT_DOCSERNO` | Document references |
| `AGENCY_DESCRIPTION`              | Name of assigned agency |
| `PWY_START_DATE`, `PWY_END_DATE`   | Pathway participation dates |
| `PWY_EVENT`                        | Name of Pathway event |
| `PWY_FORMS_DOCSERNO`              | Matched form DOCSERNO for Complex Care Roster |
| `EVENT_START_DATE`, `EVENT_END_DATE`, `PE_DATE_ACCOMPLISHED` | Event timing |
| `DAYS_UNTIL_FORM_DUE`             | Countdown to event deadline |
| `CURRENT_MESSAGE`                 | Status message from event record |
| `PROGRAM_WORKER_FIRST`, `PROGRAM_WORKER_LAST` | Assigned staff member |

## Maintenance Notes

- **Pathway ID Filter**: Hardcoded to `55320240920114308822`; confirm this remains valid for Complex Care.
- **Form Matching Logic**: Ensure `ROSTER.EVENT_NAME = PE.SHORTDESCRIPTION` remains aligned with naming conventions.
- **Join Integrity**: Changes to `PROVIDERPLACEMENT`, `PATHWAYCLIENT`, `PATHWAYEVENTCLIENT`, or `Q_HRFORM` may affect logic.
- **Test Client Filtering**: Confirm `Q_CLIENT_BHN` continues to exclude test clients reliably.

## Changelog

- **2025-08-10**: Initial Markdown documentation authored.  
- **2025-08-10**: View created to support Complex Care Pathway enrollment and event tracking.
