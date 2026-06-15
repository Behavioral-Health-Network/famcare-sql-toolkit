---
front-matter-title: BHN View and Table Dependencies View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-bhn-view-and-table-dependencies.sql
last_updated: 2026-06-15
author: Bradley Wing
status: active
lifecycle: production
program_scope: none
programs:
  - none
tags:
  - view-layer
dependencies:
  - value1
  - value2
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# BHN View and Table Dependencies View Definition

## Purpose

Identifies dependencies between BHN SQL objects (views, tables, and functions) to support governance, lineage mapping, program‑specific impact analysis, and change‑scope workflows across BHN’s reporting ecosystem.

This view is the first stage of the lineage pipeline and is used to:

- identify upstream and downstream impacts of SQL assets
- support program‑specific change‑scope workflows
- classify assets as program‑specific, BHN‑wide, or administrative
- feed `Q_BHN_FULL_DEPENDENCY_LINEAGE` and downstream documentation/reporting tools

It ensures that only BHN‑owned and curated vendor assets participate in lineage expansion.

## Description

- Extracts dependency relationships from `sys.sql_expression_dependencies`
- Normalizes referencing and referenced object names by removing database and schema prefixes  
  (e.g., `BEHAVHEALT_LIVE.DBO.Q_EPICC_PATHCLIENT_ENROLLMENTS` → `Q_EPICC_PATHCLIENT_ENROLLMENTS`)
- Filters to BHN‑owned SQL objects and curated vendor tables
- Produces a clean, join‑ready dependency map for downstream lineage expansion
- Assigns values to `PROGRAM_SCOPE` and `PROGRAMS` in alignment with the documentation metadata model:
  - `PROGRAM_SCOPE` ∈ (`single`, `all`, `none`)
  - `PROGRAMS` ∈ (`epicc`, `complex-care`, `bcr`, `ere`, `yere`, `none`) or empty when `PROGRAM_SCOPE = 'all'`
- SQL Server 2014 compatible (no regex, no `STRING_SPLIT`, no JSON functions)

## Columns Returned

| Field                          | Description                                                                                     |
|--------------------------------|-------------------------------------------------------------------------------------------------|
| `REFERENCING_SCHEMA`           | Schema of the referencing SQL object                                                            |
| `REFERENCING_NAME`             | Name of the referencing SQL object                                                              |
| `REFERENCED_SCHEMA`            | Schema of the referenced SQL object                                                             |
| `REFERENCED_NAME`              | Name of the referenced SQL object                                                               |
| `REFERENCING`                  | Two‑part name of the referencing object                                                         |
| `REFERENCED`                   | Two‑part name of the referenced object                                                          |
| `NORMALIZED_REFERENCING_NAME`  | Referencing object name without schema/db prefixes                                              |
| `NORMALIZED_REFERENCED_NAME`   | Referenced object name without schema/db prefixes                                               |
| `PROGRAM_SCOPE`                | Classification describing whether an asset applies to one program, all programs, or no programs |
| `PROGRAMS`                     | The program an asset belongs to, expressed as a normalized acronym                              |

## Program Assignment Logic

Program metadata is derived from naming conventions in SQL object names:

- Objects beginning with `Q_EPICC_` or `PWEPICC%` → EPICC  
- Objects beginning with `Q_YERE_` or `PWYERE%` → YERE  
- Objects beginning with `Q_COMPLEX_CARE_` or `PWCOMPLEXCARE%` → COMPLEX‑CARE  
- Objects beginning with `Q_BCR_` → BCR  
- Objects beginning with `Q_ERE_` → ERE  
- Objects beginning with `Q_` but not matching any program prefix → **all‑program**  
- Objects beginning with `Q_%_BHN` → BHN‑wide (“all‑program”)  
- Objects beginning with `Q_%` but not matching any program prefix → BHN‑wide (“all‑program”)
- Objects not matching any BHN naming convention → **none** (administrative or governance assets)

This classification aligns with BHN’s documentation metadata model and ensures consistent filtering across lineage, documentation, and change‑scope workflows.

## Inclusion Logic

### Referencing objects (left‑hand side of dependency)

Included if they match any of:

- Program‑specific prefixes (`Q_EPICC_%`, `Q_YERE_%`, `Q_COMPLEX_CARE_%`, `Q_BCR_%`, `Q_ERE_%`)
- Program‑specific PW objects (`PWEPICC%`, `PWYERE%`, `PWCOMPLEXCARE%`, `PWBCR%`, `PWERE%`)
- BHN‑wide views (`Q_%_BHN`)
- Synthetic BHN core tables (added via `UNION ALL`)

### Referenced objects (right‑hand side of dependency)

Included if they match any of:

- Program‑specific prefixes  
- Program‑specific PW objects  
- Curated vendor tables:  
  `CLIENT`, `CASENOTEDETAIL`, `CLIENTPASSPORT`,  
  `PROVIDERPLACEMENT`, `PROVIDER`, `PATHWAY`,  
  `PATHWAYEVENT`, `PATHWAYCLIENT`, `PATHWAYEVENTCLIENT`

This ensures the dependency graph includes:

- program assets  
- BHN‑wide assets  
- core operational tables  
- curated vendor tables  
- no vendor noise  

## Synthetic Core Table Dependencies

To ensure core BHN tables appear as first‑class lineage assets, the view injects self‑dependencies for:

- CLIENT  
- CASENOTEDETAIL  
- CLIENTPASSPORT  
- PROVIDERPLACEMENT  
- PROVIDER  
- PATHWAY  
- PATHWAYEVENT  
- PATHWAYCLIENT  
- PATHWAYEVENTCLIENT  

These are assigned:

- `PROGRAM_SCOPE = 'all'`  
- `PROGRAMS = ''`  

This allows them to appear in dependency selectors even when no Q_ view references them directly.

## Maintenance Notes

- Dependencies are extracted from SQL Server’s native dependency catalog (`sys.sql_expression_dependencies`).
- Normalization uses `PARSENAME` to reliably extract the object name from 1‑, 2‑, or 3‑part identifiers.
- Vendor tables are explicitly whitelisted to avoid false positives.
- Program classification is naming‑convention‑driven and should be updated if new programs are added.
- Synthetic BHN‑wide tables should be updated if new core tables are introduced.
- This view is intended as a source for downstream lineage expansion (e.g., `Q_BHN_ALL_DEPENDENCIES`, `Q_BHN_FULL_DEPENDENCY_LINEAGE`).

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

- **2026‑02‑04**: Adds `PROGRAM_SCOPE` and `PROGRAMS` metadata. Adds initial Markdown documentation file for view definition.
- **2025-12-31**: Adds initial SQL view definition.
<!---CHANGELOG-END--->
