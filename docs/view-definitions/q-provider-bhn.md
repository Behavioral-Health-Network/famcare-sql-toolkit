# Q_PROVIDER_BHN

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-provider-bhn.sql`  
**Last Updated:** 2025-08-10  
**Author:** BHN Data Team  

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

- **2025-06-28**: Initial view definition authored.  
- **2025-08-10**: Initial Markdown documentation authored.
