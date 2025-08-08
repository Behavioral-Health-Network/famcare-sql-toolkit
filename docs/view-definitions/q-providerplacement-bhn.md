# Q_PROVIDERPLACEMENT_BHN

**Category:** View Definitions  
**Source File:** `code/q-providerplacement-bhn.sql`  
**Last Updated:** 2025-07-31  
**Author:** BHN Data Team  

## Purpose

Encapsulate reusable logic for reporting or downstream joins.

## Description

- Consolidates enrollment data from `PROVIDERPLACEMENT`, including start/end dates, dismissal reason, program, agency, and pathway metadata.
- Joins to `Q_CLIENT_BHN` to exclude test clients and ensure valid client records.
- Joins to `Q_PROVIDER` to retrieve program descriptions via `REGION` code.
- Joins to `CLOSINGREASONS` and `MASTERSERVICE` to provide dismissal and service descriptions.
- Filters to current records only (`DOCREVNO = ' 0 '`).
- Formats key date fields for consistency in reporting.
- Designed to support fiscal-period reporting and downstream joins to `PATHWAYCLIENT` and `PATHWAYEVENTCLIENT`.

## Maintenance Notes

- Changes to `PROVIDERPLACEMENT`, `Q_CLIENT_BHN`, `Q_PROVIDER`, `CLOSINGREASONS`, or `MASTERSERVICE` may affect this view.
- Update test client exclusion logic if naming conventions change.
- Additional descriptive fields can be added as needed for reporting requirements.

## Changelog

- 2025-06-12: Initial view definition authored.
