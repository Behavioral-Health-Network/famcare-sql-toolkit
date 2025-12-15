---
front-matter-title: Q_PROVIDER_BHN
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-provider-bhn.sql
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
schema_version: 1.0
---

# Q_PROVIDER_BHN

## Purpose

Encapsulate reusable logic for provider metadata, including program, agency, and organizational hierarchy details.

## Description

- Built on `Q_PROVIDER`, filtered to current revision records.
- Returns one row per provider entity, including:
  - Program and agency codes
  - Parent organization relationships
  - Provider status and type
- Used as a lookup table for joins to enrollment, referral, and hierarchy views.
- Supports reporting on program-agency relationships, provider status, and organizational structure.

## Maintenance Notes

- Ensure field mappings remain aligned with upstream `Q_PROVIDER` structure.
- If new organization types or hierarchy fields are introduced, update SELECT and documentation accordingly.
- Used by views such as `Q_PROGRAM_AGENCY_BRIDGE`, `Q_PROVIDERPLACEMENT_BHN`, and others—changes may affect multiple dependencies.

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

- **2025-12-12**: Adds collapsible `<details>` elements to the Changelog section.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-10**: Adds initial Markdown documentation.
- **2025-06-28**: Adds initial view definition.  

</details>
</details>
