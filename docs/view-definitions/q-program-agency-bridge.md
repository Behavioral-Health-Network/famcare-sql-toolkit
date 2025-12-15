---
front-matter-title: Q_PROGRAM_AGENCY_BRIDGE
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-program-agency-bridge.sql
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
  - value1
  - value2
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0 # indicates the version of the frontmatter schema
---

# Q_PROGRAM_AGENCY_BRIDGE

## Purpose

Provides a normalized bridge between programs (parent organizations) and agencies (site providers) in the BHN provider hierarchy. Supports reporting, filtering, and analysis by valid program/agency pairings, especially where agencies serve multiple programs.

## Description

- Built on `PROVIDERHEIRARCHY`, joined to `Q_PROVIDER_BHN` for both parent and child provider metadata.
- Filters out self-matches and the master provider (`100001`) to ensure only valid program/agency relationships are returned.
- Includes only agencies (`ORGANIZATION_TYPE = 'SP'`) as child entities.

### Logic Summary

- **Parent Join**
  - Maps `ALLOWABLEPROVIDER` to `Q_PROVIDER_BHN` to retrieve program metadata.
  - Excludes master provider (`100001`) from parent list.

- **Agency Join**
  - Maps `PROVIDERCODE` to `Q_PROVIDER_BHN` to retrieve agency metadata.
  - Filters to agencies only (`ORGANIZATION_TYPE = 'SP'`).
  - Excludes cases where agency is its own parent.

## Output Fields

| Field Name                 | Description |
|----------------------------|-------------|
| `PARENT_ORGANIZATION_CODE` | Provider code for the program (parent organization) |
| `PARENT_ORGANIZATION_NAME` | Name of the program |
| `AGENCY_CODE`              | Provider code for the agency (site provider) |
| `AGENCY_NAME`              | Name of the agency |
| `PROVIDER_STATUS`          | Status of the agency provider (e.g., Active, Inactive) |

## Usage Notes

- Use this view to join with enrollment, client, or reporting views to filter or group by program/agency combinations.
- Supports disambiguation of agencies that serve multiple programs.
- Can be used to validate program assignments in `Q_PROVIDERPLACEMENT_BHN` or other enrollment views.

## Maintenance Notes

- **Hierarchy Integrity**: Changes to `PROVIDERHEIRARCHY` may affect mappings; validate after updates.
- **Provider Metadata**: Ensure `Q_PROVIDER_BHN` remains aligned with provider codes and organization types.
- **Master Provider Exclusion**: Confirm that `100001` remains the designated master provider code.

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
- **2025-08-10**: Adds initial Markdown documentation.  
- **2025-06-28**: Adds initial view definition to support normalized program/agency mapping.

</details>
</details>
