---
front-matter-title: Q_BCR_CLIENT_COUNSELING_SESSIONS
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-bcr-client-counseling-sessions.sql
last_updated: 2025-11-07
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
  - name: 
    type: 
    repo: 
  - name: 
    type: 
    repo: 
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# Q_BCR_CLIENT_COUNSELING_SESSIONS

## Purpose

Tracks client counseling sessions funded by ARPA or DMH grants under the Bridges to Care & Recovery (BCR) program. Clients are typically authorized for up to five counseling sessions, but exceptions may be granted for additional sessions at staff discretion. This view consolidates session-level detail for audit, monitoring, and reporting.

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

- **2025-11-07**: Removes `SESSION_GRANT_DESCRIPTION` and remove the alias for `SESSION_GRANT_CODE` so that the only column is now `SESSION_GRANT` to accommodate for the fact that the field no longer uses a master table to supply a LOV. The legacy values for `SESSION_GRANT` have already been recoded to change code values to the description values so that recoding need not happen in R or elsewhere.
- **2025-10-02**: Adds `TIEDENROLLMENT` field to provide a DOCSERNO that may be used for joining to the PATHWAYCLIENT DOCSERNO directly.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-07-28**: Adds initial Markdown documentation.
- **2025-07-02**: Adds initial view definition.
