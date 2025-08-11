# Q_BCR_CLIENT_COUNSELING_SESSIONS

**Category:** View Definitions  
**Source File:** `code/view-definitions/bcr-client-counseling-sessions.sql`  
**Last Updated:** 2025-07-31  
**Author:** BHN Data Team  

## Purpose

Tracks client counseling sessions funded by ARPA or DMH grants under the Bridges to Care & Recovery (BCR) program. Clients are typically authorized for up to five counseling sessions, but exceptions may be granted for additional sessions at staff discretion.  
This view consolidates session-level detail for audit, monitoring, and reporting.

## Description

- Source table: `PWBCRCLIENTCOUNSELINGSESSIONS`  
- Includes core session details (`SESSION_DATE`, `SESSION_FORMAT`) and key grant fields  
- Filters to latest revision only (`DOCREVNO = ' 0 '`)
- Joins with:
  - `Q_CLIENT_BHN` for `CLIENT_NUMBER`
  - `BCR_GRANT` for grant descriptions
  - `BCR_COUNSELING_AGENCIES` for agency descriptions

## Columns Returned

| Field                        | Description                                     |
|-----------------------------|-------------------------------------------------|
| `ID`                        | Internal record identifier                      |
| `DOCSERNO`                  | Document serial number for session              |
| `VISITDT`, `VISITTM`        | Timestamp of record save                        |
| `USERID`                    | Staff who submitted the form                    |
| `CLIENT_NUMBER`             | Unique client ID from BHN client view           |
| `PATHWAY_DATE`              | Pathway form completion date                         |
| `SESSION_DATE`              | Date of counseling session                      |
| `SESSION_FORMAT`            | Indicates in-person, virtual, or hybrid session |
| `SESSION_GRANT_CODE`        | Grant source code (e.g., '003', '004')             |
| `SESSION_GRANT_DESCRIPTION` | Full label for grant codes (e.g., 'ARPA', 'DMH')                       |
| `COUNSELING_AGENCY_CODE`    | Code for session-providing agency               |
| `COUNSELING_AGENCY_DESCRIPTION` | Full agency name or label                  |

## Maintenance Notes

- Grant descriptions pulled via LEFT JOIN — missing descriptions may indicate unmapped or invalid codes.
- Agency names also pulled via LEFT JOIN — verify `BCR_COUNSELING_AGENCIES` for up-to-date labels.
- Consider audit flag for clients exceeding five funded sessions in future enhancements.

## Changelog

- **2025-07-28**: Initial Markdown documentation authored.
- **2025-07-02**: Initial view definition authored.
