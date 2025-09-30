---
front-matter-title: Q_PROVIDERPLACEMENT_BHN
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-providerplacement-bhn.sql
last_updated: 2025-08-10
author: Bradley Wing
status: active
lifecycle: production
program_scope: multi
programs:
  - bcr
  - complex-care
  - epicc
  - ere
  - yere
tags:
  - tag1
  - tag2
dependencies:
  - name: providerplacement
    type: html
    repo: famcare-html-form-code
  - name: providerplacement
    type: table
    repo: none
  - name: q-provider
    type: sql
    repo: famcare-sql-toolkit
  - name: provider
    type: html
    repo: famcare-html-form-code
  - name: provider
    type: table
    repo: none
  - name: closingreasons
    type: table
    repo: none
  - name: masterservice
    type: table
    repo: none
  - name: q-client-bhn
    type: sql
    repo: famcare-sql-toolkit    
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# Q_PROVIDERPLACEMENT_BHN

## Purpose

Consolidates client enrollment records from the `PROVIDERPLACEMENT` table, enriched with descriptive metadata for program, agency, service, and dismissal reason. Supports reporting on program entry, assignment, transfer, and dismissal across BHN programs.  

## Description

- Consolidates enrollment data from `PROVIDERPLACEMENT`, including start/end dates, dismissal reason, program, agency, and pathway metadata.
- Joins to `Q_CLIENT_BHN` to exclude test clients and ensure valid client metadata.
- Joins to `Q_PROVIDER` to retrieve program descriptions via `REGION` code.
- Joins to `CLOSINGREASONS` and `MASTERSERVICE` to provide dismissal and service descriptions.
- Filters to current records only (`DOCREVNO = ' 0 '`).
- Formats key date fields for consistency in reporting.
- Designed to support fiscal-period enrollment tracking and reporting alignment through downstream joins to `PATHWAYCLIENT` and `PATHWAYEVENTCLIENT`.

### Logic Summary

- **Client Join**
  - Uses `Q_CLIENT_BHN` to exclude test clients based on last name variants.

- **Program Mapping**
  - Maps `REGION` to `PROVIDERCODE` in `Q_PROVIDER` to retrieve program descriptions.

- **Dismissal Reason**
  - Joins to `CLOSINGREASONS` for dismissal reason descriptions.

- **Service Description**
  - Joins to `MASTERSERVICE` for service code translation.

- **Date Formatting**
  - Converts all relevant date fields to `DATE` format for consistency.

## Output Fields

| Field Name                         | Description |
|------------------------------------|-------------|
| `CLIENT_NUMBER`, `DOCSERNO`, `PARENT_DOCSERNO` | Client and form identifiers |
| `DATE_ENTERED`, `ENROLLMENT_STARTING_DATE`, `ORIGINAL_ADMISSION_DATE`, `ENROLLMENT_ENDING_DATE` | Key enrollment dates |
| `DISMISSAL_REASON_CODE`, `DISMISSAL_REASON_DESCRIPTION` | Reason for program dismissal |
| `SERVICE_CODE`, `SERVICE_DESCRIPTION` | Service assigned during enrollment |
| `PROGRAM_CODE`, `PROGRAM_DESCRIPTION` | Program assigned via REGION code |
| `AGENCY_CODE`, `AGENCY_DESCRIPTION` | Agency assigned via PRIMARYPROVIDERCODE |
| `PATHWAY`, `PATHWAY_DATE`          | Pathway assignment metadata |
| `PROGRAM_WORKER`                   | Assigned program worker |

## Maintenance Notes

- **Test Client Exclusion**: Based on last name variants (`GVTTest`, `GVTest`, `GVTTEST`) in `Q_CLIENT_BHN`.
- **Code Set Changes**: Updates to `PROVIDERPLACEMENT`, `Q_CLIENT_BHN`, `Q_PROVIDER`, `CLOSINGREASONS`, or `MASTERSERVICE` may affect join integrity.
- **Descriptive Expansion**: Additional fields can be added from lookup tables as needed.
- **Form Linkage**: `DOCSERNO` and `PARENTDOCSERNO` support downstream joins to `PATHWAYCLIENT` and `PATHWAYEVENTCLIENT`.

## Changelog

- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-10**: Adds initial Markdown documentation.  
- **2025-06-28**: Updates to use `Q_CLIENT_BHN` for test client exclusion.  
- **2025-06-12**: Adds initial view definition to support BHN enrollment reporting.
