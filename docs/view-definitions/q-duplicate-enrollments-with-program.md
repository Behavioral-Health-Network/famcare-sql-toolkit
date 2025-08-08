# Q_DUPLICATE_ENROLLMENTS_WITH_PROGRAM

**Category:** View Definitions  
**Source File:** `code/views/q-duplciate-enrollments-with-program.sql`  
**Last Updated:** 2025-08-07  
**Author:** BHN Data Team  

## Purpose

Surfaces cases where a client has multiple enrollments with the same `ENROLLMENT_STARTING_DATE`, indicating potential duplication. Includes program context and enrollment metadata to support audit and remediation.

## Description

- Source table: `Q_PROVIDERPLACEMENT_BHN`
- Identifies duplicate enrollment groups by grouping on `CLIENT_NUMBER` and `ENROLLMENT_STARTING_DATE` in `Q_PROVIDERPLACEMENT_BHN`
- Filters to groups with `COUNT(*) > 1`
- Joins back to the source table to return full enrollment records for affected clients
- Flags each record with `'Duplicate Start Date'` in the `ENROLLMENT_ISSUE` column
- Intended for internal audit and data quality review  
- Can be extended to include dismissal logic or additional program metadata if needed

## Columns Returned

| Field                        | Description                                     |
|-----------------------------|-------------------------------------------------|
| `CLIENT_NUMBER`         | Unique client identifier                         |
| `ENROLLMENT_STARTING_DATE` | Start date of the duplicated enrollment       |
| `PROGRAM_DESCRIPTION`   | Name of the program associated with the enrollment |
| `ENROLLMENT_DOCSERNO`   | Document serial number for the enrollment form   |
| `USERID`                | User who submitted the enrollment                |
| `ENROLLMENT_ISSUE`      | Hardcoded label: `'Duplicate Start Date'`        |

## Maintenance Notes

- Source logic depends on `Q_PROVIDERPLACEMENT_BHN`; changes to that view may affect results.
- May surface legitimate duplicates (e.g. multiple programs starting on same day); review context before remediation  

## Changelog

- 2025-08-07: Initial view definition authored.
